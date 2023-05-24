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

CAF_M1_model = importdata("models/CAF-M1_model.mat");
CAF_M2_model = importdata("models/CAF-M2_model.mat");
CRC_CAF_model = importdata("models/CRC-CAF_model.mat");
CRC_M1_model = importdata("models/CRC-M1_model.mat");
CRC_M2_model = importdata("models/CRC-M2_model.mat");
M1_M2_model = importdata("models/M1-M2_model.mat");

%% Get total fluxes
CRC_totalflux_alone = sum(abs(alone_CRC), 1, 'omitnan');
CAF_totalflux_alone = sum(abs(alone_CAF), 1, 'omitnan');
M1_totalflux_alone = sum(abs(alone_M1), 1, 'omitnan');
M2_totalflux_alone = sum(abs(alone_M2), 1, 'omitnan');

[CRC_totalflux_CRC_CAF, CAF_totalflux_CRC_CAF] = getTotalFlux(combo_CRC_CAF,CRC_CAF_model);
[CRC_totalflux_CRC_M1, M1_totalflux_CRC_M1] = getTotalFlux(combo_CRC_M1,CRC_M1_model);
[CRC_totalflux_CRC_M2, M2_totalflux_CRC_M2] = getTotalFlux(combo_CRC_M2,CRC_M2_model);

[CAF_totalflux_CAF_M1, M1_totalflux_CAF_M1] = getTotalFlux(combo_CAF_M1,CAF_M1_model);
[CAF_totalflux_CAF_M2, M2_totalflux_CAF_M2] = getTotalFlux(combo_CAF_M2,CAF_M2_model);

[M1_totalflux_M1_M2, M2_totalflux_M1_M2] = getTotalFlux(combo_M1_M2,M1_M2_model);

%% Define important rxn locations

% CAF biomass
CAF_biomass_alone = 4850;
CAF_biomass_CAF_M1 = 4432;
CAF_biomass_CAF_M2 = 4432;
CAF_biomass_CRC_CAF = 13030;

% CRC biomass
CRC_biomass_alone = 3903;
CRC_biomass_CRC_M1 = 3616;
CRC_biomass_CRC_M2 = 3616;
CRC_biomass_CRC_CAF = 3616;

% % M1 iNOS
% M1_iNOS_alone = 1529;
% M1_iNOS_CAF_M1 = 11929;
% M1_iNOS_CRC_M1 = 9940;
% M1_iNOS_M1_M2 = 1342;
%
% % M2 ARG1
% M2_ARG1_alone = 260;
% M2_ARG1_CAF_M2 = 10847;
% M2_ARG1_CRC_M2 = 8858;
% M2_ARG1_M1_M2 = 7368;

%% for testing look at m1 and m2 biomass

% M1 biomass (labeled as inos)
M1_iNOS_alone = 3749;
M1_iNOS_CAF_M1 = 14091;
M1_iNOS_CRC_M1 = 12102;
M1_iNOS_M1_M2 = 3504;

% M2 biomass (labeled as arg1)
M2_ARG1_alone = 3816;
M2_ARG1_CAF_M2 = 14147;
M2_ARG1_CRC_M2 = 12158;
M2_ARG1_M1_M2 = 10668;

%% CAF biomass
figure(1);
sgtitle("CAF biomass");
ymax_CAF_biomass = 100;
xmax_CAF_biomass = 9E-7;
numtoshow_CAF_biomass = min([size(alone_CAF,2) size(combo_CRC_CAF,2) size(combo_CAF_M1,2) size(combo_CAF_M2,2)]);
binwidth_CAF_biomass = 1E-8;

norm_CAF_biomass_alone = alone_CAF(CAF_biomass_alone,:) ./ CAF_totalflux_alone;
norm_CAF_biomass_CRC_CAF = combo_CRC_CAF(CAF_biomass_CRC_CAF,:) ./ CAF_totalflux_CRC_CAF;
norm_CAF_biomass_CAF_M1 = combo_CAF_M1(CAF_biomass_CAF_M1,:) ./ CAF_totalflux_CAF_M1;
norm_CAF_biomass_CAF_M2 = combo_CAF_M2(CAF_biomass_CAF_M2,:) ./ CAF_totalflux_CAF_M2;

