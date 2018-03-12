# Perceptual variability and executive function
 The code in this repository accompanies the following preprint, currently under review: 
 
 [Mihali, A, Young, AG, Adler, L, Halassa, MM, Ma, WJ. A low-level perceptual correlate of behavioral and clinical deficits in ADHD.](https://www.biorxiv.org/content/early/2017/10/06/199216 )
## Experiment : Visuo-motor decision-making with task-switching

## Data format

The experiment code yields '.mat' files containing 'data', 'settings' and Psybayes output 'post' and 'outputs', which are processed with the script `analysis_raw.m`, which combines the data across all participants into `alldata.mat`.
  
 The last fields represent structs with all the trials in each of the 4 possible conditions (each itself a struct):
 
 - cond_Ori
 - cond_OriS
 - cond_Col
 - cond_ColS
 

 

##  Scripts

* `analysis_all_plots.m` takes in `alldata.mat` and the psychometric curve parameters `params_all.mat`, calls the plotting functions from `data_analysis_and_plots` and return the figures in the manuscript. 
