clear all;

%% Import data + normalize samples
run_name = "mar28";
alone_CAF = normalize_samples(importdata("data/" + run_name + "/alone_CAF.mat"));
alone_CRC = normalize_samples(importdata("data/" + run_name + "/alone_CRC.mat"));
alone_M1 = normalize_samples(importdata("data/" + run_name + "/alone_M1.mat"));
alone_M2 = normalize_samples(importdata("data/" + run_name + "/alone_M2.mat"));
combo_CAF_M1 = normalize_samples(importdata("data/" + run_name + "/combo_CAF-M1.mat"));
combo_CAF_M2 = normalize_samples(importdata("data/" + run_name + "/combo_CAF-M2.mat"));
combo_CRC_CAF = normalize_samples(importdata("data/" + run_name + "/combo_CRC-CAF.mat"));
combo_CRC_M1 = normalize_samples(importdata("data/" + run_name + "/combo_CRC-M1.mat"));
combo_CRC_M2 = normalize_samples(importdata("data/" + run_name + "/combo_CRC-M2.mat"));
combo_M1_M2 = normalize_samples(importdata("data/" + run_name + "/combo_M1-M2.mat"));

nbins = 50;

%% Define important rxn locations

% CAF biomass
CAF_biomass_alone_CAF = 4850;
CAF_biomass_CAF_M1 = 4432;
CAF_biomass_CAF_M2 = 4432;
CAF_biomass_CRC_CAF = 13030;

% CRC biomass
CRC_biomass_alone_CRC = 3903;
CRC_biomass_CRC_M1 = 3616;
CRC_biomass_CRC_M2 = 3616;
CRC_biomass_CRC_CAF = 3616;

% M1 iNOS (still not sure)
% M1_iNOS_alone_M1 =;
% M1_iNOS_CAF_M1 =;
% M1_iNOS_CRC_M1 =;
% M1_iNOS_M2_M1 =;

% M2 ARG1
M2_ARG1_alone_M2 = 260;
M2_ARG1_CAF_M2 = 10847;
M2_ARG1_CRC_M2 = 8858;
M2_ARG1_M1_M2 = 7368;

%% CAF biomass
figure(1);
ymax_CAF_biomass = 100;
xmax_CAF_biomass = 9E-7;
numtoshow_CAF_biomass = min([size(alone_CAF,2) size(combo_CRC_CAF,2) size(combo_CAF_M1,2) size(combo_CAF_M2,2)]);

mean_CAF_biomass_CAF_alone = mean(alone_CAF(CAF_biomass_alone_CAF,:));
mean_CAF_biomass_CRC_CAF = mean(combo_CRC_CAF(CAF_biomass_CRC_CAF,:));
mean_CAF_biomass_CAF_M1 = mean(combo_CAF_M1(CAF_biomass_CAF_M1,:));
mean_CAF_biomass_CAF_M2 = mean(combo_CAF_M2(CAF_biomass_CAF_M2,:));
disp("CAF biomass in CAF alone: " + mean_CAF_biomass_CAF_alone);
disp("CAF biomass in CAF w/ CRC: " + mean_CAF_biomass_CRC_CAF);
disp("CAF biomass in CAF w/ M1: " + mean_CAF_biomass_CAF_M1);
disp("CAF biomass in CAF w/ M2: " + mean_CAF_biomass_CAF_M2);
disp(" ");

% CAF alone vs CRC-CAF
subplot(3,1,1);
histogram(alone_CAF(CAF_biomass_alone_CAF,1:numtoshow_CAF_biomass),nbins);
hold on;
histogram(combo_CRC_CAF(CAF_biomass_CRC_CAF,1:numtoshow_CAF_biomass),nbins);
legend("CAF alone","CAF with CRC");
xlim([0 xmax_CAF_biomass]);
ylim([0 ymax_CAF_biomass]);

% CAF alone vs CAF-M1
subplot(3,1,2);
histogram(alone_CAF(CAF_biomass_alone_CAF,1:numtoshow_CAF_biomass),nbins);
hold on;
histogram(combo_CAF_M1(CAF_biomass_CAF_M1,1:numtoshow_CAF_biomass),nbins);
legend("CAF alone","CAF with M1");
xlim([0 xmax_CAF_biomass]);
ylim([0 ymax_CAF_biomass]);

% CAF alone vs CAF-M2
subplot(3,1,3);
histogram(alone_CAF(CAF_biomass_alone_CAF,1:numtoshow_CAF_biomass),nbins);
hold on;
histogram(combo_CAF_M2(CAF_biomass_CAF_M2,1:numtoshow_CAF_biomass),nbins);
legend("CAF alone","CAF with M2");
xlim([0 xmax_CAF_biomass]);
ylim([0 ymax_CAF_biomass]);

%% CRC biomass
figure(2);
ymax_CRC_biomass = 200;
xmax_CRC_biomass = 12E-7;
numtoshow_CRC_biomass = min([size(alone_CRC,2) size(combo_CRC_CAF,2) size(combo_CRC_M1,2) size(combo_CRC_M2,2)]);

