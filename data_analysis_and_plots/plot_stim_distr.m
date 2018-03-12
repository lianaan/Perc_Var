function plot_stim_distr(fig_ind,stims_cond_all, cond_list)

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();


% distributions of stimuli that participants received
nbinz3 = 13;
binz3_ = [];
binz3_ = linspace(-0.5,0.5,nbinz3+1);
binz3_pos = (binz3_(2:end)+binz3_(1:end-1))/2;

Nsbj = size(stims_cond_all,1);

figure(fig_ind)

set(gcf, 'Position', [100 100 520 140])
marginsa = [0.1 0.1 0.28 0.1];
guttera = [0.05 0.12];

[nhistC, woutC, nhistA, woutA] = deal(nan(4,(nbinz3+1)));
[nhist, wout] = deal(nan(4,Nsbj,(nbinz3+1)));


for ci = 1 : 4
    stims_allC = squeeze(stims_cond_all(1:20,ci,:));
    stims_allA = squeeze(stims_cond_all(21:40,ci,:));
    [nhistC(ci,1:(nbinz3+1)), woutC(ci,1:(nbinz3+1))] = hist(stims_allC(:), binz3_);
    [nhistA(ci,1:(nbinz3+1)), woutA(ci,1:(nbinz3+1))] = hist(stims_allA(:), binz3_);
    for pi = 1: Nsbj
        [nhist(ci,pi,1:(nbinz3+1)), wout(ci,pi,1:(nbinz3+1))] = hist(squeeze(stims_cond_all(pi,ci,:)), binz3_);
        
        tight_subplot(1,4,1,ci,guttera, marginsa)
        if pi<=20
            plot(binz3_,squeeze(nhist(ci,pi,:))/sum(nhist(ci,pi,:)), 'Color', bluee_shade); hold on;  
        else
            plot(binz3_,squeeze(nhist(ci,pi,:))/sum(nhist(ci,pi,:)), 'Color', redd_shade); hold on;
        end
        
    end
    plot(binz3_,nhistC(ci,:)/sum(nhistC(ci,:)), 'Color', bluee, 'Linewidth',1); hold on;
    plot(binz3_,nhistA(ci,:)/sum(nhistA(ci,:)), 'Color', redd, 'Linewidth',1); hold on;
    xlim([-0.5 0.5]);
    set(gca, 'xtick', [-0.5:0.25:0.5]);
    set(gca, 'xticklabels',{'-0.5','', '0','','0.5'}, 'FontName', 'Helvetica', 'FontSize', fontsz)
    set(gca, 'ytick', [0:0.25:1]);
    if ci > 1
        set(gca, 'yticklabels', {});
    end
    ylim([0 1]);
    box off
    set(gca, 'tickdir', 'out')
    set(gca, 'Ticklength', [0.0400    0.0400])
    text(0,-0.35,cond_list{ci}, 'FontName', 'Helvetica', 'FontSize', fontsz)
end

%psname = 'distr_stim_F.pdf'
%print_pdf(psname)

end