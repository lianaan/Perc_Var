function plot_TIMO_RT(fig_ind, ind_ctrl, ind_adhd, TIMO, rt_med_iqr, rt_tau, rt_distrib)


marginsa1=[0.1 0.12 0.26 0.13]; %left right bottom top
guttera1=[0.07 0.14]; % btwn cols, btwtn rows
n_sub = 4;

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();
% plotting parameters


figure(fig_ind)
set(gcf, 'Position', [100 100 500 130])


for par = 1: size(rt_distrib,1)
    [f,x] = ecdf(rt_distrib(par,:));
    %f_par(par,1:min(length(f)) = f;
    %x_par(par,1:length(f)) = x;
        if par <= 20
            figure(fig_ind)
            tight_subplot(1,4,1,2,guttera1, marginsa1)
            plot(x, f, 'Color',bluee_shade); hold on;
            %plot(x_par(par,:), f_par(par,:), 'Color',bluee_shade); hold on;
            
        else
            figure(fig_ind)
            tight_subplot(1,4,1,2,guttera1, marginsa1)
            plot(x, f, 'Color',redd_shade); hold on;
            %plot(x_par(par,:), f_par(par,:), 'Color',redd_shade); hold on;
            
        end


end

TIMO_m_ctrl=median(TIMO(ind_ctrl,:),1);
TIMO_m_adhd=median(TIMO(ind_adhd,:),1);

sample=[];
sample2=[];
for kk=1:nboot
    for jj=1:4
        sample=randsample(TIMO(ind_ctrl,jj),length(ind_ctrl),1);
        IB_ctrl(kk,jj)=median(sample);
        
        sample2=randsample(TIMO(ind_adhd,jj),length(ind_adhd),1);
        IB_adhd(kk,jj)=median(sample2);
    end
end

bci_ib_ctrl = [quantile(IB_ctrl,ci_bnd_low); quantile(IB_ctrl,ci_bnd_high)];
bci_ib_adhd = [quantile(IB_adhd,ci_bnd_low); quantile(IB_adhd,ci_bnd_high)];

%
figure(fig_ind)

tight_subplot(1,4,1,1,guttera1, marginsa1)


for jj=1:4
    
    ii=bar_ind_ctrl(jj);
    ij=2*(jj-1)+1; %colormat ind
    h(ii)=bar(ii,TIMO_m_ctrl(jj)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii)=errorbar(ii,TIMO_m_ctrl(jj), TIMO_m_ctrl(jj)-bci_ib_ctrl(1,jj),bci_ib_ctrl(2,jj)-TIMO_m_ctrl(jj) ); hold on;
    %set(he(ii), 'Color', colormat(ij,:), 'Linewidth', 1)
    set(he(ii), 'Color', 'k', 'Linewidth', 1)
    errorbarT(he(ii),eb_w,eb_t)
    
end


for jj=1:4
    ii=bar_ind_adhd(jj);
    ij=2*jj; %colormat ind
    h(ii)=bar(ii,TIMO_m_adhd(jj)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii)=errorbar(ii,TIMO_m_adhd(jj), TIMO_m_adhd(jj)-bci_ib_adhd(1,jj),bci_ib_adhd(2,jj)-TIMO_m_adhd(jj) ); hold on;
    %set(he(ii), 'Color', colormat(ij,:), 'Linewidth', 1)
    set(he(ii), 'Color', 'k', 'Linewidth', 1)
    errorbarT(he(ii),eb_w,eb_t)
    
end

box off
xlim([0 12.5])
ylim([0 0.14])
set(gca, 'XTick',[1.5 4.5 8.5 11.5]);
set(gca, 'xTickLabel',{'Ori', 'OriS','Col', 'ColS'}, 'Fontname', 'Helvetica', 'FontSize', 0.5*fontsz);
set(gca, 'ytick',[0:0.03:0.12])
set(gca, 'yticklabels',{'0','','0.06','','0.12'},'FontName', 'Helvetica', 'FontSize', 0.9*fontsz)
set(gca,'tickdir', 'out')
set(gca, 'ticklength', [0.04 0.04])


% rt

median_rt_ctrl = median(rt_med_iqr(ind_ctrl,:,2));
median_rt_adhd = median(rt_med_iqr(ind_adhd,:,2));


sample=[];
sample2=[];
for kk=1:nboot
    for jj=1:4
        sample=randsample(rt_med_iqr(ind_ctrl,jj,2),length(ind_ctrl),1);
        RT_ctrl(kk,jj)=median(sample);
        
        sample2=randsample(rt_med_iqr(ind_adhd,jj,2),length(ind_adhd),1);
        RT_adhd(kk,jj)=median(sample2);
    end
end


bci_rt_ctrl = [quantile(RT_ctrl,ci_bnd_low); quantile(RT_ctrl,ci_bnd_high)];
bci_rt_adhd = [quantile(RT_adhd,ci_bnd_low); quantile(RT_adhd,ci_bnd_high)];

% RT tau
%rt_tau = exp(squeeze(RT_pars_fit(:,1,1:4,3)));

median_rt_tau_ctrl = median(rt_tau(ind_ctrl,:));
median_rt_tau_adhd = median(rt_tau(ind_adhd,:));
sample = [];
sample2 = [];
for kk = 1:nboot
    for jj = 1:4
        sample = randsample(rt_tau(ind_ctrl,jj),length(ind_ctrl),1);
        RT_tau_ctrl(kk,jj) = median(sample);
        
        sample2 = randsample(rt_tau(ind_adhd,jj),length(ind_adhd),1);
        RT_tau_adhd(kk,jj) = median(sample2);
    end
end

bci_rt_tau_ctrl = [quantile(RT_tau_ctrl,ci_bnd_low); quantile(RT_tau_ctrl,ci_bnd_high)];
bci_rt_tau_adhd = [quantile(RT_tau_adhd,ci_bnd_low); quantile(RT_tau_adhd,ci_bnd_high)];



rt_distrib_ctrl = reshape(rt_distrib(ind_ctrl,:), 20*800,1);
rt_distrib_adhd = reshape(rt_distrib(ind_adhd,:), 20*800,1);
[f_c,x_c] = ecdf(rt_distrib_ctrl);
[f_a,x_a] = ecdf(rt_distrib_adhd);

[p_rt_all,h_rt_all] = ranksum(median([rt_distrib(ind_ctrl,:)]'),median([rt_distrib(ind_adhd,:)]'));



figure(fig_ind)
tight_subplot(1,n_sub,1,2,guttera1, marginsa1)

h1 = plot(x_c,f_c,'Color',bluee, 'LineWidth',2); hold on;
h2 = plot(x_a,f_a,'Color',redd, 'LineWidth',2); hold on;
box off;
xlim([0 4])
ylim([0 1])
set(gca,'tickdir', 'out')
set(gca, 'ytick',[0:0.25:1])
set(gca, 'yticklabels',{'0','','0.5','','1'},'FontName', 'Helvetica', 'FontSize', 0.9*fontsz)
set(gca, 'xtick',[0:0.5:4])
set(gca, 'xticklabels',{'0','','','','2','','','','4'},'FontName', 'Helvetica', 'FontSize', 0.9*fontsz)
set(gca, 'ticklength', [0.04 0.04])

tight_subplot(1,n_sub,1,3,guttera1, marginsa1)
for jj = 1:4
    
    
    ii = bar_ind_ctrl(jj);
    ij = 2*(jj-1)+1;
    h(ii) = bar(ii,median_rt_ctrl(jj)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii) = errorbar(ii,median_rt_ctrl(jj),median_rt_ctrl(jj)-bci_rt_ctrl(1,jj),bci_rt_ctrl(2,jj)-median_rt_ctrl(jj)); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 1)
    errorbarT(he(ii),eb_w,eb_t)
    
