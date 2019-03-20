%%
%data collection and average six wafer data in one run
%table2dataset converts table to a dataset type.
load('DATA.mat');
data = table2dataset(APP7A);
name = data.Properties.VarNames;
%We have 27runs, so we get 27groups averages and then store in the matrix 
%type data1
for i=1:6
    data_WAF(i,:)=mean(double(data(data.WAF==i,4:12)),1);
end
%%
%Clustering                      
figure(5)
subplot(1,3,1);
z1=linkage(data_WAF,'single','euclidean'); 
dendrogram(z1);
title("Dendrogram with Single Linkage");
xlabel("Wafer number");
ylabel("Euclidean distance");
%%
subplot(1,3,2);
z2 = linkage(data_WAF,'average','euclidean');
dendrogram(z2);
title("Dendrogram with Average Linkage");
xlabel("Wafer number");
ylabel("Euclidean distance");
%%
subplot(1,3,3);
z3 = linkage(data_WAF,'complete','euclidean');
dendrogram(z3);
title("Dendrogram with Complete Linkage");
xlabel("Wafer number");
ylabel("Euclidean distance");
%%
%classification clustering
%clustering