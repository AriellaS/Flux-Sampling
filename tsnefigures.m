clear all;

%% Import data
run_name = "mar28";
alone_CAF = importdata("data/" + run_name + "/alone_CAF.mat");
alone_CRC = importdata("data/" + run_name + "/alone_CRC.mat");
alone_M1 = importdata("data/" + run_name + "/alone_M1.mat");
alone_M2 = importdata("data/" + run_name + "/alone_M2.mat");
combo_CAF_M1 = importdata("data/" + run_name + "/combo_CAF-M1.mat");
combo_CAF_M2 = importdata("data/" + run_name + "/combo_CAF-M2.mat");
combo_CRC_CAF = importdata("data/" + run_name + "/combo_CRC-CAF.mat");
combo_CRC_M1 = importdata("data/" + run_name + "/combo_CRC-M1.mat");
combo_CRC_M2 = importdata("data/" + run_name + "/combo_CRC-M2.mat");
combo_M1_M2 = importdata("data/" + run_name + "/combo_M1-M2.mat");

%% Concatenate arrays

% CAF
CAF_numsamples = min([size(alone_CAF,2) size(combo_CRC_CAF,2) size(combo_CAF_M1,2) size(combo_CAF_M2)]);
CAF_combo_CRC_CAF = combo_CRC_CAF(end-10567:end,:);
CAF_combo_CAF_M1 = combo_CAF_M1(1:10568,:); % correct rxns number?
CAF_combo_CAF_M2 = combo_CAF_M2(1:10568,:);
all_CAF = cat(2, alone_CAF(:,1:CAF_numsamples), CAF_combo_CRC_CAF(:,1:CAF_numsamples), CAF_combo_CAF_M1(:,1:CAF_numsamples), CAF_combo_CAF_M2(:,1:CAF_numsamples)); % same # samples?
CAF_groups = cat(1,repmat("alone-CAF",CAF_numsamples,1), repmat("CAF-CRC",CAF_numsamples,1), repmat("CAF-M1",CAF_numsamples,1), repmat("CAF-M2",CAF_numsamples,1));

% CRC
CRC_numsamples = min([size(alone_CRC,2) size(combo_CRC_CAF,2) size(combo_CRC_M1,2) size(combo_CRC_M2)]);
CRC_combo_CRC_CAF = combo_CRC_CAF(1:8439,:);
CRC_combo_CRC_M1 = combo_CRC_M1(1:8439,:);
CRC_combo_CRC_M2= combo_CRC_M2(1:8439,:);
all_CRC = cat(2, alone_CRC(:,1:CRC_numsamples), CRC_combo_CRC_CAF(:,1:CRC_numsamples), CRC_combo_CRC_M1(:,1:CRC_numsamples), CRC_combo_CRC_M2(:,1:CRC_numsamples));
CRC_groups = cat(1,repmat("alone-CRC",CRC_numsamples,1), repmat("CRC-CAF",CRC_numsamples,1), repmat("CRC-M1",CRC_numsamples,1), repmat("CRC-M2",CRC_numsamples,1));

% M1
M1_numsamples = min([size(alone_M1,2) size(combo_CAF_M1,2) size(combo_CRC_M1,2) size(combo_M1_M2)]);
M1_combo_CAF_M1 = combo_CAF_M1(end-7068:end,:);
M1_combo_CRC_M1 = combo_CRC_M1(end-7068:end,:);
M1_combo_M1_M2= combo_M1_M2(1:7069,:);
all_M1 = cat(2, alone_M1(:,1:M1_numsamples), M1_combo_CAF_M1(:,1:M1_numsamples), M1_combo_CRC_M1(:,1:M1_numsamples), M1_combo_M1_M2(:,1:M1_numsamples));
M1_groups = cat(1,repmat("alone-M1",M1_numsamples,1), repmat("M1-CAF",M1_numsamples,1), repmat("M1-CRC",M1_numsamples,1), repmat("M1-M2",M1_numsamples,1));

% M2
M2_numsamples = min([size(alone_M2,2) size(combo_CAF_M2,2) size(combo_CRC_M2,2) size(combo_M1_M2)]);
M2_combo_CAF_M2 = combo_CAF_M2(end-7248:end,:);
M2_combo_CRC_M2 = combo_CRC_M2(end-7248:end,:);
M2_combo_M1_M2= combo_M1_M2(end-7248:end,:);
all_M2 = cat(2, alone_M2(:,1:M2_numsamples), M2_combo_CAF_M2(:,1:M2_numsamples), M2_combo_CRC_M2(:,1:M2_numsamples), M2_combo_M1_M2(:,1:M2_numsamples));
M2_groups = cat(1,repmat("alone-M2",M2_numsamples,1), repmat("M2-CAF",M2_numsamples,1), repmat("M2-CRC",M2_numsamples,1), repmat("M2-M1",M2_numsamples,1));

%% Dimensional reduction
tsne_all_CAF = tsne(all_CAF');
tsne_all_CRC = tsne(all_CRC');
tsne_all_M1 = tsne(all_M1');
tsne_all_M2 = tsne(all_M2');

%% Save tsne
% save('data/tsne/tsne_all_CAF.mat','tsne_all_CAF');
% save('data/tsne/tsne_all_CRC.mat','tsne_all_CRC');
% save('data/tsne/tsne_all_M1.mat','tsne_all_M1');
% save('data/tsne/tsne_all_M2.mat','tsne_all_M2');

% %% Import tsne data
% run_name = "tsne";
% tsne_all_CAF = importdata("data/" + run_name + "/tsne_all_CAF.mat");
% tsne_all_CRC = importdata("data/" + run_name + "/tsne_all_CRC.mat");
% tsne_all_M1 = importdata("data/" + run_name + "/tsne_all_M1.mat");
% tsne_all_M2 = importdata("data/" + run_name + "/tsne_all_M2.mat");

%% CAF
figure(1);
gscatter(tsne_all_CAF(:,1),tsne_all_CAF(:,2), CAF_groups);

%% CRC
figure(2);
gscatter(tsne_all_CRC(:,1),tsne_all_CRC(:,2), CRC_groups);

%% M1
figure(3);
gscatter(tsne_all_M1(:,1),tsne_all_M1(:,2), M1_groups);

%% M2
figure(4);
gscatter(tsne_all_M2(:,1),tsne_all_M2(:,2), M2_groups);
