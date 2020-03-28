%% written by Shen Chun, cshen17@fudan.edu.cn
%% reviewed by Dr Qiang Luo, qluo@fudan.edu.cn
%% released on 28 Mar 2020
%% please cite: Shen, et al. Ameircan Jounral of Psychiatry 2020


%Step1. Whole-brain analysis
%GLM using SPM12
%Covariates: Age, sex, handedness, TIV, site
%Input: gray matter volume niis
%Output: significant clusters associated with ADHD symptoms
%     mask_frontal_C1.nii
%     mask_posterior_C2.nii

%Extract GMV in significant clusters
load('GMVblwholebrain.mat')
load('data_baseline_IMAGEN.mat')
[~,ia1,~] = intersect(T1_ID,data_14(:,1));
T1data = GMV(ia1,:);

aa = spm_vol('newAAL90.nii');%AAL90 mask
mask = spm_read_vols(aa);
bb = spm_vol('mask_frontal_C1.nii');
mask_c1 = spm_read_vols(bb);
cc = spm_vol('mask_posterior_C2.nii');
mask_c2 = spm_read_vols(cc);

mask_aal = reshape(mask,[1,2122945]);
loc_aal = find(mask_aal>0);
mask_c12 = reshape(mask_c1,[1,2122945]);
loc_c1 = find(mask_c12>0);
mask_c22 = reshape(mask_c2,[1,2122945]);
loc_c2 = find(mask_c22>0);

[~,loc1]=ismember(loc_c1,loc_aal);
T1_c1 = T1data(:,loc1);
GMV_c1 = sum(T1_c1,2)/1000*1.5^3;%unit: ml3
[~,loc2]=ismember(loc_c2,loc_aal);
T1_c2 = T1data(:,loc2);
GMV_c2 = sum(T1_c2,2)/1000*1.5^3;
%%
%Step 2. Partial correlation analysis

%load data
load('SSRT_0918.mat')%SSRT, ISV
index_ssrt = find(PerGOsuc>=0.5&SSRT>0);
ID_ssrt = ID(index_ssrt);
isv = isv(index_ssrt);%sd of rt in successful GO trials
ssrt = SSRT(index_ssrt);%mean correct go rt - mean stop signal latency

load('data_baseline_IMAGEN.mat')
ID_1963 = table2array(data_14(:,1));
SDQ_p = table2array(data_14(:,4:6));
GMV = table2array(data_14(:,19:20));%prefontal, occipital
cov = table2array(data_14(:,[7,8,10:16]));%sex,age,site
cov_brain = table2array(data_14(:,7:17));%sex,age,hand,site,tiv
kirby = table2array(data_14(:,2));
wm = table2array(data_14(:,3)); 

[~,ia2,ib2] = intersect(ID_1963,ID_ssrt);%n=1846
isv_n = isv(ib2);
ssrt_n = ssrt(ib2);
kirby_n = kirby(ia2);
wm_n = wm(ia2);
sdq_n = SDQ_p(ia2,:);
gmv_n = GMV(ia2,:);
cov_beh = cov(ia2,:);
cov_brain_n = cov_brain(ia2,:);

%partial correlation between neuropsychological measures and ADHD symptoms
%the association between ssrt and ADHD was not significant
[r1,p1] = partialcorr([kirby_n,wm_n,isv_n,ssrt_n],...
    sdq_n,cov_beh);
cib1 = bootci(5000,@partialcorr,[kirby_n,wm_n,isv_n,ssrt_n],sdq_n,cov_beh);

%partial correlation between neuropsychological measures and GMV
[r2,p2] = partialcorr([kirby_n,wm_n,isv_n],...
    gmv_n,cov_brain_n);
cib2 = bootci(5000,@partialcorr,[kirby_n,wm_n,isv_n],gmv_n,cov_brain_n);

%kirby&ADHD, controliing for wm and isv
[r1n,p1n] = partialcorr(kirby_n,sdq_n,[wm_n,isv_n,cov_beh]);
ci1n = bootci(5000,@partialcorr,sdq_n,kirby_n,[isv_n,wm_n,cov_beh]);
%wm&ADHD, controlling for kirby and isv
[r2n,p2n] = partialcorr(wm_n,sdq_n,[kirby_n,isv_n,cov_beh]);
ci2n = bootci(5000,@partialcorr,sdq_n,wm_n,[isv_n,kirby_n,cov_beh]);
%isv&ADHD, controlling for kirby and wm
[r3n,p3n] = partialcorr(isv_n,sdq_n,[wm_n,kirby_n,cov_beh]);
ci3n = bootci(5000,@partialcorr,sdq_n,isv_n,[kirby_n,wm_n,cov_beh]);