mean_CAF_biomass_alone = mean(norm_CAF_biomass_alone);
mean_CAF_biomass_CRC_CAF = mean(norm_CAF_biomass_CRC_CAF);
mean_CAF_biomass_CAF_M1 = mean(norm_CAF_biomass_CAF_M1);
mean_CAF_biomass_CAF_M2 = mean(norm_CAF_biomass_CAF_M2);
disp("CAF biomass in CAF alone: " + mean_CAF_biomass_alone);
disp("CAF biomass in CAF w/ CRC: " + mean_CAF_biomass_CRC_CAF);
disp("CAF biomass in CAF w/ M1: " + mean_CAF_biomass_CAF_M1);
disp("CAF biomass in CAF w/ M2: " + mean_CAF_biomass_CAF_M2);
disp(" ");

% CAF alone vs CRC-CAF
subplot(3,1,1);
histogram(norm_CAF_biomass_alone(1:numtoshow_CAF_biomass),'binwidth',binwidth_CAF_biomass);
hold on;
histogram(norm_CAF_biomass_CRC_CAF(1:numtoshow_CAF_biomass),'binwidth',binwidth_CAF_biomass);
legend("CAF alone","CAF with CRC");
xlim([0 xmax_CAF_biomass]);
ylim([0 ymax_CAF_biomass]);

% CAF alone vs CAF-M1
subplot(3,1,2);
histogram(norm_CAF_biomass_alone(1:numtoshow_CAF_biomass),'binwidth',binwidth_CAF_biomass);
hold on;
histogram(norm_CAF_biomass_CAF_M1(1:numtoshow_CAF_biomass),'binwidth',binwidth_CAF_biomass);
legend("CAF alone","CAF with M1");
xlim([0 xmax_CAF_biomass]);
ylim([0 ymax_CAF_biomass]);

% CAF alone vs CAF-M2
subplot(3,1,3);
histogram(norm_CAF_biomass_alone(1:numtoshow_CAF_biomass),'binwidth',binwidth_CAF_biomass);
hold on;
histogram(norm_CAF_biomass_CAF_M2(1:numtoshow_CAF_biomass),'binwidth',binwidth_CAF_biomass);
legend("CAF alone","CAF with M2");
xlim([0 xmax_CAF_biomass]);
ylim([0 ymax_CAF_biomass]);

%% CRC biomass
figure(2);
sgtitle("CRC biomass");
ymax_CRC_biomass = 300;
xmax_CRC_biomass = 12E-7;
numtoshow_CRC_biomass = min([size(alone_CRC,2) size(combo_CRC_CAF,2) size(combo_CRC_M1,2) size(combo_CRC_M2,2)]);
binwidth_CRC_biomass = 1E-8;

norm_CRC_biomass_alone = alone_CRC(CRC_biomass_alone,:) ./ CRC_totalflux_alone;
norm_CRC_biomass_CRC_CAF = combo_CRC_CAF(CRC_biomass_CRC_CAF,:) ./ CRC_totalflux_CRC_CAF;
norm_CRC_biomass_CRC_M1 = combo_CRC_M1(CRC_biomass_CRC_M1,:) ./ CRC_totalflux_CRC_M1;
norm_CRC_biomass_CRC_M2 = combo_CRC_M2(CRC_biomass_CRC_M2,:) ./ CRC_totalflux_CRC_M2;

mean_CRC_biomass_alone = mean(norm_CRC_biomass_alone);
mean_CRC_biomass_CRC_CAF = mean(norm_CRC_biomass_CRC_CAF);
mean_CRC_biomass_CRC_M1 = mean(norm_CRC_biomass_CRC_M1);
mean_CRC_biomass_CRC_M2 = mean(norm_CRC_biomass_CRC_M2);
disp("CRC biomass in CRC alone: " + mean_CRC_biomass_alone);
disp("CRC biomass in CRC w/ CAF: " + mean_CRC_biomass_CRC_CAF);
disp("CRC biomass in CRC w/ M1: " + mean_CRC_biomass_CRC_M1);
disp("CRC biomass in CRC w/ M2: " + mean_CRC_biomass_CRC_M2);
disp(" ");

