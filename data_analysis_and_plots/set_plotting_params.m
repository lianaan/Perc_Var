function [fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params()
% plotting parameters
fontsz = 12;
dsz = 4;


msz1 = 4;
msz2 = 3;
eb_w = 0.4;%errorbar width
eb_t = 0.5; %errorbar line thickness



nboot = 500; %for 95% bootstrapped confidence intervals
ci_bnd_low = 0.025;
ci_bnd_high = 0.975;


redd = [0.9047    0.1918    0.1988];
bluee = [0.2941    0.5447    0.7494];
redd_shade=(redd+2*[1 1 1])/3;
bluee_shade=(bluee+2*[1 1 1])/3;
colormat_adhd=[redd; redd; redd; redd];
colormat_ctrl=[bluee; bluee; bluee; bluee];
colormat=[colormat_ctrl(1,:); colormat_adhd(1,:); colormat_ctrl(2,:); colormat_adhd(2,:);...
    colormat_ctrl(3,:); colormat_adhd(3,:); colormat_ctrl(4,:); colormat_adhd(4,:)];


bar_ind_ctrl=[1 4 8 11];%[1 2 4 5]; %[1 4 8 11]; %[1 2 4 5];%
bar_ind_adhd=[2 5 9 12];%[8 9 11 12];%[2 5 9 12]; %[8 9 11 12];%

end
