%% predict and compare all test data using MAP
function map_rate = MAP_rate(trainingimages, traininglabels, testimages, testlabels)
    trains = txt_matrix(trainingimages, 5000);
    train_labels = label_vector(traininglabels, 5000);
    tests = txt_matrix(testimages, 1000);
    test_labels = label_vector(testlabels, 1000);
    table = get_table(trains, train_labels);
    
    class_rate = zeros(10,1);
    my_prediction = zeros(1000, 1);
    total_numerator = 0;
    confusion = zeros(10,10);
    for i=1:1000
        my_prediction(i) = MAP_dp(tests(:,:,i), train_labels, table);
        disp(my_prediction(i));
        if my_prediction(i)==test_labels(i)
            class_rate(test_labels(i)+1) = class_rate(test_labels(i)+1)+1;
            total_numerator = total_numerator+1;
            % update confusion matrix on diagonal
            position = test_labels(i)+1;
            confusion(position, position) = confusion(position, position)+1; 
        else % just update confusion matrix
            r = test_labels(i)+1;
            c = my_prediction(i)+1;
            confusion(r, c) = confusion(r, c)+1;
        end
    end
    
    % report classification rate for each digit:
    for i=1:10
       % i-1 = class
       digitcount = find(test_labels==i-1);
       class_rate(i) = class_rate(i)/size(digitcount,1); 
       disp(class_rate(i));
    end
    % report confusion matrix 10-by-10:
    disp(confusion);
    for i=1:10
        rowsum = sum(confusion(i,:));
        for j=1:10
            confusion(i,j) = confusion(i,j)/rowsum;
        end
    end
    disp(confusion);
    
    % calculate the odds ratios:
    % grab the item in the likelihood table: 4->9, 7->9, 5->3, 8->3
    four = table(:,:,5,2);
    seven = table(:,:,8,2);
    nine = table(:,:,10,2);
    five = table(:,:,6,2);
    eight = table(:,:,9,2);
    three = table(:,:,4,2);
    one = table(:,:,2,2);
    
    % 4->9
    four = (four-min(min(four))).*65./(max(max(four))-min((min(four))));
    nine = (nine-min(min(nine))).*65./(max(max(nine))-min((min(nine))));
   
    figure(1),image(four); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});
    figure(2),image(nine); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});
    figure(3),image(four./nine); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});;
   
    % 7->9
   seven = (seven-min(min(seven))).*65./(max(max(seven))-min((min(seven))));
    %nine = (nine-min(min(nine))).*10./(max(max(nine))-min((min(nine))));
   
    figure(4),image(seven); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});;
    figure(5),image(nine); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});;
    figure(6),image(log(seven./nine)); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});;
   
% 5->3
    five = (five-min(min(five))).*65./(max(max(five))-min((min(five))));
    three = (three-min(min(three))).*65./(max(max(three))-min((min(three))));
    
    figure(7),image(five); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});;
    figure(8),image(three); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});;
    figure(9),image(five./three); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});;
  
 % 8->3
    eight = (eight-min(min(eight))).*65./(max(max(eight))-min((min(eight))));
   % nine = (nine-min(min(nine))).*10./(max(max(nine))-min((min(nine))));
   
    figure(10),image(eight); colorbar;%('YTickLabel',{'0','0.2','0.4','0.6','0.8','1'});;
    figure(11),image(three); colorbar;%('YTickLabel',{'-3','-2','-1'});;    
    figure(12),image(eight./three); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});;
    
    % 8,1
   % eight = (eight-min(min(eight))).*10./(max(max(eight))-min((min(eight))));
   % nine = (nine-min(min(nine))).*10./(max(max(nine))-min((min(nine))));
    one = (one-min(min(one))).*65./(max(max(one))-min((min(one))));
    figure(13),image(one); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});;
    figure(14),image(eight); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});;
    one_eight = eight./one;
    one_eight_print = (one_eight-min(min(one_eight))).*50./(max(max(one_eight))-min((min(one_eight))));
    figure(15),image(one_eight); colorbar;%('YTickLabel',{'-2','-1','0','1','2','3'});; 
    
    % report total correct rate
    map_rate = total_numerator/1000;
end

% missing: highest posterior prbability
