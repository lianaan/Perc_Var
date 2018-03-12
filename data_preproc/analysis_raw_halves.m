clear all; close all;


%load('table_scales.mat') % filled with all nan's since we could not make this data public
table_scales_all = nan(40,6);
scales_names = {'ASRS','AISRS','ACDS','ACDS2','GEC','MCI'};


Controls_list = {};
Patients_list= {};
for i = 1:20
    Controls_list = [Controls_list, ['C', num2str(i)]];
    Patients_list = [Patients_list, ['P', num2str(i)]];
end


eye_tracking_controls = [ 1 1 1  0 1 1 1 0 0 1 1 0 0 0 1  0 0 0 0  1];
age_controls = [19 39 31 32 30 38 37 34 23 28 44 30 31 39 25 29 35 32 36 38];
gender_controls = [0 1 0 0 1 0 0  1 1 0 1 1 0 0 1 1 1 1 1 0];


eye_tracking_patients = [1 1 1 0 0 0 0 1 0 0 0 1 0 1 1 0 0  1 1 1 ];
age_patients = [53 55 30 28 42 42 42 42 30  36 21 29 47 27 46 28 25 26 29 28];
gender_patients = [0 1 1 1   0  0  0  1  1  1  0  1  1   1  1 1  1  0 0 0 ];


Subj_set = [Controls_list, Patients_list];
eye_tracking = [eye_tracking_controls eye_tracking_patients];
ages  =  [age_controls age_patients];
Diagnosis_set = [zeros(1,20) ones(1,20)];
ind_ctrl = [1:length(Controls_list)];
ind_adhd = [length(Controls_list)+1:length(Controls_list)+length(Patients_list)];

load('settings.mat')
%response buttons
right_buttons_set = [settings.resp_right_clockwise settings.resp_right_counterclockwise settings.resp_right_more_yellow settings.resp_right_more_blue];
left_buttons_set = [settings.resp_left_clockwise settings.resp_left_counterclockwise settings.resp_left_more_yellow settings.resp_left_more_blue];


write_psych_curve_params  =  0;
missing_info_fill = 0;


