%this script is used to calculate multiple t tests at time points 50 to
%150. Create folders containing trials with a response (such as Gos and
%FAs) and another folder with no response (such as NoGos). At the first
%directory choice, pick the directory with the response trials, then pick
%the no response trials. See analysis_workflow.txt for more details. 

%first load response trials
clear;
folder = uigetdir;
cd(folder);
filePattern = fullfile(folder, '*.mat');
matfiles = dir(filePattern);
count = length(matfiles);

for f = 1:count;
    B = matfiles(f, 1).name;
    currkeeper = load(B);
    name = char(fieldnames(currkeeper));
    holdercells(1, f) = {currkeeper.(name)};
end
response1 = cell2mat(holdercells(1,1));
response2 = cell2mat(holdercells(1,2));
responsekeeper = cat(2, response1, response2);

%now load non response trials
folder = uigetdir;
cd(folder);
filePattern = fullfile(folder, '*.mat');
matfiles = dir(filePattern);
count = length(matfiles);

for f = 1:count;
    B = matfiles(f, 1).name;
    currkeeper = load(B);
    name = char(fieldnames(currkeeper));
    holdercells(1, f) = {currkeeper.(name)};
end
noresponse = cell2mat(holdercells(1,1));

%start t tests
startrow = 50;
endrow = 150;
number = endrow - startrow;
for row = 1:number;
    responses = transpose(responsekeeper(startrow, :));
    noresponses = transpose(noresponse(startrow, :));
    resultkeeper(row, 1) = startrow;
    [resultkeeper(row, 2), resultkeeper(row, 3)] = ttest2(responses, noresponses);
    startrow = startrow + 1;
end