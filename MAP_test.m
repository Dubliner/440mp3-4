function map_rate = MAP_test(trainingimages, traininglabels, testimages, testlabels, first, second)
    trains = txt_matrix(trainingimages, first);
    train_labels = label_vector(traininglabels, first);
    tests = txt_matrix(testimages, second);
    test_labels = label_vector(testlabels, second);
    table = get_table(trains, train_labels);
    
    class_rates = zeros(10,1);
    my_prediction = zeros(second, 1);
    total_numerator = 0;
    for i=1:second
        my_prediction(i) = MAP_dp(tests(:,:,i), train_labels, table);
        disp(my_prediction(i));
        if my_prediction(i)==test_labels(i)
            total_numerator = total_numerator+1;
        end
    end
    
    map_rate = total_numerator/second;
end