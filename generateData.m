function [ docs ] = generateData( num_to_generate )
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

% Features:
NUM_FEATURES = 1;

% open up dictionary of words for filler text
dictFile = fopen('dictionary.txt', 'r');
dict = textscan(dictFile, '%s');
fclose(dictFile);

docs = cell(num_to_generate, 1);

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
       doc{j} = strjoin(dict{1}(wordIndices)');
    end
%     populate doc with random words and date and time
    docs{i} = doc;
end

end

