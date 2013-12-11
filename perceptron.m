% optionO: 
%       0: training order fixed
%       1: training order random

% optionA: 
%       0: alpha not decaying
%       1: alpha decaying

% optionW: 
%       0: biased, zeros
%       1: biased, random
%       2: non_biased, zeros
%       3: non_biased, random

% input: training matrices (28, 28, 5000)
% inlabel: training labels (5000, 1)
% test: test features      (28, 28, 1000)
% tlabel: test labels      (1000, 1)

function correct_rate = perceptron(optionO, optionA, optionW, epoch, input_txt, inlabel_txt, test_txt, tlabel_txt)


input = txt_matrix(input_txt, 5000);
inlabel = label_vector(inlabel_txt, 5000);
test = txt_matrix(test_txt, 1000);
tlabel = label_vector(tlabel_txt, 1000);

trainSize = size(input, 3);
totalSize = trainSize*epoch;
testSize = size(test, 3);
%% training order
train = [];
trainLabel = [];
if optionO==0 % training order: fixed
    for i=1:epoch
       train = cat(3, train, input);
       trainLabel = cat(1, trainLabel, inlabel);
    end
else % training order: random
    
    for i=1:epoch
       new_train = zeros(28, 28, trainSize);
       new_label = zeros(trainSize,1);
       p = randperm(trainSize);
       for j=1:trainSize % ????????????epoch????????????????,?????????
           new_train(:,:,j) = input(:,:,p(j));
           new_label(j) = inlabel(p(j));
%            new_train = cat(3, new_train, input(:,:,p(j)));
%            new_label = cat(1, new_label, inlabel(p(j)));
           if mod(j,1000) == 0
                disp(j);
           end 
       end
       train = cat(3, train, new_train);
       trainLabel = cat(1, trainLabel, new_label);
    end        
end

%% weight initialization
if optionW==0 % bias, zeros 
    w = zeros(28*28+1, 1);
elseif optionW==1 % bias, random
    w = randi([0 1], 28*28+1, 1);
elseif optionW==2 % no bias, zeros
    w = zeros(28*28, 1);
else % no bias, random    
    w = randi([0 1], 28*28, 1);
end        
        
% initialize alpha
alpha = 1;

%% keep a weight factor for each of the classes
ws = zeros(size(w,1), 10);
for i=1:10
    ws(:,i) =  w;
end    

%% train weights: biased/non_biased
    function vect = toVect(mat)
        b = mat';
        c = b(:)';
        vect = c';
    end    
   
for i=1:totalSize
    currf = train(:,:,i); 
    currf = toVect(currf);
    if optionW==0||optionW==1 % biased
        currf = [currf; 1];
    else % non_biased
        % do nothing
    end
    % decay vs non_decay
    if optionA==0 % non_decay
        % do nothing
    else
        alpha = 1/(1+alpha);
    end
    compareVect = zeros(10,1);
    for j=1:10
        compareVect(j) = ws(:,j)'*currf;
    end
    
    hatind = find(compareVect==max(compareVect));
    if size(hatind, 1)~=1
        hatind = hatind(1);
    end
    % if not misclassified, do nothing
    if hatind==trainLabel(i)+1 % trainLabel(i)+1 start from 0
        
    % if misclassifed, update weights:    
    else  
        actind = trainLabel(i)+1;
        ws(:,actind) = ws(:,actind)+alpha*currf;        
        ws(:,hatind) = ws(:,hatind)-alpha*currf;        
    end
end   

%% test weights
rates = zeros(10,1);
rate = 0;
confusion = zeros(10, 10);
for i=1:testSize % biased vs non_biased
    currt = test(:,:,i);
    currt = toVect(currt);
    if optionW==0||optionW==1 % biased
        currt = [currt; 1];
        % predict
        predictVect = zeros(10,1);
        for j=1:10
           predictVect(j) = ws(:,j)'*currt; 
        end
        predict = find(predictVect==max(predictVect));
        % check
        if predict==tlabel(i)+1 % correct 
            rate = rate+1;
            rates(predict) = rates(predict)+1;
            confusion(predict, predict)= confusion(predict,predict)+1; 
        else % wrong: predict->tlabel
            confusion(predict, tlabel(i)+1)= confusion(predict,tlabel(i)+1)+1; 
        end % tlabel(i)+1 since the label start from 0-9
        
    else
        % predict
        predictVect = zeros(10,1);
        for j=1:10
           predictVect(j) = ws(:,j)'*currt; 
        end
        predict = find(predictVect==max(predictVect));
        % check
        if predict==tlabel(i)+1 % correct 
            rate = rate+1;
            rates(predict) = rates(predict)+1;
            confusion(predict, predict)= confusion(predict,predict)+1; 
        else % wrong: predict->tlabel            
            confusion(predict, tlabel(i)+1)= confusion(predict,tlabel(i)+1)+1; 
        end       
    end
    
end    

% total correctness
rate = rate/testSize;
correct_rate = rate;





end