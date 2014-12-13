function[ labels_mat ] = convertLabels(labels_cell)
%convertLabels converts multiple document labels into a long single document label
%     MAX_LINES = sum(cellfun(@length, labels_cell));
%     labels_mat = zeros(MAX_LINES, 1);
%     for i=1:length(labels_cell)
%         offset = 0;
%         if (i > 1)
%             offset = sum(cellfun(@length, labels_cell(1:i-1)));
%         end
%         labels_mat(offset + 1:offset + length(labels_cell{i})) = labels_cell{i} + 1;
%     end
    labels_mat = vertcat(labels_cell{:}) + 1;
end