% CRC alone vs CRC-CAF
subplot(3,1,1);
histogram(norm_CRC_biomass_alone(1:numtoshow_CRC_biomass),'binwidth',binwidth_CRC_biomass);
hold on;
histogram(norm_CRC_biomass_CRC_CAF(1:numtoshow_CRC_biomass),'binwidth',binwidth_CRC_biomass);
legend("CRC alone","CRC with CAF");
xlim([0 xmax_CRC_biomass]);
ylim([0 ymax_CRC_biomass]);

% CRC alone vs CRC-M1
subplot(3,1,2);
histogram(norm_CRC_biomass_alone(1:numtoshow_CRC_biomass),'binwidth',binwidth_CRC_biomass);
hold on;
histogram(norm_CRC_biomass_CRC_M1(1:numtoshow_CRC_biomass),'binwidth',binwidth_CRC_biomass);
legend("CRC alone","CRC with M1");
xlim([0 xmax_CRC_biomass]);
ylim([0 ymax_CRC_biomass]);

% CRC alone vs CRC-M2
subplot(3,1,3);
histogram(norm_CRC_biomass_alone(1:numtoshow_CRC_biomass),'binwidth',binwidth_CRC_biomass);
hold on;
histogram(norm_CRC_biomass_CRC_M2(1:numtoshow_CRC_biomass),'binwidth',binwidth_CRC_biomass);
legend("CRC alone","CRC with M2");
xlim([0 xmax_CRC_biomass]);
ylim([0 ymax_CRC_biomass]);

%% M1 iNOS
figure(3);
sgtitle("M1 iNOS");
ymax_M1_iNOS = 100;
xmax_M1_iNOS = 1E-4;
numtoshow_M1_iNOS = min([size(alone_M1,2) size(combo_CRC_M1,2) size(combo_CAF_M1,2) size(combo_M1_M2,2)]);
binwidth_M1_iNOS = 1E-6;

norm_M1_iNOS_alone = alone_M1(M1_iNOS_alone,:) ./ M1_totalflux_alone;
norm_M1_iNOS_CRC_M1 = combo_CRC_M1(M1_iNOS_CRC_M1,:) ./ M1_totalflux_CRC_M1;
norm_M1_iNOS_CAF_M1 = combo_CAF_M1(M1_iNOS_CAF_M1,:) ./ M1_totalflux_CAF_M1;
norm_M1_iNOS_M1_M2 = combo_M1_M2(M1_iNOS_M1_M2,:) ./ M1_totalflux_M1_M2;

mean_M1_iNOS_alone = mean(norm_M1_iNOS_alone);
mean_M1_iNOS_CRC_M1 = mean(norm_M1_iNOS_CRC_M1);
mean_M1_iNOS_CAF_M1 = mean(norm_M1_iNOS_CAF_M1);
mean_M1_iNOS_M1_M2 = mean(norm_M1_iNOS_M1_M2);
disp("M1 iNOS in M1 alone: " + mean_M1_iNOS_alone);
disp("M1 iNOS in M1 w/ CRC: " + mean_M1_iNOS_CRC_M1);
disp("M1 iNOS in M1 w/ CAF: " + mean_M1_iNOS_CAF_M1);
disp("M1 iNOS in M1 w/ M2: " + mean_M1_iNOS_M1_M2);
disp(" ");

% M1 alone vs CRC-M1;
subplot(3,1,1);
histogram(norm_M1_iNOS_alone(1:numtoshow_M1_iNOS),'binwidth',binwidth_M1_iNOS);
hold on;
histogram(norm_M1_iNOS_CRC_M1(1:numtoshow_M1_iNOS),'binwidth',binwidth_M1_iNOS);
legend("M1 alone","M1 with CRC");
xlim([0 xmax_M1_iNOS]);
ylim([0 ymax_M1_iNOS]);

