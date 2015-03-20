# BSClassify
BrainStateClassify (BSClassify) are wrapper functions written for MATLAB (The
71 MathWorks, Inc., Natick, Massachusetts, United States) designed to classify brain state data, e.g. from 
electroencephalogram (EEG) or magnetoencephalogram (MEG) recordings, using a linear support
vector machine classifier in the [implementation](http://www.csie.ntu.edu.tw/~cjlin/libsvm/) by Chang & Lin (2011).
Three performance measures of classification are obtained in a 10-fold cross-validation. 
Training and test data are divided into 10 disjoint training and test sets.

Feature Reduction
-----------------
Input data is subjected to a feature reduction step using R^2-values after Pearson's 
correlation coefficient (Spüler et. al. 2011). By default, only features exceeding the mean of R^2-values
are considered for classification. Depending on the classification problem and data 
at hand, the number of features should be changed (see line 60 in 'mlSVMR2.m').

Usage
-----
	datxDummy = rand(100,29,100); 	% generate random dummy data
	datyDummy = ones(100,1);		% generate dummy labels 
	datyDummy(50:100) = 2;			% balanced classes 50/50
	[acc, auc, cf1] = mlSVMR2( datxDummy, datyDummy );	% classify and compute performance


Literature
----------
Spueler, M., Rosenstiel, W., & Bogdan, M. (2011). A fast feature selection method for high-dimensional meg bci data. In Proceedings of the 5th Int. Brain-Computer Interface Conference, (pp. 24–27).
Chang, C.-C. & Lin, C.-J. (2011). Libsvm: a library for support vector machines. ACM Transactions on Intelligent Systems and Technology (TIST), 2(3), 27.

 