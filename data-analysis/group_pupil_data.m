% Use this script to analyze group data. Create a folder, in this case
% named group data. Within that folder create two other folders, in this
% case named intensity_mW_1 for 1 mW intensity and intensity_mW_1_8 for 1.8
% mW. Within those folders create two more folders named transgenic_flox
% and transgenic_null. Copy and paste diameter data for the corresponding
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