end


for jj = 1:4
    ii = bar_ind_adhd(jj);
    ij = 2*jj;
    h(ii) = bar(ii,median_rt_adhd(jj)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii) = errorbar(ii,median_rt_adhd(jj),median_rt_adhd(jj)-bci_rt_adhd(1,jj),bci_rt_adhd(2,jj)-median_rt_adhd(jj)); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 1)
    errorbarT(he(ii),eb_w,eb_t)
    
end


set(gca, 'XTick',[1.5 4.5 8.5 11.5]);
set(gca, 'xTickLabel',{'O', 'OS','C', 'CS','O', 'OS','C', 'CS'}, 'Fontname', 'Helvetica', 'FontSize', 0.5*fontsz);
box off
set(gca, 'ytick',[0:0.3:1.2])
set(gca, 'yticklabels',{'0','','0.6','','1.2'},'FontName', 'Helvetica', 'FontSize', 0.9*fontsz)
set(gca, 'Tickdir', 'out')
set(gca, 'ticklength', [0.04 0.04])
ylim([0 1.2])
xlim([0 13])


tight_subplot(1,n_sub,1,4,guttera1, marginsa1)
for jj = 1:4
    
    ii = bar_ind_ctrl(jj);
    ij = 2*(jj-1)+1;
    h(ii) = bar(ii,median_rt_tau_ctrl(jj)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii) = errorbar(ii,median_rt_tau_ctrl(jj),median_rt_tau_ctrl(jj)-bci_rt_tau_ctrl(1,jj),bci_rt_tau_ctrl(2,jj)-median_rt_tau_ctrl(jj)); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 1)
    errorbarT(he(ii),eb_w,eb_t)
    
end


for jj = 1:4
    ii = bar_ind_adhd(jj);
    ij = 2*jj;
    h(ii) = bar(ii,median_rt_tau_adhd(jj)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii) = errorbar(ii,median_rt_tau_adhd(jj),median_rt_tau_adhd(jj)-bci_rt_tau_adhd(1,jj),bci_rt_tau_adhd(2,jj)-median_rt_tau_adhd(jj)); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 1)
    errorbarT(he(ii),eb_w,eb_t)
    
end

set(gca, 'XTick',[1.5 4.5 8.5 11.5]);
set(gca, 'xTickLabel',{'Ori', 'OriS', 'Col', 'ColS'}, 'Fontname', 'Helvetica', 'FontSize', 0.5*fontsz);
box off
set(gca, 'ytick',[0:0.2:1])
set(gca, 'yticklabels',{'0','','0.4','','0.8',''},'FontName', 'Helvetica', 'FontSize', 0.9*fontsz)
set(gca, 'Tickdir', 'out')
set(gca, 'ticklength', [0.04 0.04])
ylim([0 1.2])
xlim([0 13])



    

end
