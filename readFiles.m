%docsFolder is the name of the folder containing the docs
%labelFolder is the name of the folder containing the labels
%assumes docs and corresponding labels files are in the same order
%each file must end with an empty line
function[docs labels] = readFiles(docFolder, labelFolder)

docNames = dir(docFolder);
labelNames = dir(labelFolder);

docs = [];
labels = [];
for i = 1:length(docNames)
    if length(strfind(docNames(i).name, '.txt')) > 0
        fd = fopen(strcat(docFolder,'/',docNames(i).name));
        fl = fopen(strcat(labelFolder,'/',labelNames(i).name));
        
        dline = fgets(fd);
        lline = fgets(fl);
        while ischar(dline)
            docs = [docs; cellstr(dline)];
            labels = [labels; cellstr(lline)];
            labels{end} = str2num(labels{end});
            dline = fgets(fd);
            lline = fgets(fl);
        end

        fclose(fd);
        fclose(fl);
    end
end