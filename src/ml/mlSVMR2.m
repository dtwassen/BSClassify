function [acc, auc, cf1] = mlSVMR2( datx, daty )
%% Classification of data datx and labels daty using linear support vector
% machine (SVM) in the implementation by Chang & Lin (2011), feature
% reduction by R2-values (Sp?ler et. al. 2011). Performance measures
% accuracy, AUC-values and F1-scores are obtained in 10-fold
% cross-validation.
%
%  input:   datx [trials 1..n x channels 1..ch x samples 1..i],
%           daty [labels 1..n]
%  output:  accuracy [acc 1], AUC-value [auc 1], F1-score [cf1 1]
%
% Note: 'src' directory and binaries of libsvm must be added to path!
%
% Literature: 
% Chang, C.-C. & Lin, C.-J. (2011). Libsvm: a library for support vector 
%   machines. ACM Transactions on Intelligent Systems and Technology 
%   (TIST), 2(3), 27.
% Spueler, M., Rosenstiel, W., & Bogdan, M. (2011). A fast feature selection 
%   method for high-dimensional meg bci data. In Proceedings of the 5th 
%   Int. Brain-Computer Interface Conference, (pp. 24?27).

% abort if number of samples is not equal the number of labels
if size(datx,1) ~= length(daty)
   error('Number of trials does not match the number of labels.'); 
end

% check daty orientation and possibly correct
if size(datx,1) == length(daty) && size(datx,1) ~= size(daty,1)
    daty = daty';
end
% check unique labels and sort data
un=unique(daty);
if un ~= 0
daty(daty==un(1)) = 1;
daty(daty==un(2)) = 0;
end
[daty, idx] = sort(daty);
datx = datx(idx,:);

% init
probAll = zeros(size(daty,1),1);
datyPredict = zeros(length(daty),1);

% create partitioned sets
CVO = cvpartition(daty,'kFold',10);
accfold = zeros(CVO.NumTestSets, 1);

%% cross-validation iterations
for fold=1:CVO.NumTestSets
    trIdx = CVO.training(fold);
    teIdx = CVO.test(fold);
    
    datxTrain = datx(trIdx,:);
    datyTrain = daty(trIdx);
    
    datxTest = datx(teIdx,:);
    datyTest = daty(teIdx,:);
    
    %% feature reduction
    % compute R2-values
    r2vals = anaR2( datxTrain, datyTrain );
    
    % sort
    [a, b]= sort((mean((r2vals),2)),'descend');
    meana = mean(a);
    %% number of features
    numftr = b(a>meana);    % select features exceeding mean of R2-values
    % numftr = b(1:10);     % select 10 best scoring features
    % numftr = b(1:100);    % select 100 best scoring features
    
    %% classification
    % train SVM model
    modelLinear = svmtrain( datyTrain, datxTrain(:,numftr), '-s 0 -t 0 -b 1 -q' );
    % predict 
    [datyPredictLinear, ~, prob] = svmpredict( datyTest, datxTest(:,numftr), modelLinear, '-q -b 1' );
    
    % compute fold accuracy
    accfold(fold) = sum( datyPredictLinear == datyTest ) / length( datyTest );
    
    % assign label and probabilities of predictions
    datyPredict(teIdx) = datyPredictLinear;
    probAll(teIdx) = prob(:,1);
end

%% compute performance measures
% AUC pre-processing
prob_vals = probAll(:);
reallabels = daty;
thvals=0:0.01:1;
tp = zeros(length(thvals),1);
fn = tp;
tn = tp;
fp = tp;
for thi=1:length(thvals);
    th = thvals(thi);
    tp(thi) = sum(prob_vals>=th & reallabels==1);
    fn(thi) = sum(prob_vals<th & reallabels==1);
    tn(thi) = sum(prob_vals<th & reallabels==0);
    fp(thi) = sum(prob_vals>=th & reallabels==0);
end
% compute accuracy
acc = nanmean(accfold);
% compute AUC-value
auc = abs(trapz(tp./(tp+fn),tn./(tn+fp)));
% compute F1-score
tp = sum(datyPredict == 1 & reallabels ==1);
tn = sum(datyPredict == 0 & reallabels ==0);
fp = sum(datyPredict == 1 & reallabels ==0);
fn = sum(datyPredict == 0 & reallabels ==1);
cf1 = 2*tp/(2*tp+fp+fn);
