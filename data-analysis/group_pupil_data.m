% Use this script to analyze group data. Create a folder, in this case
% named group data. Within that folder create two other folders, in this
% case named intensity_mW_1 for 1 mW intensity and intensity_mW_1_8 for 1.8
% mW. Within those folders create two more folders named transgenic_flox
% and transgenic_null. Copy and paste avgsem.mat data for the corresponding
% mice into each folder. After pasting rename files so they are not
% overwritten using a naming scheme. 

folder = uigetdir;
cd(folder);
filePattern = fullfile(folder, '*.mat');
matfiles = dir(filePattern);
count = length(matfiles);
keepercol = 1;
for f = 1:count;
    B = matfiles(f, 1).name;
    currkeeper = load(B);
    name = char(fieldnames(currkeeper));
    holdercells(1, f) = {currkeeper.(name)};
end

for subs = 1:size(holdercells, 2);
    for frames = 1:size(holdercells{1, subs}, 1);
        result(frames, subs) = holdercells{1, subs}(frames, 2);
    end
end

result(result == 0) = NaN;


grand_avg_sem(:,1) = colon(1, length(result)).';
grand_avg_sem(:, 2) = nanmean(result, 2);
nanfinder = isnan(result);
nantrials = size(result, 2) - sum(nanfinder, 2);
avgsem(:, 3) = nanstd(result, 0, 2) ./ sqrt(nantrials);
figure
frame = avgsem(:, 1);
tracemean = avgsem(:, 2);
tracesem = avgsem(:, 3);
shadedErrorBar(frame, tracemean, tracesem, 'b', 0);
set(gca,'TickDir','out')
set(gca, 'box', 'off')
axis([0 390 80 120])