function plot_RT_iqr(fig_ind, ind_ctrl, ind_adhd, rt_iqr)

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params()

%rt_iqr = squeeze(rt_med_iqr(:,:,3) - rt_med_iqr(:,:,1));

median_rt_iqr_ctrl = median(rt_iqr(ind_ctrl,:));
median_rt_iqr_adhd = median(rt_iqr(ind_adhd,:));

sample = [];
sample2 = [];

for kk = 1:nboot
    for jj = 1:4
        sample = randsample(rt_iqr(ind_ctrl,jj),length(ind_ctrl),1);
        RT_iqr_ctrl(kk,jj) = median(sample);
        
        sample2 = randsample(rt_iqr(ind_adhd,jj),length(ind_adhd),1);
        RT_iqr_adhd(kk,jj) = median(sample2);
    end
end

bci_rt_iqr_ctrl = [quantile(RT_iqr_ctrl,ci_bnd_low); quantile(RT_iqr_ctrl,ci_bnd_high)];
bci_rt_iqr_adhd = [quantile(RT_iqr_adhd,ci_bnd_low); quantile(RT_iqr_adhd,ci_bnd_high)];



figure(fig_ind)

set(gcf, 'Position', [100 100 220 140])

for jj=1:4
    
    ii=bar_ind_ctrl(jj);
    ij=2*(jj-1)+1;
    h(ii)=bar(ii,median_rt_iqr_ctrl(jj)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii)=errorbar(ii,median_rt_iqr_ctrl(jj), median_rt_iqr_ctrl(jj)-bci_rt_iqr_ctrl(1,jj),bci_rt_iqr_ctrl(2,jj)-median_rt_iqr_ctrl(jj) ); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 1)
    errorbarT(he(ii),eb_w,eb_t)
    
end


for jj=1:4
    ii=bar_ind_adhd(jj);
    ij=2*jj;
    h(ii)=bar(ii,median_rt_iqr_adhd(jj)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii)=errorbar(ii,median_rt_iqr_adhd(jj), median_rt_iqr_adhd(jj)-bci_rt_iqr_adhd(1,jj),bci_rt_iqr_adhd(2,jj)-median_rt_iqr_adhd(jj) ); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 1)
    errorbarT(he(ii),eb_w,eb_t)
    
end

box off
xlim([0 12.5])
set(gca, 'XTick',[1.5 4.5 8.5 11.5]);
set(gca, 'xTickLabel',{'Ori', 'OriS','Col', 'ColS'}, 'Fontname', 'Helvetica', 'FontSize', 0.5*fontsz);
set(gca, 'ytick',[0:0.25:1.25])
set(gca, 'yticklabels',{'0','','0.5','','1'},'FontName', 'Helvetica', 'FontSize', 0.9*fontsz)
set(gca, 'Tickdir', 'out')
set(gca, 'ticklength', [0.04 0.04])


ylabel('RT iqr (s)','Fontname', 'Helvetica', 'FontSize', 0.9*fontsz);


end

