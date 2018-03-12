function plot_params_cond(fig_ind,irrel_buttons,rt_med_iqr,rt_tau, param, cond_list)

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();
dsz = 2;
ns = 3;


figure(fig_ind)
set(gcf, 'Position', [100 100 440 320])

guttera = [0.11    0.16];
marginsa = [0.100    0.0800    0.1400    0.1000]; %[LEFT RIGHT BOTTOM TOP]

xloc = -1.9;
yloc = -1;


perm_test = 0;


for cond = 1 :4
    
    tight_subplot(ns,4,1,cond, guttera, marginsa)
    
    plot(log(param(1:20,cond,2)),log(irrel_buttons(1:20,cond)),'o', 'MarkerFaceColor', bluee, 'MarkerEdgeColor', bluee, 'MarkerSize', dsz); hold on;
    plot(log(param(21:40,cond,2)),log(irrel_buttons(21:40,cond)),'o', 'MarkerFaceColor',redd, 'MarkerEdgeColor', redd,'MarkerSize', dsz); hold on;
    
    set(gca, 'xtick', [-4:1:0])
    set(gca, 'ytick', [-4:1:0])
    set(gca, 'xticklabels', {'-4','', '-2','', '0'},'FontName', 'Helvetica', 'FOntSize', 0.9*fontsz)
    set(gca, 'yticklabels',{'-4','', '-2','', '0'},'FontName', 'Helvetica', 'FOntSize', 0.9*fontsz)
    xlim([-4.5 0])
    ylim([-5 0])
    
    if cond == 1
        ylabel('log TIMO', 'FontName', 'Helvetica', 'FOntSize', fontsz)
        
    end
    title(cond_list{cond},'FontName', 'Helvetica', 'FOntSize', fontsz)
    
    [rr_ca(cond),pp_ca(cond)] = corr(log(param(1:40,cond,2)), log(irrel_buttons(1:40,cond)), 'type', 'Spearman');
    [rr_c(cond),pp_c(cond)] = corr(log(param(1:20,cond,2)), log(irrel_buttons(1:20,cond)), 'type', 'Spearman');
    [rr_a(cond),pp_a(cond)] = corr(log(param(21:40,cond,2)), log(irrel_buttons(21:40,cond)), 'type', 'Spearman');
    
    xloc = -4.0;
    yloc = 0.2;
    
   
        text(xloc,yloc, ['\rho = ', num2str(rr_ca(cond),'%0.2f'), ', p = ', num2str(pp_ca(cond),'%0.3f')], 'FontSize', 0.8*fontsz, 'Color', 'k'); hold on;
    
    
    if perm_test
        d_ca1(cond) = abs(rr_c(cond)-rr_a(cond));
        
        for pi =1 :np
            ind_shf = randperm(Nsbj);
            
            [r_ctrlS(pi) p_ctrlS(pi)] = corr(log(param(ind_shf(1:20),cond,2)),log(irrel_buttons(ind_shf(1:20),cond)),'type','Spearman');
            [r_adhdS(pi) p_adhdS(pi)] = corr(log(param(ind_shf(21:40),cond,2)),log(irrel_buttons(ind_shf(21:40),cond)),'type','Spearman');
            
            disttt1(pi) = abs(r_ctrlS(pi) - r_adhdS(pi));
        end
        
        p_disttt1(cond) = sum(disttt1>=d_ca1(cond))/np;
        
    end
    
    xloc = -1.9;
    yloc = -1.9;
    
    box off
    set(gca, 'Tickdir', 'out')
    set(gca, 'ticklength', [0.04 0.04])
    
end


