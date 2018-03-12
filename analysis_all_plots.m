% generates manuscript figures

clear all; close all;

load('alldata.mat')

load('params_all.mat')
%M1: full model, 12 param
%M2: shared model, 8 param
mi = 2;
%mi = 1;
param(1:40,1:4,1) = squeeze(params(1:40,mi,1,1:4));
param(1:40,1:4,2) = squeeze(params(1:40,mi,2,1:4));
param(1:40,1:4,3) = squeeze(params(1:40,mi,3,1:4));


curr_dir = pwd;
cd([curr_dir, '/data_analysis_and_plots/'])

supp_plots = 1;%1;


Nsbj = length(alldata);

cond_list = {'Ori', 'OriS', 'Col', 'ColS'};
Ncond = length(cond_list);

ind_ctrl = find([alldata.diagnosis] == 0);
ind_adhd = find([alldata.diagnosis] == 1);

eye_tr = [alldata.eye_tracking];
ind_rel = find(eye_tr == 1);


nbinz = 7;%for psych curve plots

%%


RT_pars_fit = nan(Nsbj,3,Ncond,3); %3 RT models with up to 3 params
RT_nll = nan(Nsbj,3,Ncond);
leng = [3 2 2]; %no of parameters of each RT model
f_par = nan(Nsbj, 800);
x_par = nan(Nsbj, 800);
rt_distrib_corr = nan(Nsbj,800);
stims_cond_all = nan(Nsbj,4, 250);
resp_cond_all = nan(Nsbj, 4, 250);
rec_par = nan(Nsbj,4);
%%

all_stims=[];
cd ..
cd([curr_dir, '/model_fitting/'])

for par = 1:length(alldata)
    
    rt_distrib(par,:) = [[alldata(par).cond_Ori.rt]; [alldata(par).cond_OriS.rt]; ...
        [alldata(par).cond_Col.rt]; [alldata(par).cond_ColS.rt]];
    
    rt_distrib_corr_temp = [];
    
    for cond = 1:Ncond
        
        clear eval;
        
        trials_total(par, cond) = eval(['alldata(par).cond_',cond_list{cond},'.trials_completed_total']);
        
        stims_cond = eval(['alldata(par).cond_',cond_list{cond},'.stims']);
        stims_cond_all(par, cond,1:length(stims_cond)) = stims_cond;
        resp_cond = eval(['alldata(par).cond_',cond_list{cond},'.resp']);
        resp_cond_all(par, cond,1:length(resp_cond)) = resp_cond;
        resp_types_cond = eval(['alldata(par).cond_',cond_list{cond},'.resp_types']);
        if length(find(resp_types_cond >= 3))>0
            %participant likely has all subtype of records
            rec_par(par,cond) = 1;
        end
        rt_cond = eval(['alldata(par).cond_',cond_list{cond},'.rt']);
        space_cond = eval(['alldata(par).cond_',cond_list{cond},'.spatial_cue']);
        
        delta_space = eval(['alldata(par).cond_',cond_list{cond},'.spatial_cue_rel2_prev_trial']);
        delta_feature = eval(['alldata(par).cond_',cond_list{cond},'.feature_cue_rel2_prev_trial']);
        
        
        ind1 = stims_cond < 0 &  resp_cond == 0;
        ind2 = stims_cond >= 0 &  resp_cond == 1;
        
        ind01 = stims_cond < 0 &  resp_cond == 1;
        ind02 = stims_cond >= 0 &  resp_cond == 0;
        
        ind_corr = ind1 | ind2;
        ind_incorr = ind01 | ind02;
        
        prop_corr_right(par,cond) = sum(space_cond == 1 & ind_corr == 1)/sum(space_cond == 1); %& ~isnan(resp_cond)
        prop_corr_left(par,cond) = sum(space_cond == 2 & ind_corr == 1)/sum(space_cond == 2);
        
        
        %Task-irrelevant motor output
        
        irrel_buttons(par,cond) = sum(isnan(resp_cond))/ length(resp_cond);
        
        resp_types_all(par, cond,1) = sum(ind_corr)/length(resp_cond);
        resp_types_all(par, cond,2) = sum(ind_incorr)/length(resp_cond);
        for cr = 3:8
            resp_types_all(par, cond, cr) = sum(resp_types_cond == cr)/length(resp_cond);
        end
        
        irrel_buttons_div(par,cond,1) = sum(isnan(resp_cond) & delta_space == 0 & delta_feature ==0)/length(resp_cond);
        irrel_buttons_div(par,cond,2) = sum(isnan(resp_cond) & delta_space == 1 & delta_feature ==0)/length(resp_cond);
        irrel_buttons_div(par,cond,3) = sum(isnan(resp_cond) & delta_space == 0 & delta_feature ==1)/length(resp_cond);
        irrel_buttons_div(par,cond,4) = sum(isnan(resp_cond) & delta_space == 1 & delta_feature ==1)/length(resp_cond);
        
        
        %Reaction times
        
        rt_med_iqr(par,cond,:) = [quantile(rt_cond,0.25) median(rt_cond)  quantile(rt_cond,0.75)];
        rt_distrib_corr_temp = [rt_distrib_corr_temp; rt_cond(ind_corr)];
        
        %fit all RT distributions : exGauss, gamma and log Normal
        
        for rmi = 1:3
            [RT_pars_fit(par,rmi,cond,1:leng(rmi)), RT_nll(par,rmi,cond)] = RT_models_fit(rmi,rt_cond);
        end
        
        % correlations between RT and stim strength
        [r_sr(par,cond),p_sr(par,cond)] = corr(abs(stims_cond(ind_corr)), rt_cond(ind_corr), 'type', 'Spearman');
        
        
        % Psychometric curve predictions based on fitted parameters
        binz = [];
        for jj = 1:nbinz
            binz(jj) = quantile(stims_cond, jj/nbinz);
        end
        
        binz = [min(stims_cond) binz ];
        binz_all(par,cond,1:(nbinz+1)) = binz;
        binz_pos = (binz(2:end)+binz(1:end-1))/2;
        binz_all_pos(par,cond,1:(nbinz)) = binz_pos;
        
        prop_cw_or_yellow_PRED(par,cond,1:nbinz) = function_psi(binz_pos,...
            param(par,cond,1),param(par,cond,2), param(par,cond,3));
        
        for jj = 1:(nbinz)
            indi = find(stims_cond>binz(jj) & stims_cond<=binz(jj+1) );
            if length(indi)>0
                prop_cw_or_yellow(par,cond,jj)=nansum(resp_cond(indi))/sum(~isnan(resp_cond(indi)));
            else
                prop_cw_or_yellow(par,cond,jj)=nan;
            end
        end
        all_stims=[all_stims; stims_cond];
    end
    
    %rt_distrib_corr(par,1:length(rt_distrib_corr_temp)) = rt_distrib_corr_temp;
    %[f_corr,x_corr] = ecdf(rt_distrib_corr(par,:));
    
    
    
