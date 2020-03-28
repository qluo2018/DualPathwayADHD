%% written by Shen Chun, cshen17@fudan.edu.cn
%% reviewed by Dr Qiang Luo, qluo@fudan.edu.cn
%% released on 28 Mar 2020
%% please cite: Shen, et al. Ameircan Jounral of Psychiatry 2020

clear,clc
tb = readtable('ADHD200.xlsx');
data = table2array(tb(:,[2:7,18,20:24]));
data(isnan(data(:,7))==1,:) = [];
control = data(data(:,7)==3,:);%n=267
control(:,4) = [];
control(:,6)=0;
med = data(data(:,7)==2,:);%n=56
med(:,4) = [];
med(:,6)=1;
nonmed = data(data(:,7)==1,:);%n=99
nonmed(:,4) = [];

%bootstrap
bootnum = 1000;
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
%     [T1,p1,F1, pANCOVAN1, stats1] = mancovan(compare1(:,2),compare1(:,6),compare1(:,[1,4,5,8:11]));%prefrontal,med vs control
%     [T2,p2,F2, pANCOVAN2, stats2] = mancovan(compare1(:,3),compare1(:,6),compare1(:,[1,4,5,8:11]));%occ,med vs control
%     [T3,p3,F3, pANCOVAN3, stats3] = mancovan(compare2(:,2),compare2(:,6),compare2(:,[1,4,5,8:11]));%prefrontal,never-med vs control
%     [T4,p4,F4, pANCOVAN4, stats4] = mancovan(compare2(:,3),compare2(:,6),compare2(:,[1,4,5,8:11]));%occ,,never-med vs control
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

