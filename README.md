# BSClassify
BrainStateClassify (BSClassify) are wrapper functions written for MATLAB (The MathWorks, Inc., Natick, Massachusetts, United States) designed to classify brain state data, e.g. from 
electroencephalogram (EEG) or magnetoencephalogram (MEG) recordings, using a linear support
vector machine classifier in the [implementation](http://www.csie.ntu.edu.tw/~cjlin/libsvm/) by Chang & Lin (2011).
Three performance measures of classification are obtained in a 10-fold cross-validation. 

Feature Reduction
-----------------
Input data is subjected to a feature reduction step using R^2-values after Pearson's 
correlation coefficient (Spüler et. al. 2011). By default, only features exceeding the mean of R^2-values
are considered for classification. Depending on the classification problem and data 
at hand, the number of features should be changed (see line 60 in 'mlSVMR2.m').

Usage
-----
Import the source folder to your MATLAB path. Make sure correct libsvm binaries are also added to your path.
Then simply execute the following. Exchange datxDummy and datyDummy with your real data and labels.

	% example.m
	datxDummy = rand(100,29,100); 	% generate random dummy data
	datyDummy = ones(100,1);		% generate dummy labels 
	datyDummy(51:100) = 2;			% balanced classes 50/50
	[acc, auc, cf1] = mlSVMR2( datxDummy, datyDummy );	% classify and compute performance

About
-----
I'm with the institute of Medical Psychology and Behavioral Neurobiology and the Computer Science department of the
University of Tuebingen, Germany. I'm fascinated by machine learning. If you want to say hello or have
question, please drop me an e-mail.

__dthettich@gmail.com__

Literature
----------
- Spueler, M., Rosenstiel, W., & Bogdan, M. (2011). A fast feature selection method for high-dimensional meg bci data. In Proceedings of the 5th Int. Brain-Computer Interface Conference, (pp. 24–27).

- Chang, C.-C. & Lin, C.-J. (2011). Libsvm: a library for support vector machines. ACM Transactions on Intelligent Systems and Technology (TIST), 2(3), 27.

 