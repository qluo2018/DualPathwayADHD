%% written by Shen Chun, cshen17@fudan.edu.cn
%% reviewed by Dr Qiang Luo, qluo@fudan.edu.cn
%% released on 28 Mar 2020
%% please cite: Shen, et al. Ameircan Jounral of Psychiatry 2020

function peta2 = eta_shen(y,g,cov)
[~,~,F, ~, stats] = mancovan(y,g,cov);
MSe = stats.MSE*F(1);            % MST = F  * MSE
SSe = MSe*(length(unique(g))-1); % SST = MST * DFT
peta2 = SSe/(SSe+stats.SSE);     % partial-eta2 = SST / (SST+SSE) 
end
