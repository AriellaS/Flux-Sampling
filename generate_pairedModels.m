clear all;

%% Load Individual Models
load('models/CRC_model.mat')
load('models/fibro.mat')
load('models/m1_model.mat')
load('models/m2_model.mat')

%% Define pairwise combinations
pairwises{1} = {CRC_model; m1_model}; % CRC and M1
pairwises{2} = {CRC_model; m2_model}; % CRC and M2
pairwises{3} = {fibro; m1_model}; % Fibroblast and M1
pairwises{4} = {fibro; m2_model}; % Fibroblast and M2
pairwises{5} = {CRC_model; fibro}; % CRC and Fibroblast
pairwises{6} = {m1_model; m2_model}; % M1 and M2
num_combos = 6;

pairwise_names = {"CRC-M1", "CRC-M2", "CAF-M1", "CAF-M2", "CRC-CAF", "M1-M2"};

for i = 1 : num_combos
	models = pairwises{i};
	pairedModel = createMultipleSpeciesModel(models, 'mergeGenesFlag', false, 'remCyclesFlag', false);
	save("models/" + pairwise_names(i) + "_model.mat",'pairedModel');
end


