function plot_psych_curves_model_comp(fig_ind,curr_dir,params,stims_cond_all, resp_cond_all, cond_list)

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();


%M1: full model, 12 param
%M2: shared model, 8 param
n_models = 2;
n_params=[12 8];

Nsubj = size(stims_cond_all,1);
Loglik = nan(Nsubj,n_models,length(cond_list));

cd ..
cd([curr_dir, '/model_fitting/'])


for par = 1:Nsubj
    for cond=1:4
        for mi = 1: n_models   
            Loglik(par,mi,cond) = loglike(squeeze(stims_cond_all(par,cond,:)),squeeze(resp_cond_all(par,cond,:)), params(par,mi,1,cond), params(par,mi,2,cond), params(par,mi,3,cond));
        end
    end
end
cd ..
cd([curr_dir, '/data_analysis_and_plots/'])


%%

LoglikS=sum(Loglik(:, :,:),3); %sum across the cond dimension

n_trials=800;

for mi = 1:2
    AICc(:,mi) = bsxfun(@plus, -2*LoglikS(:,mi),2*n_params(mi)+(2*n_params(mi).*(n_params(mi)+1))./(n_trials-n_params(mi)-1));
    BIC(:,mi) = bsxfun(@plus, -2*LoglikS(:,mi),log(n_trials)*n_params(mi));
end

delta_LL = bsxfun(@minus,LoglikS(:,2:end),LoglikS(:,1));
delta_AICc = bsxfun(@minus,AICc(:,2:end),AICc(:,1));
delta_BIC = bsxfun(@minus,BIC(:,2:end),BIC(:,1));


figure(fig_ind)
set(gcf, 'Position', [100 100 500 160])


marginsa = [0.14 0.12 0.24 0.1]; %[LEFT RIGHT BOTTOM TOP]
guttera=[0.06 0.06];
fontsz=10;

metrics={'AICc','BIC'}
letters = {'A', 'B'}


for j=1:length(metrics)
    
    tight_subplot(1,9,1,[5*(j-1)+[1:3]], guttera, marginsa)
    clear eval;
    b(j)=bar([1:1:Nsubj], eval(['delta_',metrics{j},'(:,1)'])); hold on;
    set(b(j),'FaceColor', 'k', 'EdgeColor', 'k', 'BarWidth', 0.4); hold on;
    xlim([0.5 Nsubj+0.5])
    ylim_min=1.3*min(min(eval(['delta_',metrics{j}])));
    ylim_max=0.3*max(max(eval(['delta_',metrics{j}])));
    %ylim([ylim_min ylim_max])
    ylim([-30 10])
    set(gca, 'ytick', [-30:5:10])
    set(gca, 'yticklabels',{'-30','','-20','','-10','','0','', '10'},'FontName', 'Helvetica', 'FOntSize', fontsz)
    box off
    ylabel(['\Delta',metrics{j}],'FontName', 'Helvetica', 'FontSize', fontsz)
    
    
    
    text(-20, ylim_max*1.1, letters{j}, 'FontName', 'Helvetica', 'FOntSize', fontsz*1.2)

    
    xlabel('Subject ID','FontName', 'Helvetica', 'FontSize', fontsz)
    set(gca, 'tickdir', 'out')
    %set(gca, 'ticklength', 2*get(gca, 'ticklength'))
    set(gca, 'xtick',0:5:40)
    set(gca, 'xticklabels',{'','','10','','20','','30','', '40'},'FontName', 'Helvetica', 'FOntSize', fontsz)
    xlim([0.5 Nsubj+0.5])
    set(gca, 'ticklength', [0.03 0.03])
    
    
    tight_subplot(1,9,1,[5*(j-1)+4], guttera, marginsa)
    clear eval;
    b(j)=bar(1, median(eval(['delta_',metrics{j},'(:,1)']))); hold on;
    set(b(j),'FaceColor', 'k', 'EdgeColor', 'k', 'BarWidth', 0.4); hold on;
    clear eval;
    med=median(eval(['delta_',metrics{j}]));
    lower=quantile(eval(['delta_',metrics{j}]),0.25);
    upper=quantile(eval(['delta_',metrics{j}]),0.75);
    e(j)=errorbar(1, med,med-lower ,upper-med); hold on;
    set(e(j), 'Color', 'k','Linewidth',2)
    errorbarT(e(j),eb_w,eb_t)
    %ylim([ylim_min ylim_max])
    ylim([-30 10])
    set(gca, 'ytick', [-30:5:10])
    set(gca, 'yticklabels',{'-30','','-20','','-10','','0','', '10'},'FontName', 'Helvetica', 'FOntSize', fontsz)
    
    box off
    set(gca, 'xtick',[1 2])
    set(gca, 'xticklabels',[])
    set(gca, 'tickdir', 'out')
   
    xlabel('Median ','FontName', 'Helvetica', 'FontSize', fontsz)
    set(gca, 'tickdir', 'out')
    %set(gca, 'ticklength', 2*get(gca, 'ticklength'))
    set(gca, 'ticklength', [0.03 0.03])
    
    
end

cd ..
cd([curr_dir, '/data_analysis_and_plots/'])


%%
%psname='psych_curves_model_compF.pdf'
%print_pdf(psname)
end
