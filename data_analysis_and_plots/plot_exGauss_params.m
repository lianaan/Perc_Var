function plot_exGauss_params(fig_ind,ind_ctrl, ind_adhd,RT_pars_fit)

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();


figure(fig_ind)
set(gcf, 'Position', [100 100 320 160])

marginsa = [0.1 0.12 0.26 0.13];
guttera = [0.07 0.1];

ymax = [0.6 0.2 1];
titles_list = {'mu','sigma', 'tau'};

for pi = 1:2 %param index
    
    clear h; clear he;
    
    median_epar_ctrl = median(squeeze(exp(RT_pars_fit(ind_ctrl,1,:,pi))));
    median_epar_adhd = median(squeeze(exp(RT_pars_fit(ind_adhd,1,:,pi))));
    
    par_ctrl = [];
    par_adhd = [];
    
    
    for kk = 1:nboot
        for jj = 1:4
            sample = randsample(exp(RT_pars_fit(ind_ctrl,1,jj,pi)),length(ind_ctrl),1);
            par_ctrl(kk,jj) = median(sample);
            
            sample2 = randsample(exp(RT_pars_fit(ind_adhd,1,jj,pi)),length(ind_adhd),1);
            par_adhd(kk,jj) = median(sample2);
        end
    end
    
    bci_epar_ctrl = [quantile(par_ctrl,ci_bnd_low); quantile(par_ctrl,ci_bnd_high)];
    bci_epar_adhd = [quantile(par_adhd,ci_bnd_low); quantile(par_adhd,ci_bnd_high)];
    
    tight_subplot(1,2,1,pi,guttera, marginsa)
    
    for jj = 1:4
        ii = bar_ind_ctrl(jj);
        ij = 2*(jj-1)+1;
        h(ii) = bar(ii,median_epar_ctrl(jj)); hold on;
        set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:)); hold on;
        he(ii) = errorbar(ii,median_epar_ctrl(jj),median_epar_ctrl(jj)-bci_epar_ctrl(1,jj),bci_epar_ctrl(2,jj)-median_epar_ctrl(jj)); hold on;
        set(he(ii), 'Color', 'k', 'Linewidth', 0.5); hold on;
        errorbarT(he(ii),eb_w,eb_t)
    end
    
    
    for jj = 1:4
        ii = bar_ind_adhd(jj);
        ij = 2*jj;
        h(ii) = bar(ii,median_epar_adhd(jj)); hold on;
        set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:)); hold on;
        he(ii) = errorbar(ii,median_epar_adhd(jj),median_epar_adhd(jj)-bci_epar_adhd(1,jj),bci_epar_adhd(2,jj)-median_epar_adhd(jj)); hold on;
        set(he(ii), 'Color', 'k', 'Linewidth', 0.5); hold on;
        errorbarT(he(ii),eb_w,eb_t)
        
    end
    
    box off
    set(gca, 'XTick',[1.5 4.5 8.5 11.5]);
    set(gca, 'xTickLabel',{'Ori', 'OriS','Col', 'ColS'}, 'Fontname', 'Helvetica', 'FontSize', 0.4*fontsz);
    set(gca, 'ytick',[0:ymax(pi)/4:ymax(pi)])
    set(gca, 'yticklabels',{'0','',num2str(ymax(pi)/2),'',num2str(ymax(pi))},'FontName', 'Helvetica', 'FontSize', 0.9*fontsz)
    set(gca, 'Tickdir', 'out')
    set(gca, 'ticklength', [0.0400    0.0400])
    ylim([0 1.1*ymax(pi)])
    xlim([0 13])
    
end

%%
psname='ex_Gauss_paramsFF.pdf';
%print_pdf(psname)
end