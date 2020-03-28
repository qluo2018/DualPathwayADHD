%% written by Shen Chun, cshen17@fudan.edu.cn
%% reviewed by Dr Qiang Luo, qluo@fudan.edu.cn
%% released on 28 Mar 2020
%% please cite: Shen, et al. Ameircan Jounral of Psychiatry 2020


clear,clc
load('SSRT_0918.mat')
index_ssrt = find(PerGOsuc>=0.5&SSRT1>0);
% index_ssrt = find(PerGOsuc>0.5&SSRT1>50&...
%     PerSTOPsuc>=0.25 & PerSTOPsuc<=0.75);
ID_ssrt = ID(index_ssrt);
irv = IRV(index_ssrt);
ssrt = SSRT1(index_ssrt);

load('data_baseline_IMAGEN.mat')
ID_1963 = table2array(data_14(:,1));
SDQ_p = table2array(data_14(:,4:6));
GMV = table2array(data_14(:,19:20));%prefontal, occipital
cov = table2array(data_14(:,[7,8,10:16]));%sex,age,site
cov_brain = table2array(data_14(:,7:17));%sex,age,hand,site,tiv
kirby = table2array(data_14(:,2));
wm = table2array(data_14(:,3)); 

[c,ia,ib] = intersect(ID_1963,ID_ssrt);%n=1846
irv_n = irv(ib);
ssrt_n = ssrt(ib);
kirby_n = kirby(ia);
wm_n = wm(ia);
sdq_n = SDQ_p(ia,:);
gmv_n = GMV(ia,:);
cov_beh = cov(ia,:);
cov_brain_n = cov_brain(ia,:);

[rr,pp]=partialcorr(wm_n,irv_n,cov_beh);

[r1b,p1b] = partialcorr([kirby_n,wm_n,irv_n,ssrt_n],...
    sdq_n,cov_beh);
cib1 = bootci(5000,@partialcorr,irv_n,sdq_n,cov_beh);
cib2 = bootci(5000,@partialcorr,ssrt_n,sdq_n,cov_beh);
[r2,p2] = partialcorr([kirby_n,wm_n,irv_n,ssrt_n],...
    gmv_n,cov_brain_n);
cib3 = bootci(5000,@partialcorr,irv_n,gmv_n,cov_brain_n);
cib4 = bootci(5000,@partialcorr,ssrt_n,gmv_n,cov_brain_n);

%kirby&ADHD, controliing for wm and irv
[r1n,p1n] = partialcorr(kirby_n,sdq_n,[wm_n,irv_n,cov_beh]);
ci1n = bootci(5000,@partialcorr,sdq_n,kirby_n,[irv_n,wm_n,cov_beh]);
%wm&ADHD, controlling for kirby and irv
[r2n,p2n] = partialcorr(wm_n,sdq_n,[kirby_n,irv_n,cov_beh]);
ci2n = bootci(5000,@partialcorr,sdq_n,wm_n,[irv_n,kirby_n,cov_beh]);
%irv&ADHD, controlling for kirby and wm
[r3n,p3n] = partialcorr(irv_n,sdq_n,[wm_n,kirby_n,cov_beh]);
ci3n = bootci(5000,@partialcorr,sdq_n,irv_n,[kirby_n,wm_n,cov_beh]);

%kirby&GMV, controlling for wm and irv
[r1,p1] = partialcorr(gmv_n,kirby_n,[wm_n,irv_n,cov_brain_n]);
ci1 = bootci(5000,@partialcorr,gmv_n,kirby_n,[irv_n,wm_n,cov_brain_n]);
%ci2 = bootci(5000,@partialcorr,gmv_n(:,2),kirby_n,[irv_n,wm_n,cov_brain_n]);
%wm&GMV, controlling for kirby and irv
[r2,p2] = partialcorr(gmv_n,wm_n,[kirby_n,irv_n,cov_brain_n]);
c13 = bootci(5000,@partialcorr,gmv_n,wm_n,[kirby_n,irv_n,cov_brain_n]);
%c14 = bootci(5000,@partialcorr,gmv_n(:,2),wm_n,[kirby_n,irv_n,cov_brain_n]);
%irv&GMV, controlling for kirby and wm
[r3,p3] = partialcorr(gmv_n,irv_n,[kirby_n,wm_n,cov_brain_n]);
c15 = bootci(5000,@partialcorr,gmv_n,irv_n,[kirby_n,wm_n,cov_brain_n]);
%c16 = bootci(5000,@partialcorr,gmv_n(:,2),irv_n,[kirby_n,wm_n,cov_brain_n]);

% composite = (zscore(irv_n)+zscore(wm_n))/2;
% kirby_z = zscore(kirby_n);
%[r3,p3] = partialcorr(gmv_n,composite,[kirby_n,cov_brain_n]);

DATA_1963 = [ID_1963,SDQ_p,kirby,wm,GMV,cov_brain];
for i = 1:length(ID_1963)
    [is3,loc3] = ismember(ID_1963(i),ID_ssrt);
    if is3 == 1
        DATA_1963(i,20)=irv(loc3);
        DATA_1963(i,21)=ssrt(loc3);
    else
        DATA_1963(i,20)=nan;
        DATA_1963(i,21)=nan;
    end
end
DATA_1963_n = DATA_1963;
DATA_1963_n(isnan(DATA_1963_n)==1)=-999;
save DATA_Q1_0114 DATA_1963 DATA_1963_n;