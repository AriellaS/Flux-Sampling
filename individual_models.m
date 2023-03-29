clear all;

%% Set up Cobra toolbox
% must run this each time you start up matlab
% initCobraToolbox(false)
% Set up folder to save results to
runName = ['data/mar8'];
mkdir(runName)

%% Load Individual Models
load('models/CRC_model.mat')
load('models/fibro.mat')
load('models/m1_model.mat')
load('models/m2_model.mat')
% testdata = importdata('data/twosamples/combo_1.mat');

%% Define individual models
individuals{1} = CRC_model;
individuals{2} = m1_model;
individuals{3} = m2_model;
individuals{4} = fibro;
num_individual = 4;

individual_names = {"CRC", "M1", "M2", "CAF"};

%% Set up sampling
iterations = 5000; % How many samples to generate
% iterations = 2; % How many samples to generate
Samplingoptions.nStepsPerPoint = 100; %sampling density
Samplingoptions.nPointsReturned = iterations; %number of points returned
Samplingoptions.toRound = 0; %whether or not the polytope is rounded
Samplingoptions.optPercentage = 0;

%% Sample individual models

parpool(4);
parfor i = 1 : num_individual-1 % -1 bc already did CAF
	model = individuals{i};
	[~, samples_totalModel] =  sampleCbModel(model, [], 'RHMC', Samplingoptions);
	parsave(runName + "/alone_" + individual_names{i} + ".mat", samples_totalModel);
end

% delete(gcp('nocreate'))

% i = 4;
% model = individuals{i};
% [~, samples_totalModel] =  sampleCbModel(model, [], 'RHMC', Samplingoptions);
% save(runName + "/alone_" + individual_names{i} + ".mat", 'samples_totalModel');
