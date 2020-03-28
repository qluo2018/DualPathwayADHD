load ('data_baseline_IMAGEN.mat');
load ('PRSadhdp50_IMAGEN');

data14 = table2array(data_14);
[c,ia,ib] = intersect(data14(:,1),prs(:,1));
prs_n = prs(ib,2);
beh = data14(ia,2:6);%kirby,wm,tot,hyper,in
cov_beh = data14(ia,[7,8,10:16]);%sex,age,sites
[rho1,pval1] = partialcorr(prs_n,beh,cov_beh);
ci1 = bootci(5000,@partialcorr,prs_n,beh(:,1),cov_beh);%prs&kirby
ci2 = bootci(5000,@partialcorr,prs_n,beh(:,2),cov_beh);%prs&wm
ci3 = bootci(5000,@partialcorr,prs_n,beh(:,3),cov_beh);%prs%tot

brain_ROI = data14(ia,19:20);
cov_brain = data14(ia,7:17);%sex,age,hand,sites,tiv14
[rho2,pval2] = partialcorr(prs_n,brain_ROI,cov_brain);
ci4 = bootci(5000,@partialcorr,prs_n,brain_ROI(:,1),cov_brain);
ci5 = bootci(5000,@partialcorr,prs_n,brain_ROI(:,2),cov_brain);