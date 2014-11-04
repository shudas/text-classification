function [ ret_date ] = randomDate( datetime_params )
%randomDate Generates a random date string given the desired parts of the
%date. datetime_params is a string containing y, m, d, D
%standing for year, month, day, and date respectively.

YEARS_FORMAT = {'yyyy', 'yy'};
MONTHS_FORMAT = {'mmmm', 'mmm', 'mm'};
DAYS_FORMAT = {'dddd', 'ddd'};
DATES_FORMAT = {'dd'};
HOURS_FORMAT = {'HH'};
MINUTES_FORMAT = {'MM'};
AMPM_FORMAT = {'AM', 'PM'};
DATE_SEP = {'/', '.', '-'};
DAY_SEP = {'.', ',', ''};

datePortion = {};
dPCount = 1;
for i=1:length(datetime_params)
%     choose to use either yyyy or yy
    if (datetime_params(i) == 'y')
        datePortion{dPCount} = YEARS_FORMAT{randi(length(YEARS_FORMAT))};
    elseif (datetime_params(i) == 'm')
        datePortion{dPCount} = MONTHS_FORMAT{randi(length(MONTHS_FORMAT))};
    elseif (datetime_params(i) == 'd')
        datePortion{dPCount} = DAYS_FORMAT{randi(length(DAYS_FORMAT))};
    elseif (datetime_params(i) == 'D')
        datePortion{dPCount} = DATES_FORMAT{randi(length(DATES_FORMAT))};
    else
        continue;
    end
    dPCount = dPCount + 1;
end

finalDate = '';
% generate a random date
randDate = getRandDate();

dayType = find(ismember(datePortion, DAYS_FORMAT), 1);
monthType = find(ismember(datePortion, MONTHS_FORMAT), 1);
dateType = find(ismember(datePortion, DATES_FORMAT), 1);
yearType = find(ismember(datePortion, YEARS_FORMAT));
dateSep = '';

day = '';
if (~isempty(dayType))
    day = datestr(randDate, datePortion{dayType});
    day = char(strcat(day, DAY_SEP{randi(length(DAY_SEP))}, {' '}));
end
date = '';
if (~isempty(dateType))
    date = datestr(randDate, datePortion{dateType});
%     dont use leading zero for numerical dates
    if (~isempty(str2num(date)))
        date = num2str(str2num(date));
    end
end
month = '';
if (~isempty(monthType))
    month = datestr(randDate, datePortion{monthType});
end
year = '';
if (~isempty(yearType))
%     if there is no month or no date, then use yyyy
    if (strcmp(month, '') || strcmp(date, ''))
        year = datestr(randDate, 'yyyy');
    else
        year = datestr(randDate, datePortion{yearType}); 
    end
    
end

monthDay = '';
% if month and date are both numbers, use a date separator
if (~isempty(str2num(month)) && ~isempty(str2num(date)))
    dateSep = DATE_SEP{randi(length(DATE_SEP))};
    monthDay = char(strcat(num2str(str2num(month)), dateSep, date));
else
%     concatenate month and day in random order
%     indicates whether to use 'th' after date. 1/5 times we dont use th.
    if (~strcmp(date, ''))
        useTh = randi(5);
        if (useTh > 1)
            date = strcat(date, 'th');
        end
        monthDay = date;
    end
    if (~strcmp(month, ''))
        %     one of 8 times we will put date before month
        month = strcat(month, DAY_SEP{randi(length(DAY_SEP))});
        monthDay = month;
        if (~strcmp(date, ''))
            if (randi(8) == 1 && ~strcmp(date, ''))
                monthDay = strcat(date, {' '}, month);
            else
                monthDay = strcat(month, {' '}, date);
            end
        end
        
    end
    if (~strcmp(monthDay, ''))
        monthDay = char(strcat(monthDay, {' '}));
    end    
end
% add the separator b/t month day and year if 
if (~strcmp(dateSep, '') && ~strcmp(year, ''))
   year = strcat(dateSep, year);
end
finalDate = char(strcat({day}, {monthDay}, {year}));
ret_date = finalDate;

end

function [ randDate ] = getRandDate( )
% getRandDate generates a random datevec from year 1998 to now
    MAX_TIME = length([1:now]);
    MIN_TIME = 1998*365;
    randDate = datevec(randi([MIN_TIME MAX_TIME]));
end

