function [ feats ] = getFeatures( docs )
addpath('libraries/strnearest/');
%getFeatures Creates features from the given data. 
%   docs should be a cell array of cell arrays. The inner cell array is a
%   document and the outer one is a list of all the documents. labels
%   should be a cell array of vectors that label each line in a document.

% features is a 3d matrix each row represents the contents of a doc
% line_contains_day_expr, line_contains_date_expr, line_contains_time_expr
NUM_FEATS = 1;
% MAX_LINES = max(cellfun(@length, docs));
MAX_LINES = sum(cellfun(@length, docs));
% feats = zeros(length(docs), MAX_LINES, NUM_FEATS);
feats = ones(MAX_LINES, NUM_FEATS);

for i=1:length(docs)
    for j = 1:length(docs{i})
        offset = 0;
        if (i > 1)
            offset = sum(cellfun(@length, docs(1:i-1)));
        end
%         feats(i,j,3) = checkTimeExpr(docs{i}{j});
        feats(offset + j, 1) = checkTimeExpr(docs{i}{j});
        feats(offset + j, 2) = checkDayExpr(docs{i}{j});
    end
end

end

function [ weight ] = checkTimeExpr(val_to_check)
    assert(ischar(val_to_check));
%     regexps for classifying time. Goes from most strict to least strict
%     hour followed by opt separator followed by minutes followed by whitespace followed by am/pm
    timeExp1 = '((\d)|(\d\d)).?(\d\d)(\W)*?((a|A)|(p|P)(m)?)';
%     minutes are optional
    timeExp2 = '((\d)|(\d\d)).?(\d\d)?(\W)*?((a|A)|(p|P)(m)?)';
%     am/pm is optional
    timeExp3 = '((\d)|(\d\d)).?(\d\d)(\W)*?((a|A)|(p|P)(m)?)?';
%     minutes and am/pm is optional
    timeExp4 = '((\d)|(\d\d)).?(\d\d)?(\W)*?((a|A)|(p|P)(m)?)?';
%     matrix of all expressions
    EXPS = {'((\d)|(\d\d)).?(\d\d)(\W)*?((a|A)|(p|P)(m)?)';...
        '((\d)|(\d\d)).?(\d\d)?(\W)*?((a|A)|(p|P)(m)?)';...
        '((\d)|(\d\d)).?(\d\d)(\W)*?((a|A)|(p|P)(m)?)?';...
        '((\d)|(\d\d)).?(\d\d)(\W)*?((a|A)|(p|P)(m)?)?'};
    
    for i=1:length(EXPS)
%         the most strict match has highest weight
        if (regexp(val_to_check, EXPS{i}))
            weight = ((length(EXPS) - i) + 1) * 2;
            return;
        end
    end
    weight = 1;
end

function [ weight ] = checkDayExpr(val_to_check)
    assert(ischar(val_to_check));
    weight = 1;
    dayMonths = textread('days.csv', '%s', 'delimiter', '\n');
    days = strsplit(dayMonths{1});
    months = strsplit(dayMonths{2});
    valCell = strsplit(val_to_check);
%     find nearest matching string using Levenshtein dist
%     minD = 1000000000;
%     for i=1:length(valCell)
%         id = 1000000000;
%         dist = 1000000000;
%         if i==1
%             [id, dist] = strnearest(days, {valCell{i}}, 'case');
%         else
%             disp('YO');
%             [id, dist] = strnearest(days, {valCell{i}}, minD, 'case');
%         end
%         if dist < minD
%             minD = dist;
%         end
%     end
    [id, dist] = strnearest(days, valCell, 'case');
%     find word with smallest distance
    [minDist, index] = min(dist);
%     set first part of weight as 1/dist. If small dist, then word is close to match
%     avoid divide by 0 error. weight will be 1/dist so perfect match ->
%     weight = 1/2
    if (minDist == 0)
        minDist = 1/2;
    end
    weight = weight + 1/minDist;
%     weight(1) = 1/minDist;
%     do same thing for month
    [id, dist] = strnearest(months, valCell, 'case');
    [minDist, index] = min(dist);
    if (minDist == 0)
        minDist = 1/2;
    end
%     weight(2) = 1/minDist;
    weight = weight + 1/minDist;

%     regexps for classifying date. Goes from most strict to least strict
%     ##(sep)##(sep)##(##)
    dateExp1 = '((\d)|(\d\d))*((\d)|(\d\d))*((\d\d)|(\d\d\d\d))';
%     optional year
    dateExp2 = '((\d)|(\d\d))*((\d)|(\d\d))';
%     only date present
    timeExp3 = '((\d)|(\d\d))';
%     matrix of all expressions
    EXPS = {'((\d)|(\d\d))*((\d)|(\d\d))*((\d\d)|(\d\d\d\d))';...
        '((\d)|(\d\d))*((\d)|(\d\d))';...
        '((\d)|(\d\d))'};
    
    for i=1:length(EXPS)
%         the most strict match has highest weight
        if (regexp(val_to_check, EXPS{i}))
            weight = weight + ((length(EXPS) - i) + 1);
            return;
        end
    end
end

% function[ labels_mat ] = convertLabels(labels_cell)
% %     MAX_LINES = max(cellfun(@length, labels_cell));
%     MAX_LINES = sum(cellfun(@length, labels_cell));
% %     labels_mat = zeros(length(labels_cell), MAX_LINES);
%     labels_mat = zeros(MAX_LINES, 1);
%     for i=1:length(labels_cell)
%         offset = 0;
%         if (i > 1)
%             offset = sum(cellfun(@length, labels_cell(1:i-1)));
%         end
%         labels_mat(offset + 1:offset + length(labels_cell{i})) = labels_cell{i} + 1;
% %         labels_mat(i, 1:length(labels_cell{i})) = labels_cell{i};
%     end
% end
