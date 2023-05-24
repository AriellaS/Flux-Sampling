function [totalFlux_model1,totalFlux_model2] = getTotalFlux(samples,model)
	exchange_rxns = contains(model.rxns,"_IEX_");
	model1_rxns = startsWith(model.rxns,"model1_");
	model2_rxns = startsWith(model.rxns,"model2_");

	numsamples = size(samples,2);
	for i = 1 : numsamples
		% totalFlux_model1(i) = (sum(abs(samples(model1_rxns|EX_rxns,i)), 1, 'omitnan'));
		% totalFlux_model2(i) = (sum(abs(samples(model2_rxns|EX_rxns,i)), 1, 'omitnan'));

		totalFlux_model1(i) = sum(abs(samples(model1_rxns,i)), 1, 'omitnan');
		totalFlux_model2(i) = sum(abs(samples(model2_rxns,i)), 1, 'omitnan');


		% totalFlux_model1(i) = sum(abs(samples(:,i)), 1, 'omitnan');
		% totalFlux_model2(i) = sum(abs(samples(:,i)), 1, 'omitnan');
        %
	end
end