for par = 1:length(Subj_set)
    
    Subj_name = Subj_set{par}
    
    curr_path = pwd;
    if ismember(Subj_name, Controls_list)
        addpath(sprintf('%s%s%s%s',curr_path, '/output/Cs/', Subj_name, '/'))
        directory = sprintf('%s%s%s%s',curr_path,'/output/Cs/', Subj_name, '/');
    elseif ismember(Subj_name, Patients_list)
        addpath(sprintf('%s%s%s%s',curr_path, '/output/Ps/', Subj_name, '/'))
        directory = sprintf('%s%s%s%s',curr_path,'/output/Ps/', Subj_name, '/');
    end
    

    filez = dir(directory);
    flst = {filez.name};
    
    
    % ORI BLOCKS
    strtofind = 'ORI1.mat';
    ix = regexp(flst,strtofind);
    ix = ~cellfun('isempty',ix);
    load(flst{ix})
    
    
  
    if eye_tracking(par)
        trials_completed1 = dlmread(sprintf('%s%s', Subj_name,'ORI10_ended_tr.txt'));
        data = data(trials_completed1);
    else
        data = data(1:100);
    end
    
    
    all_vals = [];
    all_resp = [];
    all_rt = [];
    all_cue_index = [];
    all_deltas_sp = [];
    
    
    all_vals_distr = [];
    all_vals_irrel = [];
    all_vals_irrel_distr = [];
    all_resp_types = [];
    
    all_vals = [all_vals data(find([data.trial_type]'  ==  1)).orientations];
    all_vals_distr = [all_vals_distr data(find([data.trial_type]'  ==  1)).orientations_0];
    all_vals_irrel = [all_vals_irrel data(find([data.trial_type]'  ==  1)).colors];
    all_vals_irrel_distr = [all_vals_irrel_distr data(find([data.trial_type]'  ==  1)).colors_0];
    all_resp = [all_resp data(find([data.trial_type]'  ==  1)).resp];
    all_rt = [all_rt   data(find([data.trial_type]'  ==  1)).reaction_time];
    all_cue_index = [all_cue_index data(find([data.trial_type]'  ==  1)).cue_index];
    all_deltas_sp = [all_deltas_sp 0 abs([data(2:end).cue_index]-[data(1:end-1).cue_index])]; 
    all_resp_types = [all_resp_types resp_types_update_all(data, right_buttons_set, left_buttons_set)];
    
    
    alldata(par).diagnosis  =  par>20 ;
    alldata(par).eye_tracking  =  eye_tracking(par);
    alldata(par).age  =  ages(par) ;
    alldata(par).scales.ASRS  =  table_scales_all(par,1);
    alldata(par).scales.AISRS  =  table_scales_all(par,2);
    alldata(par).scales.ACDS  =  table_scales_all(par,3);
    alldata(par).scales.ACDS2  =  table_scales_all(par,4);
    alldata(par).scales.GEC  =  table_scales_all(par,5);
    alldata(par).scales.MCI  =  table_scales_all(par,6);
    
    
    %write condition specific data
    data = [];
    data.cond = 'Ori1';
    
    
   
    data.stims  =  all_vals';
    data.feature_cue  =  ones(length(data.stims),1);  %since ori
    data.spatial_cue  =  all_cue_index';
    data.feature_cue_rel2_prev_trial  =  zeros(length(data.stims),1);  %always 0, since always ori
    data.spatial_cue_rel2_prev_trial  =  all_deltas_sp';
    data.distractors  =  all_vals_distr';
    data.stims_irrel_feat  =  all_vals_irrel';
    data.distractors_irrel_feat  =  all_vals_irrel_distr';
    data.resp  =  all_resp';
    data.rt  =  all_rt';
    data.resp_types = all_resp_types';
    data.params_adaptive = outputs{1,1};
    
    alldata(par).cond_Ori1  =  data;
    
    
    
    
    
    strtofind = 'ORI2.mat';
    ix = regexp(flst,strtofind);
    ix = ~cellfun('isempty',ix);
    load(flst{ix})
    
    
    if eye_tracking(par)
        trials_completed2 = dlmread(sprintf('%s%s', Subj_name,'ORI20_ended_tr.txt'));
        data = data(trials_completed2);
    else
        data = data(1:100);
    end
    
    all_vals = [];
    all_resp = [];
    all_rt = [];
    all_cue_index = [];
    all_deltas_sp = [];
    
    
    all_vals_distr = [];
    all_vals_irrel = [];
    all_vals_irrel_distr = [];
    
    all_resp_types = [];
    
    all_vals = [all_vals data(find([data.trial_type]'  ==  1)).orientations];
    all_vals_distr = [all_vals_distr data(find([data.trial_type]'  ==  1)).orientations_0];
    all_vals_irrel = [all_vals_irrel data(find([data.trial_type]'  ==  1)).colors];
    all_vals_irrel_distr = [all_vals_irrel_distr data(find([data.trial_type]'  ==  1)).colors_0];
    all_resp = [all_resp data(find([data.trial_type]'  ==  1)).resp];
    all_rt = [all_rt   data(find([data.trial_type]'  ==  1)).reaction_time];
    all_cue_index = [all_cue_index data(find([data.trial_type]'  ==  1)).cue_index];
    all_deltas_sp = [all_deltas_sp 0 abs([data(2:end).cue_index]-[data(1:end-1).cue_index])];
    
    all_resp_types = [all_resp_types resp_types_update_all(data, right_buttons_set, left_buttons_set)];
    
    
    
    %write condition specific data
    data = [];
    data.cond = 'Ori2';
    
   
    
    data.stims  =  all_vals';
    data.feature_cue  =  ones(length(data.stims),1);  %since ori
    data.spatial_cue  =  all_cue_index';
    data.feature_cue_rel2_prev_trial  =  zeros(length(data.stims),1);  %always 0, since always ori
    data.spatial_cue_rel2_prev_trial  =  all_deltas_sp';
    data.distractors  =  all_vals_distr';
    data.stims_irrel_feat  =  all_vals_irrel';
    data.distractors_irrel_feat  =  all_vals_irrel_distr';
    data.resp  =  all_resp';
    data.rt  =  all_rt';
    data.resp_types = all_resp_types';
    data.params_adaptive = outputs{1,1};
    
    alldata(par).cond_Ori2  =  data;
    
    
    
    
    % COLOR BLOCKS
    
    strtofind = 'COL1.mat'; 
    ix = regexp(flst,strtofind);
    ix = ~cellfun('isempty',ix);
    load(flst{ix})
    
    
    if eye_tracking(par)
        trials_completed1 = dlmread(sprintf('%s%s', Subj_name,'COL10_ended_tr.txt'));
        data = data(trials_completed1);
    else
        data = data(1:100);
    end
    
    all_vals = [];
    all_resp = [];
    all_rt = [];
    all_cue_index = [];
    all_deltas_sp = [];
    
    
    all_vals_distr = [];
    all_vals_irrel = [];
    all_vals_irrel_distr = [];
    
    all_resp_types = [];
    
    all_vals = [all_vals data(find([data.trial_type]'  ==  2)).colors];
    all_vals_distr = [all_vals_distr data(find([data.trial_type]'  ==  2)).colors_0];
    all_vals_irrel = [all_vals_irrel data(find([data.trial_type]'  ==  2)).orientations];
    all_vals_irrel_distr = [all_vals_irrel_distr data(find([data.trial_type]'  ==  2)).orientations_0];
    all_resp = [all_resp data(find([data.trial_type]'  ==  2)).resp];
    all_rt = [all_rt   data(find([data.trial_type]'  ==  2)).reaction_time];
    all_cue_index = [all_cue_index data(find([data.trial_type]'  ==  2)).cue_index];
   
    all_deltas_sp = [all_deltas_sp 0 abs([data(2:end).cue_index]-[data(1:end-1).cue_index])];
    
    all_resp_types = [all_resp_types resp_types_update_all(data, right_buttons_set, left_buttons_set)];
    
    
    
    %write condition specific data
    data = [];
    data.cond = 'Col1';
   
    
    data.stims  =  all_vals';
    data.feature_cue  =  2*ones(length(data.stims),1);  %since ori
    data.spatial_cue  =  all_cue_index';
    data.feature_cue_rel2_prev_trial  =  zeros(length(data.stims),1);  %always 0, since always col
    data.spatial_cue_rel2_prev_trial  =  all_deltas_sp';
    data.distractors  =  all_vals_distr';
    data.stims_irrel_feat  =  all_vals_irrel';
    data.distractors_irrel_feat  =  all_vals_irrel_distr';
    data.resp  =  all_resp';
    data.resp_types = all_resp_types';
    data.rt = all_rt';
    data.params_adaptive = outputs{1,1};
    
    alldata(par).cond_Col1  =  data;
    
    
    
    
    strtofind = 'COL2.mat';
    ix = regexp(flst,strtofind);
    ix = ~cellfun('isempty',ix);
    load(flst{ix})
    
    
    if eye_tracking(par)
        trials_completed2 = dlmread(sprintf('%s%s', Subj_name,'COL20_ended_tr.txt'));
        data = data(trials_completed2);
    else
        data = data(1:100);
    end
    
    all_vals = [all_vals data(find([data.trial_type]'  ==  2)).colors];
    all_vals_distr = [all_vals_distr data(find([data.trial_type]'  ==  2)).colors_0];
    all_vals_irrel = [all_vals_irrel data(find([data.trial_type]'  ==  2)).orientations];
    all_vals_irrel_distr = [all_vals_irrel_distr data(find([data.trial_type]'  ==  2)).colors_0];
    all_resp = [all_resp data(find([data.trial_type]'  ==  2)).resp];
    all_rt = [all_rt   data(find([data.trial_type]'  ==  2)).reaction_time];
    all_cue_index = [all_cue_index data(find([data.trial_type]'  ==  2)).cue_index];
    all_deltas_sp = [all_deltas_sp 0 abs([data(2:end).cue_index]-[data(1:end-1).cue_index])];
    
    all_resp_types = [all_resp_types resp_types_update_all(data, right_buttons_set, left_buttons_set)];
    
    
    
    %write condition specific data
    data = [];
    data.cond = 'Col2';
    
    
    
    data.stims  =  all_vals';
    data.feature_cue  =  2*ones(length(data.stims),1);  %since ori
    data.spatial_cue  =  all_cue_index';
    data.feature_cue_rel2_prev_trial  =  zeros(length(data.stims),1);  %always 0, since always col
    data.spatial_cue_rel2_prev_trial  =  all_deltas_sp';
    data.distractors  =  all_vals_distr';
    data.stims_irrel_feat  =  all_vals_irrel';
    data.distractors_irrel_feat  =  all_vals_irrel_distr';
    data.resp  =  all_resp';
    data.resp_types = all_resp_types';
    data.rt = all_rt';
    data.params_adaptive = outputs{1,1};
    
    
    alldata(par).cond_Col2  =  data;
    
    
    
    
    % SWITCH BLOCKS
    
    strtofind = 'SWITCH1.mat'; 
    ix = regexp(flst,strtofind);
    ix = ~cellfun('isempty',ix);
    load(flst{ix})
    
    if eye_tracking(par)
        trials_completed1 = dlmread(sprintf('%s%s', Subj_name,'SW10_ended_tr.txt'));
        data = data(trials_completed1);
    else
        data = data(1:200);  
    end
    
    
    all_deltas_sp = [];
    all_deltas_feat = [];
    all_types = [];   %feature
    all_cue_index = [];
    all_rt_all = [];
    all_oris_all = [];
    all_cols_all = [];
    all_distr_oris_all = [];
    all_distr_cols_all = [];
    all_resp_all = [];
    all_resp_types =[];
    
    
    all_deltas_sp = [all_deltas_sp 0 abs([data(2:end).cue_index]-[data(1:end-1).cue_index])];
    all_deltas_feat = [all_deltas_feat 0 abs([data(2:end).trial_type]-[data(1:end-1).trial_type])];
    all_types = [all_types [data.trial_type]];
    all_cue_index = [all_cue_index [data.cue_index]];
    
    all_rt_all = [all_rt_all [data.reaction_time]];
    all_oris_all = [all_oris_all [data.orientations]];
    all_cols_all = [all_cols_all [data.colors]];
    all_distr_oris_all = [all_distr_oris_all [data.orientations_0]];
    all_distr_cols_all = [all_distr_cols_all [data.colors_0]];
    all_resp_all = [all_resp_all [data.resp]];
    all_resp_types = [all_resp_types resp_types_update_all(data, right_buttons_set, left_buttons_set)];
    
    %write condition specific data
    data = [];
    data.cond = 'OriS1';
    
    if eye_tracking(par)
        data.trials_completed_total  =  max(trials_completed1) + max(trials_completed2);
    else
        data.trials_completed_total = 400;
    end
    
    
    data.stims  =  all_oris_all(all_types  ==  1)';
    data.feature_cue  =  1*ones(length(data.stims),1);  %since ori
    data.spatial_cue  =  all_cue_index(all_types  ==  1)';
    data.feature_cue_rel2_prev_trial  =  all_deltas_feat(all_types  ==  1)';
    data.spatial_cue_rel2_prev_trial  =  all_deltas_sp(all_types  ==  1)';
    data.distractors  =  all_distr_oris_all(all_types  ==  1)';
    data.stims_irrel_feat  =  all_cols_all(all_types  ==  1)';
    data.distractors_irrel_feat  =  all_distr_cols_all(all_types  ==  1)';
    data.resp  =  all_resp_all(all_types  ==  1)';
    data.rt  = all_rt_all(all_types  ==  1)';
    data.resp_types  =  all_resp_types(all_types  ==  1)';
    data.params_adaptive = outputs{1,1};
    
    
    alldata(par).cond_OriS1  =  data;
    
    
    
    % write condition specific data
    data = [];
    data.cond = 'ColS1';
    
   
    data.stims  =  all_cols_all(all_types  ==  2)';
    data.feature_cue  =  2*ones(length(data.stims),1);  %since ori
    data.spatial_cue  =  all_cue_index(all_types  ==  2)';
    data.feature_cue_rel2_prev_trial  =  all_deltas_feat(all_types  ==  2)';
    data.spatial_cue_rel2_prev_trial  =  all_deltas_sp(all_types  ==  2)';
    data.distractors  =  all_distr_cols_all(all_types  ==  2)';
    data.stims_irrel_feat  =  all_oris_all(all_types  ==  2)';
    data.distractors_irrel_feat  =  all_distr_oris_all(all_types  ==  2)';
    data.resp  =  all_resp_all(all_types  ==  2)';
    data.rt  = all_rt_all(all_types  ==  2)';
    data.resp_types  =  all_resp_types(all_types  ==  1)';
    data.params_adaptive = outputs{1,2};
    
    
   
    alldata(par).cond_ColS1  =  data;
    
    
    
    
    strtofind = 'SWITCH2.mat';
    ix = regexp(flst,strtofind);
    ix = ~cellfun('isempty',ix);
    load(flst{ix})
    
    if eye_tracking(par)
        trials_completed2 = dlmread(sprintf('%s%s', Subj_name,'SW20_ended_tr.txt'));
        data = data(trials_completed2);
    else
        data = data(1:200);
    end
    
    all_deltas_sp = [];
    all_deltas_feat = [];
    all_types = [];   %feature
    all_cue_index = [];
    all_rt_all = [];
    all_oris_all = [];
    all_cols_all = [];
    all_distr_oris_all = [];
    all_distr_cols_all = [];
    all_resp_all = [];
    all_resp_types =[];
    
    
    all_deltas_sp = [all_deltas_sp 0 abs([data(2:end).cue_index]-[data(1:end-1).cue_index])];
    all_deltas_feat = [all_deltas_feat 0 abs([data(2:end).trial_type]-[data(1:end-1).trial_type])];
    all_types = [all_types [data.trial_type]];
    all_cue_index = [all_cue_index [data.cue_index]];
    
    all_rt_all = [all_rt_all [data.reaction_time]];
    all_oris_all = [all_oris_all [data.orientations]];
    all_cols_all = [all_cols_all [data.colors]];
    all_distr_oris_all = [all_distr_oris_all [data.orientations_0]];
    all_distr_cols_all = [all_distr_cols_all [data.colors_0]];
    all_resp_all = [all_resp_all [data.resp]];
    
    all_resp_types = [all_resp_types resp_types_update_all(data, right_buttons_set, left_buttons_set)];
    
    
    
    %write condition specific data
    data = [];
    data.cond = 'OriS2';
    
    if eye_tracking(par)
        data.trials_completed_total  =  max(trials_completed1) + max(trials_completed2);
    else
        data.trials_completed_total = 400;
    end
    
    
    data.stims  =  all_oris_all(all_types  ==  1)';
    data.feature_cue  =  1*ones(length(data.stims),1);  %since ori
    data.spatial_cue  =  all_cue_index(all_types  ==  1)';
    data.feature_cue_rel2_prev_trial  =  all_deltas_feat(all_types  ==  1)';
    data.spatial_cue_rel2_prev_trial  =  all_deltas_sp(all_types  ==  1)';
    data.distractors  =  all_distr_oris_all(all_types  ==  1)';
    data.stims_irrel_feat  =  all_cols_all(all_types  ==  1)';
    data.distractors_irrel_feat  =  all_distr_cols_all(all_types  ==  1)';
    data.resp  =  all_resp_all(all_types  ==  1)';
    data.rt  = all_rt_all(all_types  ==  1)';
    data.resp_types  =  all_resp_types(all_types  ==  1)';
    data.params_adaptive = outputs{1,1};
    
    
    alldata(par).cond_OriS2  =  data;
    
    
    
    %write condition specific data
    data = [];
    data.cond = 'ColS2';
    
 
    data.stims  =  all_cols_all(all_types  ==  2)';
    data.feature_cue  =  2*ones(length(data.stims),1);  %since ori
    data.spatial_cue  =  all_cue_index(all_types  ==  2)';
    data.feature_cue_rel2_prev_trial  =  all_deltas_feat(all_types  ==  2)';
    data.spatial_cue_rel2_prev_trial  =  all_deltas_sp(all_types  ==  2)';
    data.distractors  =  all_distr_cols_all(all_types  ==  2)';
    data.stims_irrel_feat  =  all_oris_all(all_types  ==  2)';
    data.distractors_irrel_feat  =  all_distr_oris_all(all_types  ==  2)';
    data.resp  =  all_resp_all(all_types  ==  2)';
    data.rt  = all_rt_all(all_types  ==  2)';
    data.resp_types  =  all_resp_types(all_types  ==  1)';
   
    data.params_adaptive = outputs{1,2};
    
    
   
    alldata(par).cond_ColS2  =  data;
    
    

    
    
    
end

%save 'alldata_halves.mat' alldata

