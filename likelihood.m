%% P(Fij = f| class), smoothing, given position is 1
%  (# (i,j) is 1 in class/ # example of class)
% class: number
% coin: 1 or 0
% train: the training set
% label: correct label

function result = likelihood(i, j, coin, class, train, label)
    classind = find(label==class); % classind a vector
    smoothfactor = 5;             % experiment with different value
    numerator = smoothfactor;
    
    for k=1:size(classind, 1)
        % go through corresponding matrices to check i,j position
        if train(i,j,classind(k))==coin
            numerator = numerator+1;
        end
    end
    result = numerator / (size(classind,1)+smoothfactor*2);
end

