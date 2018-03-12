function plot_RT_model_comp(fig_ind, curr_dir, rt_distrib)

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();

marginsa = [0.12 0.12 0.22 0.1]; %[LEFT RIGHT BOTTOM TOP]
guttera = [0.06 0.06];

n_sub = 4;

cd ..
cd([curr_dir, '/model_fitting/'])

no_params = [3 2 2]; %no of parameters of each RT model


%refit all the RT models not per cond, but for all the rt's per subject
for par = 1:size(rt_distrib,1)
    for rmi = 1:3 %for exGauss, gamma and log Normal
        [RT_pars_fit(par,rmi,1:no_params(rmi)), RT_nll(par,rmi)] = RT_models_fit(rmi,rt_distrib(par,:));
    end
end

cd ..
cd([curr_dir, '/data_analysis_and_plots/'])

Nsbj = size(RT_nll,1);


%metrics={'LL', 'AICc','BIC'}
metrics = { 'AICc','BIC'}
nm = length(metrics);

LL_M = -RT_nll;

no_trials = 800;

for j=1: length(no_params)
    AICc(:,j) = bsxfun(@plus, -2*LL_M(:,j),2*no_params(j)+(2*no_params(j).*(no_params(j)+1))./(no_trials-no_params(j)-1))
    BIC(:,j) = bsxfun(@plus, -2*LL_M(:,j),log(no_trials)*no_params(j))
end

%delta_LL= LL_M(:,2:3)-LL_M(:,1);
delta_AICc= bsxfun(@minus, AICc(:,1),AICc(:,2:3));
delta_BIC = bsxfun(@minus, BIC(:,1),BIC(:,2:3));

figure(fig_ind)
set(gcf, 'Position', [100 100 500 160])


letters = {'A', 'B'};


for j=1:nm
    
    figure(fig_ind)
    clear eval;
    clear deltaz;
    deltaz =    eval(['delta_',metrics{j}]);
    
    
    tight_subplot(1,9,1,[5*(j-1)+[1:3]], guttera, marginsa)
    b1(j)=bar([1:2:2*Nsbj], deltaz(:,1),'BarWidth',0.12); hold on;
    b2(j)=bar([2:2:2*Nsbj], deltaz(:,2),'BarWidth',0.12); hold on;
    set(b1(j),'FaceColor', 'k', 'EdgeColor', 'k'); hold on;
    set(b2(j),'FaceColor', [0.5 0.5 0.5], 'EdgeColor',[0.5 0.5 0.5]); hold on;
    xlim([0.5 2*Nsbj+0.5])
    ylim_min=1.1*min(min(deltaz));
    ylim_max=1.1*max(max(deltaz));
    %ylim([ylim_min ylim_max])
    ylim([ylim_min/2 ylim_max])
    
    text(-20, ylim_max*1.1, letters{j}, 'FontName', 'Helvetica', 'FOntSize', fontsz*1.2)
    
    box off
    ylabel(['\Delta',metrics{j}],'FontName', 'Helvetica', 'FontSize', fontsz)
    
    
    xlabel('Subject ID','FontName', 'Helvetica', 'FontSize', fontsz)
    set(gca, 'tickdir', 'out')
    set(gca, 'ticklength', 2*get(gca, 'ticklength'))
    set(gca, 'xtick',[0:10:2*Nsbj])
    set(gca, 'xticklabels',{'','','10','','20','','30','', '40'},'FontName', 'Helvetica', 'FontSize', fontsz)
    set(gca, 'ytick',[-1500:250:0])
    set(gca, 'yticklabels', {'-1500','','-1000', '', '-500', '', '0'},'FontName', 'Helvetica', 'FontSize', fontsz)
    
    
    tight_subplot(1,9,1,5*(j-1)+4, guttera, marginsa)
    
    c1(j)=bar(1, median(deltaz(:,1))); hold on;
    set(c1(j),'FaceColor', 'k', 'EdgeColor', 'k','BarWidth',0.4); hold on;
    c2(j)=bar(2, median(deltaz(:,2))); hold on;
    set(c2(j),'FaceColor', [0.5 0.5 0.5], 'EdgeColor', [0.5 0.5 0.5],'BarWidth',0.4); hold on;
    
    med=median(deltaz);
    lower=quantile(deltaz,0.25);
    upper=quantile(deltaz,0.75);
    
    e1(j)=errorbar(1, med(1),med(1)-lower(1) ,upper(1)-med(1) ); hold on;
    set(e1(j), 'Color', 'k','Linewidth',0.6)
    errorbarT(e1(j),eb_w,eb_t)
    e2(j)=errorbar(2, med(2),med(2)-lower(2) ,upper(2)-med(2) ); hold on;
    set(e2(j), 'Color', [0.5 0.5 0.5],'Linewidth',0.6)
    errorbarT(e2(j),eb_w,eb_t)
    
    xlim([0.5 2.5])
    ylim([ylim_min/2 ylim_max])
    box off
    set(gca, 'xticklabels',[])
    set(gca, 'tickdir', 'out')
    set(gca, 'ticklength', 2*get(gca, 'ticklength'))
    set(gca, 'xtick',[1 2])
    set(gca, 'xticklabels',[])
    set(gca, 'ytick',[-1500:250:0])
    set(gca, 'yticklabels', {'-1500','','-1000', '', '-500', '', '0'},'FontName', 'Helvetica', 'FontSize', fontsz)
    
    xlabel('Median ','FontName', 'Helvetica', 'FontSize', fontsz)
    if j==nm
        
        l = legend([e1(j) e2(j)],{'Gamma', 'log Normal'});
        set(l, 'FontName', 'Helvetica', 'FontSize', fontsz, 'Position', [0.6849    0.8950    0.3134    0.0813])
        legend boxoff
    end
    
    
    
end
%%
%psname1 = 'RT_model_comparisonnF.pdf';
%print_pdf(psname1)
end


