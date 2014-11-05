function [ feats ] = getFeatures( docs, labels )
%getFeatures Creates features from the given data. 
%   docs should be a cell array of cell arrays. The inner cell array is a
%   document and the outer one is a list of all the documents. labels
%   should be a cell array of vectors that label each line in a document.

% features is a 3d matrix each row represents the contents of a doc
% line_contains_day_expr, line_contains_date_expr, line_contains_time_expr
NUM_FEATS = 3;
MAX_LINES = max(cellfun(@length, docs));
feats = zeros(length(docs), MAX_LINES, NUM_FEATS);

for i=1:length(docs)
    for j = 1:length(docs{i})
%         if line contains day expr, set the 1st val of innermost to 1
        
%         if line contains date expr, set the 2nd val of innermost to 1

%         if line contains time expr, set the 3rd val of innermost to 1
        feats(i,j,3) = checkTimeExpr(docs{i}{j});
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
            weight = (length(EXPS) - i) + 1;
            return;
        end
    end
    weight = 0;
end
