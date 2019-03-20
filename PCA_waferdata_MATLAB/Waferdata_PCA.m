%%
%data collection and average six wafer data in one run
%table2dataset converts table to a dataset type.
load('DATA.mat');
data = table2dataset(APP7A);
name = data.Properties.VarNames;
%We have 27runs, so we get 27groups averages and then store in the matrix 
%type data1
for i=1:1:27
    data1(i,:)=mean(double(data(data.RUN==i,[2,4:12])),1);
end
%%
trainingset = data1(1:9,2:end);
trainingsetN = normalization(trainingset);
testingset = data1(10:end,2:end);
testingsetN = normalization(testingset);
%%
%using princomp instead pca, the command pca will delete the last principal 
%component but princomp will not.We can find the last component has 0
%explanation. 
[coeff,score,~,~,explained]=pca(trainingsetN);
explained = [explained;zeros(size(trainingsetN,1)-size(explained,1))];
str = 1:9;
str = string(str);
str = cellstr(str);
%%
%T2 and SPE limitation
%T2
confident = 0.95;

%freedom is how many principal components to use
freedom = 1;
eigen = std(score,1).^2;
T2limit = chi2inv(confident,freedom);
T2=Hotteling(testingsetN,score,coeff,eigen,freedom);
y = T2limit*ones(1,length(T2));
%%
%SPElimit
theta1 = sum(eigen((freedom+1):end));
theta2 = sum(eigen((freedom+1):end).^2);
g = theta2/theta1;
h = (theta1^2)/theta2;
%SPE indices
SPE_limit = g*chi2inv(confident,h);
[SPE_indices,residue]=SPE(testingsetN,coeff,eigen,freedom);
ySPE = SPE_limit*ones(1,length(SPE_indices));
%%
%visualization
% take 3 principal components and scores and get biplot.
figure(1)
biplot(coeff(:,1:3),'Scores',score(:,1:3),'Varlabels',str,'markersize',13);
title("data vs 3 Principal Components");
%contribution(variance explaination)
figure(2)
x=1:9;
plot(x,explained,'b-','LineWidth',1.5);
xlabel("Principal Components");
ylabel("PVE");
title("Principal Components vs PVE");
%plot
figure(3);
x=1:length(T2);
subplot(1,2,1);
plot(x,T2,'b-*');
hold on
plot(x,y,'r--');
legend('T2','T2limit');
xlabel('Time(day)');
ylabel('T2');
title("T2 examination");
subplot(1,2,2);
x = 1:length(SPE_indices);
plot(x,SPE_indices,'b-*');
hold on
plot(x,ySPE,'r--');
legend('SPE','SPElimit');
title("SPE examination");
xlabel('Time(day)');
ylabel('SPE');
hold off
%visualization of fault diagnosis on PC space
figure(4);
subplot(1,2,1);
for i=1:length(T2)
    if(T2(i)>T2limit)
        plot3(testingsetN(i,1),testingsetN(i,2),testingsetN(i,3),'r.','markersize',13)
    else
        plot3(testingsetN(i,1),testingsetN(i,2),testingsetN(i,3),'g.','markersize',13)
    end
    hold on;
end
grid on;
title("fault diagnosis using T2 limitation");
xlabel("Site 1");
ylabel("Site 2");
zlabel("Site 3");
subplot(1,2,2);
for i=1:length(SPE_indices)
    if(SPE_indices(i)>SPE_limit)
        plot3(testingsetN(i,1),testingsetN(i,2),testingsetN(i,3),'r.','markersize',13)
    else
        plot3(testingsetN(i,1),testingsetN(i,2),testingsetN(i,3),'g.','markersize',13)
    end
    hold on;
end
grid on;
title("fault diagnosis using SPE limitation");
xlabel("Site 1");
ylabel("Site 2");
zlabel("Site 3");
hold off
%
SPE_POINTS=find(SPE_indices>SPE_limit)
T2_POINTS = find(T2>T2limit)