end
cd ..
cd([curr_dir, '/data_analysis_and_plots/'])




%% Reaction times

rts = squeeze(rt_med_iqr(:,:,2));
rt_tau = exp(squeeze(RT_pars_fit(:,1,1:4,3)));
rt_iqr = squeeze(rt_med_iqr(:,:,3) - rt_med_iqr(:,:,1));


%% RT plot

fig_ind = 3;
plot_TIMO_RT(fig_ind,ind_ctrl, ind_adhd, irrel_buttons, rt_med_iqr, rt_tau, rt_distrib)

%% param plot 

fig_ind = 4;
plot_params(fig_ind,ind_ctrl, ind_adhd,param, all_stims)



if supp_plots
    %TIMO further info
    fig_ind = 12;
    plot_TIMO_Supp(fig_ind, rec_par,ind_ctrl, ind_adhd, resp_types_all,irrel_buttons, irrel_buttons_div)
    %psname(fig_ind) = ...
    %print_pdf(psname(fig_ind))
    
    % RT ex Gaussian other parameters 
    fig_ind = 13;
    plot_exGauss_params(fig_ind,ind_ctrl, ind_adhd,RT_pars_fit)
    
    % RT model comparison 
    fig_ind = 14;
    plot_RT_model_comp(fig_ind,curr_dir, rt_distrib)
    
    % RT iqr 
    fig_ind = 15;
    plot_RT_iqr(fig_ind, ind_ctrl, ind_adhd, rt_iqr)
    
    %stim distributions
    fig_ind = 16;
    plot_stim_distr(fig_ind,stims_cond_all, cond_list)
    
    %psych curves model comparison
    fig_ind = 17;
    plot_psych_curves_model_comp(fig_ind,curr_dir, params, stims_cond_all, resp_cond_all, cond_list)
    