mean_CRC_biomass_CRC_alone = mean(alone_CRC(CRC_biomass_alone_CRC,:));
mean_CRC_biomass_CRC_CAF = mean(combo_CRC_CAF(CRC_biomass_CRC_CAF,:));
mean_CRC_biomass_CRC_M1 = mean(combo_CRC_M1(CRC_biomass_CRC_M1,:));
mean_CRC_biomass_CRC_M2 = mean(combo_CRC_M2(CRC_biomass_CRC_M2,:));
disp("CRC biomass in CRC alone: " + mean_CRC_biomass_CRC_alone);
disp("CRC biomass in CRC w/ CAF: " + mean_CRC_biomass_CRC_CAF);
disp("CRC biomass in CRC w/ M1: " + mean_CRC_biomass_CRC_M1);
disp("CRC biomass in CRC w/ M2: " + mean_CRC_biomass_CRC_M2);
disp(" ");

% CRC alone vs CRC-CAF
subplot(3,1,1);
histogram(alone_CRC(CRC_biomass_alone_CRC,1:numtoshow_CRC_biomass),nbins);
hold on;
histogram(combo_CRC_CAF(CRC_biomass_CRC_CAF,1:numtoshow_CRC_biomass),nbins);
legend("CRC alone","CRC with CAF");
xlim([0 xmax_CRC_biomass]);
ylim([0 ymax_CRC_biomass]);

% CRC alone vs CRC-M1
subplot(3,1,2);
histogram(alone_CRC(CRC_biomass_alone_CRC,1:numtoshow_CRC_biomass),nbins);
hold on;
histogram(combo_CRC_M1(CRC_biomass_CRC_M1,1:numtoshow_CRC_biomass),nbins);
legend("CRC alone","CRC with M1");
xlim([0 xmax_CRC_biomass]);
ylim([0 ymax_CRC_biomass]);

% CRC alone vs CRC-M2
subplot(3,1,3);
histogram(alone_CRC(CRC_biomass_alone_CRC,1:numtoshow_CRC_biomass),nbins);
hold on;
histogram(combo_CRC_M2(CRC_biomass_CRC_M2,1:numtoshow_CRC_biomass),nbins);
legend("CRC alone","CRC with M2");
xlim([0 xmax_CRC_biomass]);
ylim([0 ymax_CRC_biomass]);

%% M1 iNOS
% cant find index locations

%% M2 ARG1
figure(4);
ymax_M2_ARG1 = 100;
xmax_M2_ARG1 = 4E-4;
numtoshow_M2_ARG1 = min([size(alone_M2,2) size(combo_CRC_M2,2) size(combo_CAF_M2,2) size(combo_M1_M2,2)]);

mean_M2_ARG1_M2_alone = mean(alone_M2(M2_ARG1_alone_M2,:));
mean_M2_ARG1_CRC_M2 = mean(combo_CRC_M2(M2_ARG1_CRC_M2,:));
mean_M2_ARG1_CAF_M2 = mean(combo_CAF_M2(M2_ARG1_CAF_M2,:));
mean_M2_ARG1_M1_M2 = mean(combo_M1_M2(M2_ARG1_M1_M2,:));
disp("M2 ARG1 in M2 alone: " + mean_M2_ARG1_M2_alone);
disp("M2 ARG1 in M2 w/ CRC: " + mean_M2_ARG1_CRC_M2);
disp("M2 ARG1 in M2 w/ CAF: " + mean_M2_ARG1_CAF_M2);
disp("M2 ARG1 in M2 w/ M1: " + mean_M2_ARG1_M1_M2);

% M2 alone vs CRC-M2;
subplot(3,1,1);
histogram(alone_M2(M2_ARG1_alone_M2,1:numtoshow_M2_ARG1),nbins);
hold on;
histogram(combo_CRC_M2(M2_ARG1_CRC_M2,1:numtoshow_M2_ARG1),nbins);
legend("M2 alone","M2 with CRC");
xlim([0 xmax_M2_ARG1]);
ylim([0 ymax_M2_ARG1]);

% M2 alone vs CAF-M2
subplot(3,1,2);
histogram(alone_M2(M2_ARG1_alone_M2,1:numtoshow_M2_ARG1),nbins);
hold on;
histogram(combo_CAF_M2(M2_ARG1_CAF_M2,1:numtoshow_M2_ARG1),nbins);
legend("M2 alone","M2 with CAF");
xlim([0 xmax_M2_ARG1]);
ylim([0 ymax_M2_ARG1]);

% M2 alone vs M1-M2
subplot(3,1,3);
histogram(alone_M2(M2_ARG1_alone_M2,1:numtoshow_M2_ARG1),nbins);
hold on;
histogram(combo_M1_M2(M2_ARG1_M1_M2,1:numtoshow_M2_ARG1),nbins);
legend("M2 alone","M1 with M2");
xlim([0 xmax_M2_ARG1]);
ylim([0 ymax_M2_ARG1]);

