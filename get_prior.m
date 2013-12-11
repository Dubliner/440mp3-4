%% empirical frequencies of different classes in the training set
function prior = get_prior(class, label)
    classlist = find(label==class);
    numerator = size(classlist, 1);
    denominator = size(label, 1);
    prior = numerator/denominator;
end
