%SSRT and ISV were obtained by the behavioral performance of SST fMRI task
%in IMAGEN

%% written by Shen Chun, cshen17@fudan.edu.cn
%% reviewed by Dr Qiang Luo, qluo@fudan.edu.cn
%% released on 28 Mar 2020
%% please cite: Shen, et al. Ameircan Jounral of Psychiatry 2020


cd('IMAGEN_SSTbeh_BA/nifti')
%each participant had a SST behavior csv file
f = dir();
IDlist = {};
for i = 1:2091
    IDlist{i} = f(3+i).name;
end
IDlist=IDlist';
ID = str2double(IDlist);

fp1 = 'IMAGEN_SSTbeh_BA/nifti/';
SSRT=zeros(length(IDlist),1);%mean success GO RT-mean SSD
isv=zeros(length(IDlist),1);%SD of RT of success GO trials
meanGO=zeros(length(IDlist),1);%mean of success GO RT
meanSSD = zeros(length(IDlist),1);%mean SSD
PerSTOPsuc = zeros(length(IDlist),1);
PerGOsuc = zeros(length(IDlist),1);
NoStopEarly = zeros(length(IDlist),1);
NoStop = zeros(length(IDlist),1);
NoStopOther = zeros(length(IDlist),1);
parfor i = 1:length(IDlist)
    %read csv data
    fp = strcat(fp1,IDlist(i),'/BehaviouralData/');
    fn = strcat('ss_',IDlist(i),'.csv');
    file = strcat(fp,fn);
    opts = detectImportOptions(file{1});
    if opts.DataLines(1,1)~=3
        opts.DataLines(1,1)=3;
    end
    data = readtable(file{1},opts);
    if size(data,1)<100 || size(data,2)==1
        SSRT(i) = nan;
        isv(i) = nan;
        meanGO(i) = nan;
        meanSSD(i) = nan;
        PerSTOPsuc(i) = nan;
        PerGOsuc(i) = nan;
        NoStopEarly(i) = nan;
        NoStop(i) = nan;
        NoStopOther(i) = nan;
    elseif size(data,1)~=0
        type = table2array(data(:,2));
        outcome = table2array(data(:,12));
        %sucess GO: GO_SUCCESS | STOP_TOO_EARLY_RESPONSE
        index_GOsuc = [find(strcmp(outcome, 'GO_SUCCESS'));...
            find(strcmp(outcome, 'STOP_TOO_EARLY_RESPONSE'))];
        index_GO = [find(strcmp(type, 'GO'));...
            find(strcmp(outcome, 'STOP_TOO_EARLY_RESPONSE'))];
        %STOP
        index_STOP =  [find(strcmp(outcome, 'STOP_FAILURE'));...
            find(strcmp(outcome, 'STOP_SUCCESS'))];
        index_STOPsuc = find(strcmp(outcome, 'STOP_SUCCESS'));
        PerSTOPsuc(i) = length(index_STOPsuc)/length(index_STOP);
        %RT
        RT = table2array(data(:,11));
        SSD1 = table2array(data(:,7));
        SSD = SSD1(index_STOP);
        NoStopEarly(i) = length(find(strcmp(outcome, 'STOP_TOO_EARLY_RESPONSE')));
        NoStop(i) = length(find(strcmp(type,'STOP_VAR')));
        NoStopOther(i) = NoStop(i)-NoStopEarly(i);
        SSD2 = SSD1(index_STOPsuc);
        if iscell(RT)
            RT = str2double(RT);
        end
        GO_RT = RT(index_GOsuc);
        PerGOsuc(i) = length(index_GOsuc)/length(index_GO);
        RT_GOsuc = RT(index_GOsuc);
        isv(i) = std(RT_GOsuc);
        meanGO(i) = mean(RT_GOsuc);
        if isempty(index_STOPsuc)
            SSRT(i) = nan;
            meanSSD(i) = nan;
        elseif isempty(index_STOPsuc)==0
            meanSSD(i) = mean(SSD);
            SSRT(i) = meanGO(i) - meanSSD(i);
        end
    end
end

save SSRT_0918 ID SSRT isv PerGOsuc;