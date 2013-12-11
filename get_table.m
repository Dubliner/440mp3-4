%% given class, probability of 
function table = get_table(train_set, train_label)
    table = zeros(28,28,10,2);
    
    % compute likelihood table
    for class=0:9
        for i=1:28
            for j=1:28
                table(i,j,class+1,1) = likelihood(i,j,0,class,train_set,train_label);
                table(i,j,class+1,2) = likelihood(i,j,1,class,train_set,train_label);
            end
        end
    end
    
end