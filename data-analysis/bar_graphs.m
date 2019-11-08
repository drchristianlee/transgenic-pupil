% Create a new folder with the min.mat files inside. 

clear;
close all
clc

clear
folder = uigetdir;
test = str2num(cell2mat(inputdlg('Would you like to do a paired or unpaired test? Press 1 for paired 2 for unpaired')));
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
        test_keeper(frames, subs) = holdercells{1, subs}(frames, 1);
    end
end


scale = 0; %enter 1 to scale data by 1000 else 0

test_keeper(test_keeper == 0) = NaN;

if scale == 1;
    test_keeper = test_keeper * 1000;
else
end

barkeeper(1,1) = nanmean(test_keeper(:,1));
barkeeper(1,2) = nanmean(test_keeper(:, 2));
nanfinder = isnan(test_keeper);
nanvals = sum(nanfinder, 1);
denominator1 = sqrt((size(test_keeper(:, 1), 1)) - nanvals(1, 1));
denominator2 = sqrt((size(test_keeper(:, 2), 1)) - nanvals(1, 2));
barkeeper(2,1) = nanstd(test_keeper(:,1))/denominator1;
barkeeper(2,2) = nanstd(test_keeper(:,2))/denominator2;

figure
bar(barkeeper(1,:), 'b');
hold on;
errorbar(barkeeper(1,:), barkeeper(2,:), '.', 'color', 'k', 'marker', 'none');
hold on;

for points = 1:size(test_keeper, 1);
    plot(test_keeper(points, 1:2) , 'o', 'color' , 'green', 'MarkerFaceColor', 'green')
    hold on
end

 %axis([0 3 0 40])
 set(gca,'TickDir','out')
 set(gca, 'box', 'off')
 set(gcf,'position',[680 558 160 210])
 set(gca, 'TickLength', [0.025 0.025]);
 set(gca,'FontSize',9);
 
 if test == 1;
 [h p ci stats] = ttest(test_keeper(:, 1), test_keeper(:, 2))
 disp('a paired test was used');
 else
     [h p ci stats] = ttest2(test_keeper(:, 1), test_keeper(:, 2))
     disp('an unpaired test was used');
 end