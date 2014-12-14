function [ docs, labels ] = generateData( num_to_generate )
%generateData Generates fake text with date and time strings inside the
%text.
%   Generates num_to_generate arrays of text. Each array can be thought of
%   as a document with variable number of lines. Each document contains one
%   date field and may also contain a time field. The remaining text will
%   be random.

% num_to_generate must be at least 1 and an integer
num_to_generate = round(num_to_generate);
assert(num_to_generate >= 1, 'num_to_generate must be at least 1');

% 1/OPT_VS_EXTREME docs can have lengths ranging b/t MIN_LINES and
% MAX_LINES. The other docs will have lengths b/t MIN and MAX OPTIMAL_LINES
MAX_LINES = 30;
MAX_OPTIMAL_LINES = 20;
MIN_OPTIMAL_LINES = 10;
MIN_LINES = 5;
OPT_VS_EXTREME = 4;

MIN_WORDS_PER_LINE = 2;
MAX_WORDS_PER_LINE = 10;

DATE_TIME_SEP = {'   ', ' @ ', ' | '};

% open up dictionary of words, streets, and buildings for filler text
fileId = fopen('dictionary.txt', 'r');
dict = textscan(fileId, '%s');
fclose(fileId);
fileId = fopen('streetNames.txt', 'r');
global STREETS;
STREETS = textscan(fileId, '%s', 'Delimiter', '\n');
STREETS = STREETS{1};
fclose(fileId);
fileId = fopen('buildingNames.txt', 'r');
global BUILDINGS;
BUILDINGS = textscan(fileId, '%s', 'Delimiter', '\n');
BUILDINGS = BUILDINGS{1};
fclose(fileId);

docs = cell(num_to_generate, 1);
labels = cell(num_to_generate, 1);

% use different rand num gen every time
rng('shuffle');

for i = 1:num_to_generate
    docLines = MIN_OPTIMAL_LINES;
    maxOrOpt = randi([1 OPT_VS_EXTREME]);
    if (maxOrOpt == OPT_VS_EXTREME)
        docLines = randi([MIN_LINES, MAX_LINES]);
    else
        docLines = randi([MIN_OPTIMAL_LINES, MAX_OPTIMAL_LINES]);
    end
    doc = cell(docLines, 1);
%     generate lines of text
    for j = 1:docLines
        numWords = randi([MIN_WORDS_PER_LINE, MAX_WORDS_PER_LINE]);
        wordIndices = randperm(length(dict{1}), numWords);
        line = strjoin(dict{1}(wordIndices)');
%         add some noise to the line
        if (rand() < 0.4)
            line = addTextNoise(line, 1 / 8, 1 / 8);
        end
        doc{j} = line;
    end
    
    % generate line where phone number is
    phoneLine = randi(docLines + 4);
    
    % not all flyers will include phone line
    if (phoneLine <= docLines)
%         somtimes replace entire line but other times insert into line
        if (rand() < 0.5)
            doc{phoneLine} = generatePhoneNumber();
        else
            insertLoc = randi(length(doc{phoneLine}));
            doc{phoneLine} = char(strcat(doc{phoneLine}(1:insertLoc), {' '}, ...
            generatePhoneNumber(), {' '}, doc{phoneLine}(insertLoc+1:end)));
        end
        
    end
    location = generateLocation();
    doc{randi(docLines)} = location;
%     populate doc with random date and time
    date = generateDate();
    time = generateTime();
    dateTimeLines = [];
    label = zeros(docLines, 1);
%     some times, separate date and time into different spots
    if (randi(2) == 1 && docLines > 10)
%         select random lines for date and time locations
        dateTimeLines = randperm(docLines, 2);
        doc{dateTimeLines(1)} = date;
        doc{dateTimeLines(2)} = time;
%         1 means date label 2 means time label
        label(dateTimeLines(1)) = 1;
        label(dateTimeLines(2)) = 2;
    else
        dateTimeLines = repmat(randi(docLines), 1, 2);
        doc{dateTimeLines(1)} = char(strcat(date, {DATE_TIME_SEP{randi(length(DATE_TIME_SEP))}}, time));
%         3 means both date and time
        label(dateTimeLines(1)) = 3;
    end
    
    docs{i} = doc;
    labels{i} = label;
end
end

function [ date ] = generateDate( )
    combs = ['d', 'mD', 'dmD', 'dmDy'];
%     use day, month, date most frequently, then dmDy, then mD, then d
    choice = randi(16);
    if (choice == 16)
        date = randomDate('d');
    elseif (choice > 12)
        date = randomDate('mD');
    elseif (choice > 7)
        date = randomDate('dmD');
    else
        date = randomDate('dmDy');
    end
end

function [ time ] = generateTime( )
    combs = ['HA', 'HMA'];
%     use Hour and AM/PM more frequently than time with minutes
    choice = randi(16);
    if (choice == 16)
        time = randomTime('HMA');
    else
        time = randomTime('HA');
    end
end

function [ phone ] = generatePhoneNumber( )

    typeChoice = randi(16);
    if (typeChoice >= 7)
        generatedType = 'NPA';
    elseif (typeChoice >= 4)
        generatedType = 'EXTEND';
    else
        generatedType = 'NONE';
    end
        
    otherChoice = randi(64);
    if (otherChoice >= 60)
        phone = randomPhone(generatedType, 'TRUE', 'DASH');
    elseif (otherChoice >= 54)
        phone = randomPhone(generatedType, 'TRUE', 'END_DASH');
    elseif (otherChoice >= 50)
        phone = randomPhone(generatedType, 'TRUE', 'SPACE');
    elseif (otherChoice >= 48)
        phone = randomPhone(generatedType, 'TRUE', 'NONE');
    elseif (otherChoice >= 42)
        phone = randomPhone(generatedType, 'TRUE', 'SPACED_DASH');
    elseif (otherChoice >= 37)
        phone = randomPhone(generatedType, 'FALSE', 'DASH');
    elseif (otherChoice >= 33)
        phone = randomPhone(generatedType, 'FALSE', 'END_DASH');
    elseif (otherChoice >= 30)
        phone = randomPhone(generatedType, 'FALSE', 'PERIOD');
    elseif (otherChoice >= 26)
        phone = randomPhone(generatedType, 'FALSE', 'SPACE');
    elseif (otherChoice >= 23)
        phone = randomPhone(generatedType, 'FALSE', 'NONE');
    elseif (otherChoice >= 19)
        phone = randomPhone(generatedType, 'FALSE', 'SPACED_DASH');
    elseif (otherChoice >= 17)
        phone = randomPhone(generatedType, 'FALSE', 'SLASH');
    elseif (otherChoice >= 15)
        phone = randomPhone(generatedType, 'SPACED', 'DASH');
    elseif (otherChoice >= 9)
        phone = randomPhone(generatedType, 'SPACED', 'END_DASH');
    elseif (otherChoice >= 5)
        phone = randomPhone(generatedType, 'SPACED', 'SPACE');
    else
        phone = randomPhone(generatedType, 'SPACED', 'SPACED_DASH');
    end
end

function [ location ] = generateLocation( )
%   n = road number, R = road, e = road ending
%   b = building type, N = building number
%   c = city, S = state, Z = zipcode
    global STREETS;
    global BUILDINGS;
    combs = ['nRe', 'bN'];
    choice = randi(16);
    if (choice > 8)
        location = randomLocation('nRe', STREETS, BUILDINGS);
    else 
        location = randomLocation('bN', STREETS, BUILDINGS);
    end
end
