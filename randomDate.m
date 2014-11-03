function [ date_time ] = randomDate( datetime_params )
%randomDate Generates a random date string given the desired parts of the
%date. datetime_params is a string containing y, m, d, D, H, M, or a
%standing for year, month, day, date, hour, minute, am/pm respectively.

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

datePortion

dayType = find(ismember(datePortion, DAYS_FORMAT), 1);
monthType = find(ismember(datePortion, MONTHS_FORMAT), 1);
dateType = find(ismember(datePortion, DATES_FORMAT), 1);
yearType = find(ismember(datePortion, YEARS_FORMAT));

if (~isempty(dayType))
    finalDate = strcat(finalDate, datestr(randDate, datePortion{dayType}));
    finalDate = strcat(finalDate, DAY_SEP{randi(length(DAY_SEP))}, {' '});
end

dateSep = '';
if (~isempty(monthType))
%     if month and date are both numbers, use a date separator
    mTypeVal = datePortion{monthType};
    if (~isempty(dateType))
        format = mTypeVal;
        dTypeVal = datePortion{dateType};
        if (strcmp(mTypeVal, 'mm'))
            dateSep = DATE_SEP{randi(length(DATE_SEP))};
            format = strcat(mTypeVal, dateSep, dTypeVal);
            finalDate = strcat(finalDate, datestr(randDate, format));
        else
%             indicates whether to use 'th' after date. 1/5 times we dont
%             use th.
            useTh = randi(5);
            dateFormat = dTypeVal;
            if (useTh > 1)
               dateFormat = strcat(dateFormat, 'th');
            end
%             one of 8 times we will use something like 12th Oct
            if (randi(8) == 1)
                format = char(strcat(dateFormat, {' '}, mTypeVal))
                finalDate = strcat(finalDate, datestr(randDate, format));
            else
                format = char(strcat(mTypeVal, DAY_SEP{randi(length(DAY_SEP))}, {' '}, dateFormat))
                finalDate = strcat(finalDate, datestr(randDate, format));
            end
            finalDate = strcat(finalDate, DAY_SEP{randi(length(DAY_SEP))}, {' '});
        end        
    else
        finalDate = strcat(finalDate, datestr(randDate, mTypeVal));
        finalDate = strcat(finalDate, DAY_SEP{randi(length(DAY_SEP))}, {' '});
    end
    
    
end

date_time = finalDate;

end

function [ randDate ] = getRandDate( )
% getRandDate generates a random datevec from year 1998 to now
    MAX_TIME = length([1:now]);
    MIN_TIME = 1998*365;
    randDate = datevec(randi([MIN_TIME MAX_TIME]));
end
