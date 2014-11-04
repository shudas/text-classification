function [ date_time ] = randomTime( datetime_params )
%randomDate Generates a random time string given the desired parts of the
%time. datetime_params is a string containing H, M, or A
%determining whether to show hour, minute, am/pm respectively.

HOURS_FORMAT = {'HH'};
MINUTES_FORMAT = {'MM'};
AMPM_FORMAT = {'AM'};
AM_OPTS = {'AM', 'am', 'a'};
PM_OPTS = {'PM', 'pm', 'p'};
% use colons more frequently
TIME_SEP = {'.', ':', ':'};

timePortion = {};
dPCount = 1;
for i=1:length(datetime_params)
%     choose to use either yyyy or yy
    if (datetime_params(i) == 'H')
        timePortion{dPCount} = HOURS_FORMAT{randi(length(HOURS_FORMAT))};
    elseif (datetime_params(i) == 'M')
        timePortion{dPCount} = MINUTES_FORMAT{randi(length(MINUTES_FORMAT))};
    elseif (datetime_params(i) == 'A')
        timePortion{dPCount} = AMPM_FORMAT{randi(length(AMPM_FORMAT))};
    else
        continue;
    end
    dPCount = dPCount + 1;
end

% generate a random date
randHourMin = getRandTime();
% fill the hour and time portion of current time with random time
randTime = clock;
randTime(4:5) = randHourMin;

hourType = find(ismember(timePortion, HOURS_FORMAT), 1);
minuteType = find(ismember(timePortion, MINUTES_FORMAT), 1);
ampmType = find(ismember(timePortion, AMPM_FORMAT), 1);

hour = '';
if (~isempty(hourType))
    hour = datestr(randTime, timePortion{hourType});
%     remove leading 0
    if (~isempty(str2num(hour)))
        hour = str2num(hour);
%         get 12 hour time
        hour = mod(hour, 12);
        if (hour == 0)
            hour = 12;
        end
        hour = num2str(hour);
    end
    
end
minute = '';
if (~isempty(minuteType))
    minute = datestr(randTime, timePortion{minuteType});
%     dont use 00 part of the time for minutes
    if (strcmp(minute, '00') && randi(8) == 1)
        minute = '';
    end
end
ampm = '';
if (~isempty(ampmType))
    ampm = datestr(randTime, timePortion{ampmType});
%     choose a random representation of am/pm
    if (strcmp(ampm, 'AM'))
        ampm = AM_OPTS{randi(length(AM_OPTS))};
    else
        ampm = PM_OPTS{randi(length(PM_OPTS))};
    end
end

date_time = hour;
if (~strcmp(minute, ''))
    date_time = char(strcat({hour}, TIME_SEP{randi(length(TIME_SEP))}, {minute}));
end
% add a space between minute and am/pm
if (randi(2) == 1)
    date_time = char(strcat(date_time, {' '}));
end
date_time = char(strcat({date_time}, ampm));

end

function [ randTime ] = getRandTime( )
%     choose hour between 8 am and 11 pm
    randHour = randi([8 23]);
%     choose min as on the hour or every quarter of an hour
    randMin = randi(16);
%     1/16 prob being 45
    if (randMin == 16)
        randMin = 45;
%     1/16 prob being 15
    elseif (randMin == 15)
        randMin = 15;
%     1/8 prob being 30
    elseif (randMin > 12)
        randMin = 30;
%     3/4 prob being on the hour
    else
        randMin = 0;
    end
    randTime = [randHour randMin];
end

