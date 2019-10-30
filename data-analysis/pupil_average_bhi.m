%use this script to plot the average of a single diameter.mat file
%containing the diamKeeper variable. This can be used to plot unexpected
%reward trials. 

clear; 
[filename, pathname] = uigetfile('*.mat');
cd(pathname);
load(filename);

exclude = str2num(cell2mat(inputdlg('Please enter the trials to exclude, each separated by a space')));

for screen = 1:(size(exclude, 2));
    diamKeeper(:, exclude(1, screen)) = NaN;
end

sizediamkeeper = size(diamKeeper);
avgcol = sizediamkeeper(1, 2) + 1;
diamKeeperAvg = diamKeeper;
for row = 1:sizediamkeeper(1, 1);
    diamKeeperAvg(row, avgcol) = nanmean(diamKeeper(row, :), 2);
end
figure
plotcols = sizediamkeeper(1, 2);
plot(diamKeeperAvg(:,1:plotcols), 'Color', [1 0.5 0]);
hold on
plot(diamKeeperAvg(:,end), 'blue')
axis tight;
hold off

%now plot based on average values
avgval = nanmean(diamKeeper(1, :) , 2); %important note, this can be modified to complete a figure using frames 400 to end, this needs to be changed back to 1 if that is not desired
diamKeepernorm = (diamKeeper / avgval) * 100;
sizediamkeepernorm = size(diamKeepernorm);
avgcolnorm = sizediamkeepernorm(1, 2) + 1;
diamKeepernormAvg = diamKeepernorm;
for row = 1:sizediamkeepernorm(1, 1);
    diamKeepernormAvg(row, avgcolnorm) = nanmean(diamKeepernorm(row, :), 2);
end
avgsem(:,1) = colon(1, length(diamKeepernorm)).';
avgsem(:, 2) = diamKeepernormAvg(:, avgcolnorm);
nanfinder = isnan(diamKeepernorm);
nantrials = size(diamKeepernorm, 2) - sum(nanfinder, 2);
avgsem(:, 3) = nanstd(diamKeepernorm, 0, 2) ./ sqrt(nantrials);
figure
frame = avgsem(:, 1);
tracemean = avgsem(:, 2);
tracesem = avgsem(:, 3);
shadedErrorBar(frame, tracemean, tracesem, 'b', 0);
set(gca,'TickDir','out')
set(gca, 'box', 'off')
axis([0 390 80 120])
saveas(gcf,'pupil_norm.jpg')

%axis([400 850 80 130]) %this can be modified to make plot more attractive

%now plot just rows 400 to 850, this is useful because grouping in
%illustrator is difficult the other way

% tracemeanshort = tracemean(400:end, 1);
% tracesemshort = tracesem(400:end, 1);
% frameshort = colon(1, length(tracemeanshort)).';
% figure
% shadedErrorBar(frameshort, tracemeanshort, tracesemshort, 'b', 0);
% axis([0 450 80 130]) %this can be modified to make plot more attractive
% set(gca,'TickDir','out')
% set(gca, 'box', 'off')
% figure
% plotcols = sizediamkeepernorm(1, 2);
% plot(diamKeepernormAvg(:,1:plotcols), 'yellow');
% hold on
% plot(diamKeepernormAvg(:,end))
% axis tight;
% hold off


%now plot raw values

avgsemraw(:, 1) = colon(1, length(diamKeeper)).';
avgsemraw(:, 2) = diamKeeperAvg(:, avgcol);
rawnanfinder = isnan(diamKeeper);
rawnantrials = size(diamKeeper, 2) - sum(rawnanfinder, 2);
avgsemraw(:, 3) = nanstd(diamKeeper, 0, 2) ./ sqrt(rawnantrials);
rawframe = avgsemraw(:, 1);
rawtracemean = avgsemraw(:, 2);
rawtracesem = avgsemraw(:, 3);
figure
shadedErrorBar(rawframe, rawtracemean, rawtracesem, 'b', 0);
set(gca,'TickDir','out')
set(gca, 'box', 'off')
