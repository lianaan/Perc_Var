function plot_learning(fig_ind,ind_ctrl, ind_adhd, cond_list)

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();

load('sigmas_M2_halves.mat')

cond_list_blocks = {'Ori1', 'Ori2', 'Col1', 'Col2', 'OriS1', 'ColS1', 'OriS2', 'ColS2'};

Nsubj = size(sigmas_M2_halves,1);

mi = 2; % only load the model with shared params


ind_map = [1 2 5 7 3 4 6 8];

bar_ind_ctrl = [1 2 5 6 11 12 15 16];
bar_ind_adhd = [3 4 7 8 13 14 17 18];


median_sig_ctrl = median(sigmas_M2_halves(ind_ctrl,:));
median_sig_adhd = median(sigmas_M2_halves(ind_adhd,:));


sample = [];
sample2 = [];
for kk = 1:nboot
    for jj = 1:8
        sample = randsample(sigmas_M2_halves(ind_ctrl,jj),length(ind_ctrl),1);
        sig_ctrl(kk,jj) = median(sample);
        
        sample2 = randsample(sigmas_M2_halves(ind_adhd,jj),length(ind_adhd),1);
        sig_adhd(kk,jj) = median(sample2);
    end
end


bci_sig_ctrl = [quantile(sig_ctrl,ci_bnd_low); quantile(sig_ctrl,ci_bnd_high)];
bci_sig_adhd = [quantile(sig_adhd,ci_bnd_low); quantile(sig_adhd,ci_bnd_high)];


figure(fig_ind)
set(gcf, 'Position', [100 100 520 280])
marginsa1=[0.1 0.12 0.26 0.13]; %left right bottom top
guttera1=[0.07 0.14]; % btwn cols, btwn rows

tight_subplot(2,1,1,1, guttera1, marginsa1)
for ci = 1:4
    bar(bar_ind_ctrl(2*ci-1), median(sigmas_M2_halves(1:20,ind_map(2*ci-1))), 'FaceColor', bluee, 'EdgeColor',bluee, 'BarWidth',0.6); hold on;
    bar(bar_ind_ctrl(2*ci), median(sigmas_M2_halves(1:20,ind_map(2*ci))), 'FaceColor', bluee, 'EdgeColor',bluee, 'BarWidth',0.6); hold on;
    
    hc1(2*ci-1) = errorbar(bar_ind_ctrl(2*ci-1),median_sig_ctrl(ind_map(2*ci-1)),median_sig_ctrl(ind_map(2*ci-1))-bci_sig_ctrl(1,ind_map(2*ci-1)),bci_sig_ctrl(2,ind_map(2*ci-1))-median_sig_ctrl(ind_map(2*ci-1))); hold on;
    set(hc1(2*ci-1), 'Color', 'k', 'Linewidth', 1)
    errorbarT(hc1(2*ci-1),eb_w,eb_t)
    
    hc2(2*ci) = errorbar(bar_ind_ctrl(2*ci),median_sig_ctrl(ind_map(2*ci)),median_sig_ctrl(ind_map(2*ci))-bci_sig_ctrl(1,ind_map(2*ci)),bci_sig_ctrl(2,ind_map(2*ci))-median_sig_ctrl(ind_map(2*ci))); hold on;
    set(hc2(2*ci), 'Color', 'k', 'Linewidth', 1)
    errorbarT(hc2(2*ci),eb_w,eb_t)
    
    
    
    bar(bar_ind_adhd(2*ci-1), median(sigmas_M2_halves(21:40,ind_map(2*ci-1))), 'FaceColor', redd, 'EdgeColor',redd, 'BarWidth',0.6); hold on;
    bar(bar_ind_adhd(2*ci), median(sigmas_M2_halves(21:40,ind_map(2*ci))), 'FaceColor', redd, 'EdgeColor',redd, 'BarWidth',0.6); hold on;
    
    ha1(2*ci-1) = errorbar(bar_ind_adhd(2*ci-1),median_sig_adhd(ind_map(2*ci-1)),median_sig_adhd(ind_map(2*ci-1))-bci_sig_adhd(1,ind_map(2*ci-1)),bci_sig_adhd(2,ind_map(2*ci-1))-median_sig_adhd(ind_map(2*ci-1))); hold on;
    set(ha1(2*ci-1), 'Color', 'k', 'Linewidth', 1)
    errorbarT(ha1(2*ci-1),eb_w,eb_t)
    
    ha2(2*ci) = errorbar(bar_ind_adhd(2*ci),median_sig_adhd(ind_map(2*ci)),median_sig_adhd(ind_map(2*ci))-bci_sig_adhd(1,ind_map(2*ci)),bci_sig_adhd(2,ind_map(2*ci))-median_sig_adhd(ind_map(2*ci))); hold on;
    set(ha2(2*ci), 'Color', 'k', 'Linewidth', 1)
    errorbarT(ha2(2*ci),eb_w,eb_t)
    
end
box off
xlim([0.5 18.5])
ylim([0 0.16])
set(gca,'tickdir', 'out')
set(gca, 'ticklength', [0.01 0.01])
set(gca, 'xtick', (bar_ind_ctrl(2:end) + bar_ind_adhd(1:(end-1)))/2)
set(gca, 'xticklabels', {})
set(gca, 'ytick',[0:0.025:0.125])
set(gca, 'yticklabels',{'0','','0.05','','0.1',''},'Fontname', 'Helvetica', 'FontSize', 0.8*fontsz)



tight_subplot(2,1,2,1, guttera1, marginsa1)
for i = 1:20
    for ci = 1:4
        plot([bar_ind_ctrl(2*ci-1), bar_ind_ctrl(2*ci)], [log(sigmas_M2_halves(i,ind_map(2*ci-1))), log(sigmas_M2_halves(i,ind_map(2*ci)))], 'Color', bluee); hold on;
        
    end
end

for i = 21:40
    for ci = 1:4
        plot([bar_ind_adhd(2*ci-1), bar_ind_adhd(2*ci)], [log(sigmas_M2_halves(i,ind_map(2*ci-1))), log(sigmas_M2_halves(i,ind_map(2*ci)))], 'Color', redd); hold on;
    end
end
box off
xlim([0.5 18.5])
ylim([-6.5 -0.4])

set(gca,'tickdir', 'out')
set(gca, 'ticklength', [0.01 0.01])
set(gca, 'xtick', (bar_ind_ctrl(2:end) + bar_ind_adhd(1:(end-1)))/2)
set(gca, 'xticklabels', {})
set(gca, 'ytick',[-7:1:0])
set(gca, 'yticklabels',{'-7','','-5','','-3','','-1'},'FontName', 'Helvetica', 'FontSize', 0.8*fontsz)


for ci = 1:4
    text(bar_ind_ctrl(2*ci)+0.2, -8.03, cond_list{ci}, 'FontName', 'Helvetica', 'FontSize', fontsz)
end

%%
%psname = 'per_var_across_blocksEF.pdf'
%print_pdf(psname)


end
