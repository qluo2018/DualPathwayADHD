# DualPathwayADHD

Key words: the ABCD cohort; family relatedness; multi-level block permutation; whole-brain voxel-wise mediation analysis; random intercept cross-lagged panel model (RI-CLPM).

Data and Code of paper:

Chun Shen+, Qiang Luo+,*, et al. Barbara J. Sahakian. Neural correlates of the dual pathway model for attention-deficit/hyperactivity disorder in adolescents. American Journal of Psychiatry, 2020. 

NOTE

Some functions were provided by others. Thank William Gruner for the MANCOVAN toolbox downloaded from the following link https://ww2.mathworks.cn/matlabcentral/fileexchange/27014-mancovan. Clear copyright and reference was stated in the relevant scripts.
IMAGEN data are available by application to consortium coordinator Dr Schumann (http://imagen-europe.com) after evaluation according to an established procedure. We would like to thanks to the ADHD-200 Consortium (http://fcon_1000.projects.nitrc.org/indi/adhd200/) for their generosity in contributing data publicly available. 

If the data and codes are used in your work, please cite the above reference, namely Shen et al. AJP 2020.

SUMMARY （Matlab2018b; SPSS22.0; R3.5.1)

Step 1: Estimated the SSRT (stop signal reaction time) and the ISV (intra-subject variability) from the behavioural data of the SST (stop signal task). (S1_SSRT_ISV_preprocess.m)

Step 2: Analysis of the IMAGEN sample  (S2_Analysis_IMAGEN.m)
      
      Step 2.1 Whole-brain voxel-wise association of GMV with ADHD scores (total; hyperactivity/inhibition; inattentive) using the GLM in SPM12.
      
      Step 2.2 Partial correlation analysis between GMV of the signifciant clusters and both the cognitive (WM: working memory; SSRT: response inhibition; ISV: attention regulation) and the motivational (Kirby rate: delay discounting) dysfunctions.  
      
      Step 2.3 Hierarchical multiple regression using the SPSS22.0.
      
      Step 2.4. Correlation with ADHD PRS score. The PRS score was estiamted using PRSice; http://prsice.info/. 
      
      Step 2.5. Comparison between the participants with persistent ADHD symptoms and the symptom-free participants. To match the sample size between the persistent group and thee control group, we also used the R package MatchIt.(S2.5.1_Find_matchSample.R)
      
Step 3:  Analysis of ADHD200. (S3_Analysis_ADHD200.m)

     Step 3.1 Group comparison.
     Step 3.2 Estimating the medication effect by bootstrap.
      

Contact:

Qiang Luo, PhD, Visiting Fellow at the Clare Hall, Cambridge
Associate Principal Investigator
Institute of Science and Technology for Brain-Inspired Intelligence (ISTBI)
Fudan University
Email: mrqiangluo@gmail.com; qluo@fudan.edu.cn
Office Phone: 86-21-65648454
https://sites.google.com/site/qluochina/
http://homepage.fudan.edu.cn/qiangluo/

Team Members:
Chun Shen, MSc, cshen17@fudan.edu.cn

The current version was relesed on 28 Mar 2020.

Citation of this package: Shen et al. Neural correlates of the dual pathway model for attention-deficit/hyperactivity disorder in adolescents. American Journal of Psychiatry, 2020. 
