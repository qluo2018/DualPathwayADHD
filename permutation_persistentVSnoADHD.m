load ('data_age16_IMAGEN.mat');
data = table2array(data_16);

%persistent vs noADHD
data(:,25) = data(:,21)+data(:,22);
data_new = data(data(:,25)==0 | data(:,25)==2,:);%0=noADHD, 2= persistentADHD
tabulate(data_new(:,25));
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
