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
clear holdercells

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
endrow = 210;
number = endrow - startrow;
for row = 1:number;
    responses = transpose(responsekeeper(startrow, :));
    noresponses = transpose(noresponse(startrow, :));
    resultkeeper(row, 1) = startrow;
    [resultkeeper(row, 2), resultkeeper(row, 3)] = ttest2(responses, noresponses);
    startrow = startrow + 1;
end

%now calculate the mean and standard error
responsetriallength = size(responsekeeper, 1);
responseaverage(:,1) = colon(1, responsetriallength).';
responseaverage(:, 2) = nanmean(responsekeeper, 2);
nanValues = isnan(responsekeeper);
nanTrials = size(responsekeeper, 2) - sum(nanValues, 2);
responseaverage(:, 3) = nanstd(responsekeeper, 0, 2) ./ sqrt(nanTrials);
noresponsetriallength = size(noresponse, 1);
noresponseaverage(:, 1) = colon(1, noresponsetriallength).';
noresponseaverage(:, 2) = nanmean(noresponse, 2);
nanValues = isnan(noresponse);
nanTrials = size(noresponse, 2) - sum(nanValues, 2);
noresponseaverage(:, 3) = nanstd(noresponse, 0, 2) ./ sqrt(nanTrials);

%now create shaded error plot
figure;
responseframe = responseaverage(1:325, 1);
responsemean = responseaverage(1:325, 2);
responsesem = responseaverage(1:325, 3);
shadedErrorBar(responseframe, responsemean, responsesem, 'b', 0);
hold on;
noresponseframe = noresponseaverage(1:325, 1);
noresponsemean = noresponseaverage(1:325, 2);
noresponsesem = noresponseaverage(1:325, 3);
shadedErrorBar(noresponseframe, noresponsemean, noresponsesem, 'k', 0);
axis([0 350 95 125])
set(gca,'TickDir','out')
set(gca, 'box', 'off')
hold on;
plot(154, 115, '*');
hold on;
plot(209, 97, '^');
hold on;
plot(152, 97, 'o');