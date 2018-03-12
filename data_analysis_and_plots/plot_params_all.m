function plot_params_all(fig_ind,ind_ctrl, ind_adhd, params,prop_cw_or_yellow, prop_cw_or_yellow_PRED,binz_all_pos, all_stims, cond_list)


[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();


figure(fig_ind)
set(gcf, 'Position', [100 100 460 580])

nbinz = 7;
binz_ = [];
for jj = 1:nbinz
    binz_(jj) = quantile(all_stims, jj/nbinz);
end
binz_ = [min(all_stims) binz_ ];
binz_pos = (binz_(2:end)+binz_(1:end-1))/2;


label_list = {'orientation (n.u.) ','orientation (n.u.) ','color (n.u.)','color (n.u.)'};
xlim_min = min([ binz_ -0.5]);
xlim_max = max([ binz_ 0.5]);


marginsa = [0.08 0.08 0.1 0.1];
guttera = [0.09 0.07];

ci_bnd_low = 0.025;
ci_bnd_high = 0.975;

markersz = 3;

prop_cw_or_yellow(prop_cw_or_yellow == 0) = 0.0001;  %otherwise nanmedian doesnt work

fontsz = 9;

mii_ind = [1 2];
for mii = 1:2
    mi = mii_ind(mii);
    
    param(1:40,1:4,1) = squeeze(params(1:40,mi,1,[1 2 3 4]));
    param(1:40,1:4,2) = squeeze(params(1:40,mi,2,[1 2 3 4]));
    param(1:40,1:4,3) = squeeze(params(1:40,mi,3,[1 2 3 4]));
    
    for kk = 1:nboot
        for jj = 1:4
            for pi = 1:3 %3 params
                sample=randsample(squeeze(param(ind_ctrl,jj,pi)),length(ind_ctrl),1);
                par_ctrl(kk,jj,pi)=median(sample);
                
                sample2=randsample(squeeze(param(ind_adhd,jj,pi)),length(ind_adhd),1);
                par_adhd(kk,jj,pi)=median(sample2);
            end
        end
    end
    
    bci_par_ctrl = [squeeze(quantile(par_ctrl,ci_bnd_low)); squeeze(quantile(par_ctrl,ci_bnd_high))];
    bci_par_adhd = [squeeze(quantile(par_adhd,ci_bnd_low)); squeeze(quantile(par_adhd,ci_bnd_high))];
    
    for par = 1:40
        for cond = 1:4
            % Psychometric curve predictions based on fitted parameters
            prop_cw_or_yellow_PRED(par,cond,1:nbinz) = function_psi(binz_all_pos(par,cond,:),...
                param(par,cond,1),param(par,cond,2), param(par,cond,3));
        end
    end
    
    for j = 1:2 % Control vs ADHD
        for cond = 1:4
            
            tight_subplot(6,12,3*(mii-1)+j,3*(cond-1)+1:3*(cond-1)+3, guttera,marginsa)
            if j == 1
                h_p = fill([binz_pos binz_pos(end:-1:1)],   [(squeeze(quantile(prop_cw_or_yellow_PRED(ind_ctrl,cond,:),0.25)))'...
                    fliplr(squeeze(quantile(prop_cw_or_yellow_PRED(ind_ctrl,cond,:),0.75))')],bluee_shade, 'EdgeColor', 'None'); hold on;
                plot(binz_pos,squeeze(nanmedian(prop_cw_or_yellow(ind_ctrl,cond,:))), 'o','MarkerEdgeColor', bluee,'MarkerFaceColor',bluee,'MarkerSize',markersz); hold on;
                le = errorbar(binz_pos, squeeze(nanmedian(prop_cw_or_yellow(ind_ctrl,cond,:))),squeeze(nanmedian(prop_cw_or_yellow(ind_ctrl,cond,:)))-squeeze(quantile(prop_cw_or_yellow(ind_ctrl,cond,:),0.25)),squeeze(quantile(prop_cw_or_yellow(ind_ctrl,cond,:),0.75))-squeeze(nanmedian(prop_cw_or_yellow(ind_ctrl,cond,:))) ); hold on;
                set(le,'Color', bluee, 'Linewidth',0.7)
                if mii == 1
                    title(cond_list(cond), 'FontName', 'Helvetica', 'FontSize', fontsz)
                end
                box off
                
            elseif j == 2
                h_p2 = fill([binz_pos binz_pos(end:-1:1)],   [(squeeze(quantile(prop_cw_or_yellow_PRED(ind_adhd,cond,:),0.25)))'...
                    fliplr((squeeze(quantile(prop_cw_or_yellow_PRED(ind_adhd,cond,:),0.75)))')],redd_shade, 'EdgeColor', 'None'); hold on;
                plot(binz_pos,(squeeze(nanmedian(prop_cw_or_yellow(ind_adhd,cond,:)))), 'o','MarkerEdgeColor', redd,'MarkerFaceColor',redd,'MarkerSize',markersz); hold on;
                le2 = errorbar(binz_pos, squeeze(nanmedian(prop_cw_or_yellow(ind_adhd,cond,:))),squeeze(nanmedian(prop_cw_or_yellow(ind_adhd,cond,:)))-squeeze(quantile(prop_cw_or_yellow(ind_adhd,cond,:),0.25)),squeeze(quantile(prop_cw_or_yellow(ind_adhd,cond,:),0.75))-squeeze(nanmedian(prop_cw_or_yellow(ind_adhd,cond,:))) ); hold on;
                set(le2,'Color', redd, 'Linewidth',0.7)
                box off
            end
            xlim([xlim_min xlim_max])
            ylim([0 1.01])
            if cond > 1
                set(gca, 'yticklabels', [])
            end
            set(gca, 'xtick', [-0.5:0.25:0.5])
            set(gca,'xticklabels',{'-0.5', '', '0', '', '0.5'}, 'FontName', 'Helvetica', 'FontSize', fontsz)
            set(gca, 'ytick', [0:0.25:1])
            set(gca, 'yticklabels', {'0', '', '0.5', '', '1'}, 'FontName', 'Helvetica', 'FontSize', fontsz)
            xlabel(label_list{cond},'FontName', 'Helvetica', 'FontSize', fontsz)
            ylabel('proportion', 'FontName', 'Helvetica', 'FontSize', fontsz)
            set(gca, 'tickdir', 'out')
            set(gca, 'ticklength', [0.0400    0.0400])
        end
    end
    
    for kj = 1:3
        tight_subplot(6,12,3*(mii-1)+j+1,4*(kj-1)+1:4*(kj-1)+4, guttera,marginsa)
        for ci = 1:4
            
            cic = bar_ind_ctrl(ci);
            h(ci) = bar(cic,squeeze(median(param(1:20,ci,kj)))'); hold on;
            set(h(ci), 'FaceColor', colormat(2*kj-1,:), 'EdgeColor',colormat(2*kj-1,:)); hold on;
            
            he(ci) = errorbar(cic,squeeze(median(param(1:20,ci,kj)))',squeeze(median(param(1:20,ci,kj)))'-bci_par_ctrl(ci,kj),bci_par_ctrl(4+ci,kj)-squeeze(median(param(1:20,ci,kj)))'); hold on;
            set(he(ci), 'Color', 'k', 'Linewidth', 1); hold on;
            errorbarT(he(ci),eb_w,eb_t)
            
            cia = bar_ind_adhd(ci);
            ha(ci) = bar(cia,squeeze(median(param(21:40,ci,kj)))'); hold on;
            set(ha(ci), 'FaceColor', colormat(2*kj,:), 'EdgeColor',colormat(2*kj,:)); hold on;
            
            hae(ci) = errorbar(cia,squeeze(median(param(21:40,ci,kj)))',squeeze(median(param(21:40,ci,kj)))'-bci_par_adhd(ci,kj),bci_par_adhd(4+ci,kj)-squeeze(median(param(21:40,ci,kj)))'); hold on;
            set(hae(ci), 'Color', 'k', 'Linewidth', 1); hold on;
            errorbarT(hae(ci),eb_w,eb_t)
            
            if kj == 1
                ylim([-0.1 0.1])
                set(gca, 'ytick',[-0.1:0.2/4:0.1])
            elseif kj == 2
                ylim([0 0.12])
                set(gca, 'ytick',[0:0.12/4:0.12])
            elseif kj == 3
                ylim([0 0.3])
                set(gca, 'ytick',[0:0.3/3:0.3])
            end
            
            xlim([0 13])
            set(gca, 'tickdir', 'out')
            set(gca, 'ticklength', [0.0400    0.0400])
            set(gca, 'XTick',[1.5 4.5 8.5 11.5]);
            set(gca, 'XTicklabels',[]);
            
        end
        
        box off
    end
    
end



%end
%%
psname_ps=['psych_curves_fullF.pdf']
%print_pdf(psname_ps)

end