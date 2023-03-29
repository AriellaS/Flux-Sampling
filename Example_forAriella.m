%% Set up Cobra toolbox
% must run this each time you start up matlab
initCobraToolbox(false)
% Set up folder to save results to
runName = ['Example_folder'];
% mkdir(runName)
%% Load Individual Models
% change to how you saved the models
load('CRC_model.mat')
load('fibro.mat')
load('m1_model.mat')
load('m2_model.mat')
mergeGenesFlag = false; % is this what we want idk? yes

%% Pair Models
% Example: 1-1 CRC + M2
models{1,1} = CRC_model;
models{2,1} = m2_model;
[pairedModelCRC_M2] = createMultipleSpeciesModel(models, 'mergeGenesFlag', mergeGenesFlag, 'remCyclesFlag', false);

%% Set up sampling
iterations = 5000; % How many samples to generate
Samplingoptions.nStepsPerPoint = 100; %sampling density
Samplingoptions.nPointsReturned = iterations; %number of points returned
Samplingoptions.toRound = 0; %whether or not the polytope is rounded
Samplingoptions.optPercentage = 0;

%% Sample Joined
% Save extra instance of the paired Model, as you shut off/turn on rxns
pairedModelOrig = pairedModelCRC_M2;
[~, samples_totalModel] =  sampleCbModel(pairedModelOrig, [], 'RHMC', Samplingoptions);
save([runName strcat('/', 'samples_total_2.mat')], 'samples_total_2');

%% Sample CRC alone
%Turn off Model 2
Model1Alone = changeRxnBounds(pairedModelCRC_M2, pairedModelCRC_M2.rxns(strmatch(strcat('model1', '_'), pairedModelCRC_M2.rxns)), 0, 'b');
% Sample Model 1 alone, then save
[~, samples_Model1_Alone] =  sampleCbModel(Model1Alone, [], 'RHMC', Samplingoptions);
save([runName strcat('/', 'samples_Model1_Alone.mat')], 'samples_Model1_Alone');

%% Sample M2 alone
% turn off Model 1
Model2Alone = changeRxnBounds(pairedModelCRC_M2, pairedModelCRC_M2.rxns(strmatch(strcat('model2', '_'), pairedModelCRC_M2.rxns)), 0, 'b');
% Sample Model 2 alone
[~, samples_Model2_Alone] =  sampleCbModel(Model2Alone, [], 'RHMC', Samplingoptions);
save([runName strcat('/', 'samples_Model2_Alone.mat')], 'samples_Model2_Alone');

%% Normalizing samples: I need to do more reading so see why its necessary
% I think its important so all fluxes are on same scale
% lets do it here, divide each reaction flux by total flux through network
% umm does this work ? looks like youre messing up the total sum by not creating a new variable
for i = 1:iterations
   Model1Alone(:,i) = Model1Alone(:,i) ./ (sum(abs(Model1Alone(:,i)),1, 'omitnan'));
   Model2Alone(:,i) = Model2Alone(:,i) ./ (sum(abs(Model2Alone(:,i)),1, 'omitnan'));
   samples_totalModel(:,i) = samples_totalModel(:,i) ./ (sum(abs(samples_totalModel(:,i)),1, 'omitnan'));
end

%% Evaluate output reactions we want
% This takes a little digging in the model by hand- need to find the name of the
% biomass rxn for CRC and Fibro, ARG1 for M2, and iNOS for M1

% CRC: Find index of CRC biomass reaction
M1BiomassInd = find(contains(CRC_M2.rxns, 'model1_biomass_reaction'));

% M2: Find index of ARG1 for M2 model
M2ArgInd = find(contains(CRC_M2.rxns, 'model2_ARGNm'));

biomassSamples_CRC_Alone = samples_Model1_Alone(M1BiomassInd, :);
ArgSamples_M2_Alone = samples_Model2_Alone(M2ArgInd, :);
biomassSamples_CRC_Joined = samples_totalModel(M1BiomassInd, :);
ArgSamples_M2_Joined = samples_totalModel(M2ArgInd, :);
% now you have the solo and paired outputs we care about, can compare

%% Pathway Analysis: CRC Model
% Get reactions belonging to CRC
rxnList = pairedModelCRC_M2.rxns(strmatch(strcat('model1', '_'), pairedModelCRC_M2.rxns));
% Get their indices
rxnLoc = find(contains(pairedModelCRC_M2.rxns, rxnList));
% Get the corresponding subsystems. Kinda weird the 'subsystems' tab is a
% cell of cells, so a couple extra steps to get the list of unique values
cellValues = cellfun(@(x) x, pairedModelCRC_M2.subSystems, 'UniformOutput', false); % extract values from cells
cellValues = [cellValues{:}]'; % concatenate the extracted values
uniqueValues = unique(cellValues);

