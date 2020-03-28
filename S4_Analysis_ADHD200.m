%% written by Shen Chun, cshen17@fudan.edu.cn
%% reviewed by Dr Qiang Luo, qluo@fudan.edu.cn
%% released on 28 Mar 2020
%% please cite: Shen, et al. Ameircan Jounral of Psychiatry 2020

%Step1. Extract ROIs
%Identical preprocessing pipeline of structural neuroimaging data as IMAGEN
%was used (VBM8, output: gray matter niis)
%Using the mask of significant clusters identified in IMAGEN to extract GMV
%in two ROIs (prefrontal, occipital) 

%load masks
bb = spm_vol('mask_frontal_C1.nii');
mask_c1 = spm_read_vols(bb);
cc = spm_vol('mask_posterior_C2.nii');
mask_c2 = spm_read_vols(cc);
 
t1file = dir('GMV_nii_ADHD200');%GMV niis in one folder
%subject ID
subj_ID = {};
t=2;
for i = 1:length(t1file)-2
    t=t+1;
    subj_ID{i} = t1file(t).name(1:7);
end
ID = str2num(cell2mat(subj_ID'));
noSub = length(ID);

t=2;
GMV_c1 = zeros(noSub,3357);%3357 voxels in mask1
GMV_c2 = zeros(noSub,1295);%1295 voxels in mask2
for i = 1:noSub
    t=t+1;
    V = spm_vol(t1file(t).name);
    [Y,~] = spm_read_vols(V);
    GMV_c1(i,:) = Y(mask_c1>0)';
    GMV_c2(i,:) = Y(mask_c2>0)';
end
GMV_c1_ADHD200 = sum(GMV_c1,2)/1000*1.5^3;
GMV_c2_ADHD200 = sum(GMV_c2,2)/1000*1.5^3;
%%
%Step1. Group comparisons

%load data
load ('data_adhd200.mat');
data = table2array(adhd200);

%1.1 adhd vs control
%prefrontal cluster
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data(:,2),data(:,6),data(:,7:13));
%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data(:,3),data(:,6),data(:,7:13));

%1.2 comparisions of ADHD subtypes
%1.2.1 combined vs td
data_subtype = data;
data_subtype(data_subtype(:,4)==2 | data_subtype(:,4)==3,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_subtype(:,2),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_subtype(:,3),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster

%1.2.2 inattentive vs td
data_subtype = data;
data_subtype(data_subtype(:,4)==2 | data_subtype(:,4)==1,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_subtype(:,2),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_subtype(:,3),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster

%1.2.3 combined vs inattentive
data_subtype = data;
data_subtype(data_subtype(:,4)==2 | data_subtype(:,4)==0,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_subtype(:,2),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_subtype(:,3),data_subtype(:,4),data_subtype(:,7:13));%prefrontal cluster

%1.3 Comparisons of medication status
%1.3.1 with medication vs td
data_med = data(isnan(data(:,5))==0,:);
data_med(data_med(:,5)==1,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_med(:,2),data_med(:,5),data_med(:,7:13));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_med(:,3),data_med(:,5),data_med(:,7:13));%prefrontal cluster

%1.3.2 without medication vs td
data_med = data(isnan(data(:,5))==0,:);
data_med(data_med(:,5)==2,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_med(:,2),data_med(:,5),data_med(:,7:13));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_med(:,3),data_med(:,5),data_med(:,7:13));%prefrontal cluster

%1.3.3 with medication vs without medication
data_med = data(isnan(data(:,5))==0,:);
data_med(data_med(:,5)==3,:)=[];
[T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_med(:,2),data_med(:,5),data_med(:,[7,8,10:13]));%prefrontal cluster
[T2,p2,FANCOVAN2, pANCOVAN2, stats2] = mancovan(data_med(:,3),data_med(:,5),data_med(:,[7,8,10:13]));%prefrontal cluster
%%
%Step2. Bootstrap of medication effect

%load data
load ('data_adhd200.mat');
data = table2array(adhd200(:,[2,3,5,7:end]));%prefrontal GMV, occipital GMV, medication status,sex,age,site(3),handedness,tiv
%based on medication status
data(isnan(data(:,3))==1,:) = [];%delete participants with missing medication information
%control
control = data(data(:,3)==3,:);%n=267
control(:,3)=0;
%with medication
med = data(data(:,3)==2,:);%n=56
med(:,3)=1;
%without medication
nonmed = data(data(:,7)==1,:);%n=99

%bootstrap
bootnum = 5000;
eta1_pre = zeros(bootnum,1);%prefrontal,control vs med
eta1_occ = zeros(bootnum,1);%occipital,control vs med
eta2_pre = zeros(bootnum,1);%prefrontal,control vs nonmed
eta2_occ = zeros(bootnum,1);%occipital,control vs nonmed
eta_pre  = zeros(bootnum,1);%eta_pre difference
eta_occ = zeros(bootnum,1);%eta_occ difference

for i = 1:bootnum
    %resample with replacement
    con_resample = randsample(size(control,1),size(control,1),1);
    med_resample = randsample(size(med,1),size(med,1),1);
    nonmed_resample = randsample(size(nonmed,1),size(nonmed,1),1);
    con_new = control(con_resample,:);
    med_new = med(med_resample,:);
    nonmed_new = nonmed(nonmed_resample,:);
    %ANCOVA
    compare1 = [con_new;med_new];%med vs control
    compare2 = [con_new;nonmed_new];%never-med vs control
    %partial eta square
    eta1_pre(i) = eta_shen(compare1(:,2),compare1(:,6),compare1(:,[1,4,5,8:11]));%prefrontal,med vs control
    eta1_occ(i) = eta_shen(compare1(:,3),compare1(:,6),compare1(:,[1,4,5,8:11]));%occ,med vs control
    eta2_pre(i) = eta_shen(compare2(:,2),compare2(:,6),compare2(:,[1,4,5,8:11]));%prefrontal,never-med vs control
    eta2_occ(i) = eta_shen(compare2(:,3),compare2(:,6),compare2(:,[1,4,5,8:11]));%occ,,never-med vs control
    %eta difference
    eta_pre(i) = eta1_pre(i)-eta2_pre(i);
    eta_occ(i) = eta1_occ(i)-eta2_occ(i);
end
eta_pre = [eta_pre1;eta_pre2;eta_pre3;eta_pre4;eta_pre5;eta_pre6;eta_pre7;eta_pre8;eta_pre9;eta_pre10];%boottrap10000
eta_occ = [eta_occ1;eta_occ2;eta_occ3;eta_occ4;eta_occ5;eta_occ6;eta_occ7;eta_occ8;eta_occ9;eta_occ10];%boottrap10000
save bootstrap10000_eta_dif eta_pre eta_occ;

lower_pre = prctile(eta_pre,2.5);
upper_pre = prctile(eta_pre,97.5);
lower_occ = prctile(eta_occ,2.5);
upper_occ = prctile(eta_occ,97.5);