% M1 alone vs CAF-M1
subplot(3,1,2);
histogram(norm_M1_iNOS_alone(1:numtoshow_M1_iNOS),'binwidth',binwidth_M1_iNOS);
hold on;
histogram(norm_M1_iNOS_CAF_M1(1:numtoshow_M1_iNOS),'binwidth',binwidth_M1_iNOS);
legend("M1 alone","M1 with CAF");
xlim([0 xmax_M1_iNOS]);
ylim([0 ymax_M1_iNOS]);

% M1 alone vs M1-M2
subplot(3,1,3);
histogram(norm_M1_iNOS_alone(1:numtoshow_M1_iNOS),'binwidth',binwidth_M1_iNOS);
hold on;
histogram(norm_M1_iNOS_M1_M2(1:numtoshow_M1_iNOS),'binwidth',binwidth_M1_iNOS);
legend("M1 alone","M1 with M2");
xlim([0 xmax_M1_iNOS]);
ylim([0 ymax_M1_iNOS]);

%% M2 ARG1
figure(4);
sgtitle("M2 ARG1");
ymax_M2_ARG1 = 200;
xmax_M2_ARG1 = 4E-4;
numtoshow_M2_ARG1 = min([size(alone_M2,2) size(combo_CRC_M2,2) size(combo_CAF_M2,2) size(combo_M1_M2,2)]);
% binwidth_M2_ARG1 = 1E-5;
binwidth_M2_ARG1 = 1E-6;

norm_M2_ARG1_alone = alone_M2(M2_ARG1_alone,:) ./ M2_totalflux_alone;
norm_M2_ARG1_CRC_M2 = combo_CRC_M2(M2_ARG1_CRC_M2,:) ./ M2_totalflux_CRC_M2;
norm_M2_ARG1_CAF_M2 = combo_CAF_M2(M2_ARG1_CAF_M2,:) ./ M2_totalflux_CAF_M2;
norm_M2_ARG1_M1_M2 = combo_M1_M2(M2_ARG1_M1_M2,:) ./ M2_totalflux_M1_M2;

mean_M2_ARG1_alone = mean(norm_M2_ARG1_alone);
mean_M2_ARG1_CRC_M2 = mean(norm_M2_ARG1_CRC_M2);
mean_M2_ARG1_CAF_M2 = mean(norm_M2_ARG1_CAF_M2);
mean_M2_ARG1_M1_M2 = mean(norm_M2_ARG1_M1_M2);
disp("M2 ARG1 in M2 alone: " + mean_M2_ARG1_alone);
disp("M2 ARG1 in M2 w/ CRC: " + mean_M2_ARG1_CRC_M2);
disp("M2 ARG1 in M2 w/ CAF: " + mean_M2_ARG1_CAF_M2);
disp("M2 ARG1 in M2 w/ M1: " + mean_M2_ARG1_M1_M2);

% M2 alone vs CRC-M2;
subplot(3,1,1);
histogram(norm_M2_ARG1_alone(1:numtoshow_M2_ARG1),'binwidth',binwidth_M2_ARG1);
hold on;
histogram(norm_M2_ARG1_CAF_M2(1:numtoshow_M2_ARG1),'binwidth',binwidth_M2_ARG1);
legend("M2 alone","M2 with CRC");
xlim([0 xmax_M2_ARG1]);
ylim([0 ymax_M2_ARG1]);

% M2 alone vs CAF-M2
subplot(3,1,2);
histogram(norm_M2_ARG1_alone(1:numtoshow_M2_ARG1),'binwidth',binwidth_M2_ARG1);
hold on;
histogram(norm_M2_ARG1_CAF_M2(1:numtoshow_M2_ARG1),'binwidth',binwidth_M2_ARG1);
legend("M2 alone","M2 with CAF");
xlim([0 xmax_M2_ARG1]);
ylim([0 ymax_M2_ARG1]);

% M2 alone vs M1-M2
subplot(3,1,3);
histogram(norm_M2_ARG1_alone(1:numtoshow_M2_ARG1),'binwidth',binwidth_M2_ARG1);
hold on;
histogram(norm_M2_ARG1_M1_M2(1:numtoshow_M2_ARG1),'binwidth',binwidth_M2_ARG1);
legend("M2 alone","M1 with M2");
xlim([0 xmax_M2_ARG1]);
ylim([0 ymax_M2_ARG1]);

hold off;