% Cycle through each of the pathways, sum up the absolute value of fluxes
for i = 1:size(unique(cellValues), 1)
    pathway = uniqueValues(i); % get the subsystem
    indices = find(ismember(cellfun(@char, pairedModelCRC_M2.subSystems(rxnLoc), 'UniformOutput', false), pathway{1,1}));
    % cycle through all samples
    for j = 1:size(samples_Model1_Alone,2)
        pathA = samples_Model1_Alone(indices, j);
        a = size(pathA,1); % if youre interested in the number of rxns per subsystem, not that important otherwise
        fluxRxn_aveModel1(i,j) = sum(abs(pathA), 'omitnan');
    end
    for j = 1:size(samples_totalModel,2)
        pathA = samples_totalModel(indices, j);
        a = size(pathA,1);
        fluxRxn_aveModel1_TOTAL(i,j) = sum(abs(pathA), 'omitnan');
    end
end
% Plot them by subsystems
figure()
for i = 1:115
    data1 = fluxRxn_aveModel1(i,:);
    data2 = fluxRxn_aveModel1_TOTAL(i,:);
    subplot(11,11,i)
    % Plot the first histogram
    histogram(data1);
    hold on; % Keep the first histogram plotted
    % Plot the second histogram on top of the first one
    histogram(data2);
    % Add a title and axis labels
    title(cell2str(uniqueValues(i)));
    xlabel('Value: Flux Sum');
    ylabel('Frequency');
    % Release the hold on the figure
    hold off; 
end
legend('CRC Alone','CRC Community');
sgtitle('CRC Model')
savefig('CRC.fig')


%% Repeat for M2 Model
% Get reactions belonging to CRC
rxnList = pairedModelCRC_M2.rxns(strmatch(strcat('model2', '_'), pairedModelCRC_M2.rxns));
% Get their indices
rxnLoc = find(contains(pairedModelCRC_M2.rxns, rxnList));
% Get the corresponding subsystems. Kinda weird the 'subsystems' tab is a
% cell of cells, so a couple extra steps to get the list of unique values
cellValues = cellfun(@(x) x, pairedModelCRC_M2.subSystems, 'UniformOutput', false); % extract values from cells
cellValues = [cellValues{:}]'; % concatenate the extracted values
uniqueValues = unique(cellValues);

% Cycle through each of the pathways, sum up the absolute value of fluxes
for i = 1:size(unique(cellValues), 1)     
    pathway = uniqueValues(i); % get the subsystem
    indices = find(ismember(cellfun(@char, pairedModelCRC_M2.subSystems(rxnLoc), 'UniformOutput', false), pathway{1,1}));
    % cycle through all samples
    for j = 1:size(samples_Model2_Alone,2)
        pathA = samples_Model2_Alone(indices, j);
        a = size(pathA,1);
        fluxRxn_aveModel2(i,j) = sum(abs(pathA), 'omitnan');
    end
    for j = 1:size(samples_totalModel,2)
        pathA = samples_totalModel(indices, j);
        a = size(pathA,1);
        fluxRxn_aveModel2_TOTAL(i,j) = sum(abs(pathA), 'omitnan');
    end
end
% Plot them by subsystems
figure()
for i = 1:115
    data1 = fluxRxn_aveModel2(i,:);
    data2 = fluxRxn_aveModel2_TOTAL(i,:);
    subplot(11,11,i)
    % Plot the first histogram
    histogram(data1);
    hold on; % Keep the first histogram plotted
    % Plot the second histogram on top of the first one
    histogram(data2);
    % Add a title and axis labels
    title(cell2str(uniqueValues(i)));
    xlabel('Value: Flux Sum');
    ylabel('Frequency');
    % Release the hold on the figure
    hold off; 
end
legend('M2 Alone','M2 Community');
sgtitle('M2 Model')
savefig('M2.fig')

%% Get exchange reactions
% CRC
% find reactions that have suffix for exchange between models
rxnList = pairedModel.rxns(strmatch(strcat('model1', '_IEX_'), pairedModel.rxns));
% get indices
rxnLoc = find(contains(pairedModel.rxns, rxnList));
%get values
exchangeRxnsCRC = samples_total(rxnLoc, :);
% Get secretion: flux value is greater than 0
% Get uptake: flux value is less than 0


% M2
rxnList = pairedModel.rxns(strmatch(strcat('model2', '_IEX_'), pairedModel.rxns));
rxnLoc = find(contains(pairedModel.rxns, rxnList));
trans = samples_total(rxnLoc, :);
exchangeRxnsM2 = samples_total(rxnLoc, :);
% Get secretion: flux value is greater than 0
% Get uptake: flux value is less than 0
