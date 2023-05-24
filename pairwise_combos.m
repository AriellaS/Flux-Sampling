clear all;

%% Set up Cobra toolbox
% must run this each time you start up matlab
initCobraToolbox(false)
% Set up folder to save results to
runName = ['data/feb22'];
mkdir(runName)

%% Load Individual Models
load('models/CRC_model.mat')
load('models/fibro.mat')
load('models/m1_model.mat')
load('models/m2_model.mat')
% testdata = importdata('data/twosamples/combo_1.mat');

%% Define pairwise combinations
pairwises{1} = {CRC_model; m1_model}; % CRC and M1
pairwises{2} = {CRC_model; m2_model}; % CRC and M2
pairwises{3} = {fibro; m1_model}; % Fibroblast and M1
pairwises{4} = {fibro; m2_model}; % Fibroblast and M2
pairwises{5} = {CRC_model; fibro}; % Fibroblast and CRC
pairwises{6} = {m1_model; m2_model}; % M1 and M2
num_combos = 6;

pairwise_names = {"CRC-M1", "CRC-M2", "CAF-M1", "CAF-M2", "CRC-CAF", "M1-M2"};

for i = 1 : num_combos
	models = pairwises{i};
	pairedModels{i} = createMultipleSpeciesModel(models, 'mergeGenesFlag', false, 'remCyclesFlag', false);
end

%% Set up sampling
iterations = 5000; % How many samples to generate
Samplingoptions.nStepsPerPoint = 100; %sampling density
Samplingoptions.nPointsReturned = iterations; %number of points returned
Samplingoptions.toRound = 0; %whether or not the polytope is rounded
Samplingoptions.optPercentage = 0;

%% Sample pairwise combos

parpool(4);
parfor i = 1 : num_combos
	pairedModel = pairedModels{i};
	[~, samples_totalModel] =  sampleCbModel(pairedModel, [], 'RHMC', Samplingoptions);
	parsave(runName + "/combo_" + pairwise_names{i} + ".mat", samples_totalModel);
end

delete(gcp('nocreate'))
