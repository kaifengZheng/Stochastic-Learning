%%
%data collection and average six wafer data in one run
%table2dataset converts table to a dataset type.
load('DATA.mat');
data = table2dataset(APP7A);
name = data.Properties.VarNames;
data.WAF(42)=6;
%We have 27runs, so we get 27groups averages and then store in the matrix 
%type data1
data_training=double(data(1:113,4:12));
data_training = normalization(data_training);
data_label_train = double(data.WAF(1:113));
data_testing=double(data(114:end,4:12));
data_testing = normalization(data_testing);
data_label_test = double(data.WAF(114:end));
%Mdl = fitcdiscr(data_training,data_label_train);
rng(1);
Mdl = fitcdiscr(data_training,data_label_train,...
    'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',...
    struct('AcquisitionFunctionName','expected-improvement-plus'));
per = predict(Mdl,data_testing);
confusion = confusionmat(data_label_test,per);
p_correct = trace(confusion)/length(data_label_test);


