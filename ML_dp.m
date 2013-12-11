function result = ML_dp(test, table)
    % P(class) ? P(f1,1|class) ? P(f1,2|class) ? ...? P(f28,28 | class).
    % log P(class) + log P(f1,1|class) + log P(f1,2|class) + ... + log P(f28,28 | class).
    
    predict = zeros(10,1);
    % for each of the ten classes:
    for class=0:9
        
        %predict(class+1) = 0;
        for i=1:28
           for j=1:28
               coin = test(i,j);
               predict(class+1) = predict(class+1)+abs(log(table(i,j,class+1,coin+1)));
           end
        end
    end
    
    result = find(predict==min(predict))-1;
    
end