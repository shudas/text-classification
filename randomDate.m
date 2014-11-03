function [ date_time ] = randomDate( datetime_params )
%randomDate Generates a random date string given the desired parts of the
%date. datetime_params is a string containing y, m, d, D, H, M, or a
%standing for year, month, day, date, hour, minute, am/pm respectively.

YEARS = {'yyyy', 'yy'};
MONTHS = {'mmmm', 'mmm', 'mm'};
DAYS = {'dddd', 'ddd'};
DATES = {'dd'};
HOURS = {'HH'};
MINUTES = {'MM'};
AMPM = {'AM', 'PM'};

datePortion = {};

for i=1:length(datetime_params)
%     choose to use either yyyy or yy
    if (datetime_params(i) == 'y')
        datePortion{i} = YEARS{randi([1 numel(YEARS)])};
    elseif (datetime_params(i) == 'm')
        datePortion{i} = MONTHS{randi([1 numel(MONTHS)])};
    elseif (datetime_params(i) == 'd')
        datePortion{i} = DAYS{randi([1 numel(DAYS)])};
    elseif (datetime_params(i) == 'D')
        datePortion{i} = DATES{randi([1 numel(DATES)])};
    end
end

date_time = datePortion;

end