%kirby&GMV, controlling for wm and isv
[r4n,p4n] = partialcorr(gmv_n,kirby_n,[wm_n,isv_n,cov_brain_n]);
ci4n = bootci(5000,@partialcorr,gmv_n,kirby_n,[isv_n,wm_n,cov_brain_n]);
%wm&GMV, controlling for kirby and isv
[r5n,p5n] = partialcorr(gmv_n,wm_n,[kirby_n,isv_n,cov_brain_n]);
ci5n = bootci(5000,@partialcorr,gmv_n,wm_n,[kirby_n,isv_n,cov_brain_n]);
%isv&GMV, controlling for kirby and wm
[r6n,p6n] = partialcorr(gmv_n,isv_n,[kirby_n,wm_n,cov_brain_n]);
ci6n = bootci(5000,@partialcorr,gmv_n,isv_n,[kirby_n,wm_n,cov_brain_n]);
%%
%Step 3. Hierarchical multiple regression
%performed by SPSS 22.0
%%
%Step 4. Correlation with ADHD PRS score

%load data, ADHD PRS score, p<0.50
load ('PRSadhdp50_IMAGEN');
load ('data_baseline_IMAGEN.mat');

data14 = table2array(data_14);
[~,ia3,ib3] = intersect(data14(:,1),prs(:,1));
prs_n = prs(ib3,2);
beh = data14(ia3,2:6);%kirby,wm,tot,hyper,in
cov_beh = data14(ia3,[7,8,10:16]);%sex,age,sites
[rho1,pval1] = partialcorr(prs_n,beh,cov_beh);
ci1 = bootci(5000,@partialcorr,prs_n,beh(:,1),cov_beh);%prs&kirby
ci2 = bootci(5000,@partialcorr,prs_n,beh(:,2),cov_beh);%prs&wm
ci3 = bootci(5000,@partialcorr,prs_n,beh(:,3),cov_beh);%prs%tot

brain_ROI = data14(ia1,19:20);
cov_brain = data14(ia1,7:17);%sex,age,hand,sites,tiv14
[rho2,pval2] = partialcorr(prs_n,brain_ROI,cov_brain);
ci4 = bootci(5000,@partialcorr,prs_n,brain_ROI(:,1),cov_brain);
ci5 = bootci(5000,@partialcorr,prs_n,brain_ROI(:,2),cov_brain);

load('SSRT_0918.mat')
index_ssrt = find(PerGOsuc>=0.5&SSRT>0);
ID_ssrt = ID(index_ssrt);
isv = isv(index_ssrt);%sd of rt in successful GO trials

[~,ia4,ib4] = intersect(prs(:,1),intersect(data14(:,1),ID_ssrt));
prs_n2 = prs(ia4,2);
isv_n2 = isv(ib4);
cov_beh2 = data14(ib4,[7,8,10:16]);%sex,age,sites
[rho1,pval1] = partialcorr(prs_n,beh,cov_beh);
ci6 = bootci(5000,@partialcorr,prs_n2,isv_n2,cov_beh2);%prs&isv
%%
%Step 5. Comparison between persistent ADHD and control

%load data
load ('data_age16_IMAGEN.mat');
data = table2array(data_16);

%persistent vs noADHD
data(:,25) = data(:,21)+data(:,22);
data_new = data(data(:,25)==0 | data(:,25)==2,:);%0=noADHD, 2= persistentADHD
%regressed on covariates
%prefrontal cluster
stat = regstats(data_new(:,23),data_new(:,[10,12:20]),'linear');
r_pref = stat.r;
%real F value
[T_1,p_1,FANCOVAN_1, pANCOVAN_1, stats_1] = mancovan(data_new(:,23),data_new(:,25),data_new(:,[10,12:20]));%real F value
%permutation 10000 times
F_per=zeros(10000,1);
for i = 1:10000
    data_permu = r_pref( randperm( size(r_pref,1)),:);
    data_permu(1:29,2)=1;
    data_permu(30:1307,2)=0;
    [T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_permu(:,1),data_permu(:,2));
    F_per(i)=FANCOVAN(1);
end
F_true = FANCOVAN_1(1);
GreaterNumbers = 0;
for j = 1:10000
    if F_per(j) >= F_true
       GreaterNumbers = GreaterNumbers+1;
    end
end
PValue = GreaterNumbers/10000;

%%regressed on covariates
%occipital cluster
stat2 = regstats(data_new(:,24),data_new(:,[10,12:20]),'linear');
r_occ = stat2.r;
%real F value
[T_2,p_2,FANCOVAN_2, pANCOVAN_2, stats_2] = mancovan(data_new(:,24),data_new(:,25),data_new(:,[10,12:20]));%real F value
%permutation 10000 times
F_per2=zeros(10000,1);
for i = 1:10000
    data_permu2 = r_occ( randperm( size(r_occ,1)),:);
    data_permu2(1:29,2)=1;
    data_permu2(30:1307,2)=0;
    [T,p,FANCOVAN, pANCOVAN, stats] = mancovan(data_permu2(:,1),data_permu2(:,2));
    F_per2(i)=FANCOVAN(1);
end
F_true2 = FANCOVAN_2(1);
GreaterNumbers2 = 0;
for j = 1:10000
    if F_per2(j) >= F_true2
       GreaterNumbers2 = GreaterNumbers2+1;
    end
end
PValue2 = GreaterNumbers2/10000;



