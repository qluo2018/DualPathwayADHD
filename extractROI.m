
%% written by Shen Chun, cshen17@fudan.edu.cn
%% reviewed by Dr Qiang Luo, qluo@fudan.edu.cn
%% released on 28 Mar 2020
%% please cite: Shen, et al. Ameircan Jounral of Psychiatry 2020

[c,ia,ib] = intersect(T1_ID,data_14(:,1));
T1data = GMV(ia,:);

aa = spm_vol('newAAL90.nii');
mask = spm_read_vols(aa);
bb = spm_vol('mask_frontal_C1.nii');
mask_c1 = spm_read_vols(bb);
cc = spm_vol('mask_posterior_C2.nii');
mask_c2 = spm_read_vols(cc);

mask_aal = reshape(mask,[1,2122945]);
loc_aal = find(mask_aal>0);
mask_c12 = reshape(mask_c1,[1,2122945]);
loc_c1 = find(mask_c1>0);
mask_c22 = reshape(mask_c2,[1,2122945]);
loc_c2 = find(mask_c2>0);

[~,loc1]=ismember(loc_c1,loc_aal);
T1_c1 = T1data(:,loc1);
sum_c1 = sum(T1_c1,2);
[~,loc2]=ismember(loc_c2,loc_aal);
T1_c2 = T1data(:,loc2);
sum_c2 = sum(T1_c2,2);
