%% written by Shen Chun, cshen17@fudan.edu.cn
%% reviewed by Dr Qiang Luo, qluo@fudan.edu.cn
%% released on 28 Mar 2020
%% please cite: Shen, et al. Ameircan Jounral of Psychiatry 2020

load ('data_adhd200.mat');
data = table2array(adhd200);

%adhd vs control
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data(:,2),data(:,6),data(:,7:13));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data(:,3),data(:,6),data(:,7:13));%prefrontal cluster

%%
%subtypes
%combined vs td
data_subtype = data;
data_subtype(data_subtype(:,4)==2 | data_subtype(:,4)==3,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_subtype(:,2),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_subtype(:,3),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster
%inattentive vs td
data_subtype = data;
data_subtype(data_subtype(:,4)==2 | data_subtype(:,4)==1,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_subtype(:,2),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_subtype(:,3),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster
%combined vs inattentive'
data_subtype = data;
data_subtype(data_subtype(:,4)==2 | data_subtype(:,4)==0,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_subtype(:,2),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_subtype(:,3),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster
%%
%medication status
%with medication vs td
data_med = data(isnan(data(:,5))==0,:);
data_med(data_med(:,5)==1,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_med(:,2),data_med(:,5),data_med(:,7:13));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_med(:,3),data_med(:,5),data_med(:,7:13));%prefrontal cluster
%without medication vs td
data_med = data(isnan(data(:,5))==0,:);
data_med(data_med(:,5)==2,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_med(:,2),data_med(:,5),data_med(:,7:13));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_med(:,3),data_med(:,5),data_med(:,7:13));%prefrontal cluster
%with medication vs without medication
data_med = data(isnan(data(:,5))==0,:);
data_med(data_med(:,5)==3,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_med(:,2),data_med(:,5),data_med(:,[7,8,10:13]));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_med(:,3),data_med(:,5),data_med(:,[7,8,10:13]));%prefrontal cluster