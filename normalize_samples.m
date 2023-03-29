function normalized = normalize_samples(samples)
	len = size(samples,2);
	for i = 1 : len
		normalized(:,i) = samples(:,i) ./ (sum(abs(samples(:,i)), 1, 'omitnan'));
	end
end
