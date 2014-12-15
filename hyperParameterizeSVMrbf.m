function [ bestSVMStruct ] = hyperParameterizeSVMrbf( trainFeats, trainLabels)

% Hyper-parameterizes a SVM with a rbf kernel

len = length(trainFeats);

x_train = trainFeats(1:floor(len * 0.8),:);
t_train = trainLabels(1:floor(len * 0.8),:);

x_cross = trainFeats(floor(len * 0.8)+1:end,:);
t_cross = trainLabels(floor(len * 0.8)+1:end,:);

CSet = [0.01, 0.1, 1, 10, 100, 1000];
sigmaSet = [0.2, 0.5, 1, 1.5, 2, 2.5, 3];

bestAccuracy = 0;
bestSigma = 0;
bestC = 0;

for sigma = sigmaSet
    for C = CSet
        
        svmStruct = svmtrain(x_train,t_train,'kernel_function','rbf','rbf_sigma', sigma, 'boxconstraint', C);
        
        cross_result = svmclassify(svmStruct, x_cross);
        
        correct = 0;
        for i=1:length(x_cross)
            if cross_result(i) == t_cross(i)
                correct = correct + 1;
            end
        end
        
        accuracy = correct / length(x_cross);
        disp(['sigma: ', num2str(sigma), ', C: ', num2str(C), ', cross-valiation accuracy: ', num2str(accuracy)]);
        
        if accuracy > bestAccuracy
            bestAccuracy = accuracy;
            bestSigma = sigma;
            bestC = C;
        end
        
    end
    
end

%retrain with best parameters, using full set of data
bestSVMStruct = svmtrain(trainFeats, trainLabels,'kernel_function','rbf','rbf_sigma', bestSigma, 'boxconstraint', bestC);


end