for cond =1 :4
    
    tight_subplot(ns,4,2,cond, guttera, marginsa)
    
    plot(log(param(1:20,cond,2)),log(rt_med_iqr(1:20,cond,2)), 'o','MarkerFaceColor', bluee, 'MarkerEdgeColor', bluee, 'MarkerSize', dsz); hold on;
    plot(log(param(21:40,cond,2)),log(rt_med_iqr(21:40,cond,2)),'o','MarkerFaceColor', redd, 'MarkerEdgeColor', redd, 'MarkerSize', dsz); hold on;
    
    set(gca, 'xtick', [-4:1:0])
    set(gca, 'ytick', [-2:0.5:0])
    set(gca, 'xticklabels', {'-4','', '-2','', '0'},'FontName', 'Helvetica', 'FOntSize', 0.9*fontsz)
    set(gca, 'yticklabels',{'-2','', '-1','', '0'},'FontName', 'Helvetica', 'FOntSize', 0.9*fontsz)
    xlim([-4.5 0])
    ylim([-2 0])
    
    [rr_ca(cond),pp_ca(cond)] = corr(log(param(1:40,cond,2)), log(rt_med_iqr(1:40,cond,2)), 'type', 'Spearman');
    [rr_c(cond),pp_c(cond)] = corr(log(param(1:20,cond,2)), log(rt_med_iqr(1:20,cond,2)), 'type', 'Spearman');
    [rr_a(cond),pp_a(cond)] = corr(log(param(21:40,cond,2)), log(rt_med_iqr(21:40,cond,2)), 'type', 'Spearman');
    
    
    xloc = -4.0;
    yloc = 0.2;
    
    text(xloc,yloc, ['\rho = ', num2str(rr_ca(cond),'%0.2f'), ', p = ', num2str(pp_ca(cond),'%0.3f')], 'FontSize', 0.8*fontsz, 'Color', 'k'); hold on;
    
    
    if perm_test
        d_ca2(cond) = abs(rr_c(cond)-rr_a(cond));
        
        for pi = 1 :np
            ind_shf = randperm(Nsbj);
            
            [r_ctrlS(pi) p_ctrlS(pi)] = corr(log(param(ind_shf(1:20),cond,2)),log(rt_med_iqr(ind_shf(1:20),cond,2)),'type','Spearman');
            [r_adhdS(pi) p_adhdS(pi)] = corr(log(param(ind_shf(21:40),cond,2)),log(rt_med_iqr(ind_shf(21:40),cond,2)),'type','Spearman');
            
            disttt2(pi) = abs(r_ctrlS(pi) - r_adhdS(pi));
        end
        
        p_disttt2(cond) = sum(disttt2 >= d_ca2(cond))/np;
    end
    
    if cond == 1
        ylabel('log RT', 'FontName', 'Helvetica', 'FOntSize', fontsz)
        
    end
    
    box off
    set(gca, 'Tickdir', 'out')
    set(gca, 'ticklength', [0.04 0.04])
    
end





for cond = 1:4
    
    tight_subplot(ns,4,3,cond, guttera, marginsa)
    
    plot(log(param(1:20,cond,2)),log(rt_tau(1:20,cond)),'o', 'MarkerFaceColor', bluee, 'MarkerEdgeColor', bluee, 'MarkerSize', dsz); hold on;
    plot(log(param(21:40,cond,2)),log(rt_tau(21:40,cond)), 'o','MarkerFaceColor', redd, 'MarkerEdgeColor', redd, 'MarkerSize', dsz); hold on;
    
    
    
    set(gca, 'xtick', [-4:1:0])
    set(gca, 'ytick', [-2:0.5:0])
    set(gca, 'xticklabels', {'-4','', '-2','', '0'},'FontName', 'Helvetica', 'FOntSize', 0.9*fontsz)
    set(gca, 'yticklabels',{'-2','', '-1','', '0'},'FontName', 'Helvetica', 'FOntSize', 0.9*fontsz)
    xlim([-4.5 0])
    ylim([-2 0])
    
    if cond == 1
        ylabel('log RT \tau', 'FontName', 'Helvetica', 'FOntSize', fontsz)
        xlabel('log Perceptual variability', 'FontName', 'Helvetica', 'FOntSize', fontsz)
    end
    
    [rr_ca(cond),pp_ca(cond)]= corr(log(param(1:40,cond,2)), log(rt_tau(1:40,cond)), 'type', 'Spearman');
    [rr_c(cond),pp_c(cond)]= corr(log(param(1:20,cond,2)), log(rt_tau(1:20,cond)), 'type', 'Spearman');
    [rr_a(cond),pp_a(cond)]= corr(log(param(21:40,cond,2)), log(rt_tau(21:40,cond)), 'type', 'Spearman');
    
    xloc = -4.0;
    yloc = 0.2;
    
    text(xloc,yloc, ['\rho = ', num2str(rr_ca(cond),'%0.2f'), ', p = ', num2str(pp_ca(cond),'%0.3f')], 'FontSize', 0.8*fontsz, 'Color', 'k'); hold on;
    
    if perm_test
        d_ca3(cond) = abs(rr_c(cond)-rr_a(cond));
        
        for pi = 1 :np
            ind_shf = randperm(Nsbj);
            
            [r_ctrlS(pi) p_ctrlS(pi)] = corr(log(param(ind_shf(1:20),cond,2)),log(rt_tau(ind_shf(1:20),cond)),'type','Spearman');
            [r_adhdS(pi) p_adhdS(pi)] = corr(log(param(ind_shf(21:40),cond,2)),log(rt_tau(ind_shf(21:40),cond)),'type','Spearman');
            
            disttt3(pi) = abs(r_ctrlS(pi) - r_adhdS(pi));
        end
        
        p_disttt3(cond) = sum(disttt3>=d_ca3(cond))/np;
        
    end
    
    
    xloc = -1.9;
    yloc = -1.4;
    
    
    
    box off
    set(gca, 'Tickdir', 'out')
    set(gca, 'ticklength', [0.04 0.04])
    
end

%%
psname_par=['params_RT_vFINF.pdf'];
%print_pdf(psname_par)


end