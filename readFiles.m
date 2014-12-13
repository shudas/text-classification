%docsFolder is the name of the folder containing the docs
%labelFolder is the name of the folder containing the labels
%assumes docs and corresponding labels files are in the same order
%each file must end with an empty line
function[docs, labels] = readFiles(docFolder, labelFolder)

docNames = dir(docFolder);
labelNames = dir(labelFolder);

docs = {};
labels = {};

counter = 1;

for i = 1:length(docNames)
    if ~isempty(strfind(docNames(i).name, '.txt'))
        fd = fopen(strcat(docFolder,'/',docNames(i).name));
        fl = fopen(strcat(labelFolder,'/',labelNames(i).name));
        txt = textscan(fd, '%s', 'delimiter', '\n');
        docs{counter} = txt{1};
        labels{counter} = fscanf(fl, '%d');
%         for now, just use the date and time labels
        labels{counter}(labels{counter} > 3) = 0;
        counter = counter + 1;
        fclose(fd);
        fclose(fl);
    end
end