end


%%  prep data for correlation analysis

all_scales = [alldata.scales];
GEC = [all_scales(1:end).GEC];
ACDS = [all_scales(1:end).ACDS];


mydata.GEC = GEC';
mydata.ACDS = ACDS';
mydata.RT = mean(squeeze(rt_med_iqr(:,:,2)),2);
mydata.RT_tau = mean(exp(squeeze(RT_pars_fit(:,1,:,3))),2);

mydata.ib = mean(irrel_buttons, 2);
mydata.sigma = mean(param(:,:,2),2);
mydata.lapse = mean(param(:,:,3),2);

nm = 7;
measures = {'log TIMO', 'log RT median ', 'log RT \tau ', 'log Perceptual variability ', 'log Lapse ', 'GEC','ACDS'};

data_all = [ mydata.ib mydata.RT mydata.RT_tau ...
    mydata.sigma mydata.lapse mydata.GEC mydata.ACDS];
%Spearman correlation robust to log

%exp GEC such that logging would get it back to normal
data_all(:,6) = exp(data_all(:,6));
%same for ACDS
data_all(:,7) = exp(data_all(:,7));

%% logistic regression classifier fig

diag = [alldata(1:40).diagnosis]';

fig_ind = 5
plot_logistic_regr(fig_ind, data_all, diag)


%%

if supp_plots
    
    % params and psych curves, all
    fig_ind = 18;
    plot_params_all(fig_ind, ind_ctrl, ind_adhd, params,prop_cw_or_yellow,prop_cw_or_yellow_PRED, binz_all_pos, all_stims, cond_list)
    
    % learning across time
    fig_ind = 19;
    plot_learning(fig_ind, ind_ctrl, ind_adhd, cond_list)
    
    
    % check effect of eye tracking
    fig_ind = 20;
    plot_eye_vs_no_eye(fig_ind, eye_tr,data_all)
    
    % plot corr matrix
    fig_ind = 21;
    plot_corr_matrix(fig_ind,data_all, measures)
    
    % params by cond
    fig_ind = 32; 
    plot_params_cond(fig_ind,irrel_buttons,rt_med_iqr,rt_tau, param, cond_list)
    
end




%% three way mixed design ANOVA --really nested 2 way repeated measures anova here
% actual three way mixed design anova implemented in SPSS
%% sigma and Irrel Buttons and rt, rt_tau
vals = squeeze(param(1:40,1:4,2)); %choose sigma, 40* 4
%vals = irrel_buttons; vals(vals<0.001) = 0.001;
%vals = rts;
%vals = rt_tau;

three_way_mixed_design_anova(vals)
%% two way mixed design anova - really nested one way repeated measure anova here
%% mu or lambda

%vals = squeeze(param(1:40,1,[1 3]));
% do not log since mu also takes neg values

% lambda
%{
vals=squeeze(param(1:40,3,[1 3]));
vals=log(laps);
%}
two_way_mixed_design_anova(vals)



%% three way mixed design ANOVA --really nested 2 way repeated measures anova here


for pi  = 1:3
    
    vals = squeeze(RT_pars_fit(:,1,1:4,pi)); 
    
    three_way_mixed_design_anova(vals)
end


%%  5D regression, GEC - these coefficients not visible since clinical data is not public
y = GEC';
X = log(data_all(:,1:5));

[B,BINT,R,RINT,STATS]= regress(y,[ones([Nsbj 1]) X],0.05);
disp(B)
disp(BINT)
disp(STATS)

% robust regression with fitlm, all 5 var


tbl1 = table(X(:,1),X(:,2),X(:,3), X(:,4),X(:,5), y,'VariableNames',{'TIMO', 'RT','RTtau','Sigmas', 'lapse','GEC'});
lm1 = fitlm(tbl1,'GEC~ TIMO + RT + RTtau + Sigmas+ lapse')

y2 = ACDS';

tbl2 = table(X(:,1),X(:,2),X(:,3), X(:,4),X(:,5),y2,'VariableNames',{'TIMO', 'RT','RTtau','Sigmas', 'lapse','ACDS'});
lm2 = fitlm(tbl2,'ACDS~TIMO + RT + RTtau + Sigmas + lapse')












