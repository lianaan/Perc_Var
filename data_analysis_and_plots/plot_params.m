function plot_params(fig_ind,ind_ctrl, ind_adhd,param,all_stims)

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();

median_param_ctrl = squeeze(median(param(ind_ctrl,:,:),1));
median_param_adhd = squeeze(median(param(ind_adhd,:,:),1));

%nboot=50000;
for kk = 1:nboot
    for jj = 1:4
        for pi = 1:3 %3 params
            sample = randsample(squeeze(param(ind_ctrl,jj,pi)),length(ind_ctrl),1);
            par_ctrl(kk,jj,pi) = median(sample);
            
            sample2 = randsample(squeeze(param(ind_adhd,jj,pi)),length(ind_adhd),1);
            par_adhd(kk,jj,pi) = median(sample2);
        end
    end
end

bci_par_ctrl = [squeeze(quantile(par_ctrl,ci_bnd_low)); squeeze(quantile(par_ctrl,ci_bnd_high))];
bci_par_adhd = [squeeze(quantile(par_adhd,ci_bnd_low)); squeeze(quantile(par_adhd,ci_bnd_high))];



figure(fig_ind)
set(gcf, 'Position', [100 100 540 240])

marginsa = [0.1 0.12 0.12 0.12];
guttera = [0.07 0.12];
guttera0 = guttera;
marginsa0 = marginsa;

fontsz = 12;
markersz = 3;


nbinz2 = 15;
binz2_ = [];
for jj = 1:nbinz2
    binz2_(jj) = quantile(all_stims, jj/nbinz2);
end
binz2_=[min(all_stims) binz2_ ];


xlim_min = min([ binz2_ -0.5]);
xlim_max = max([ binz2_ 0.5]);


binz2_pos = (binz2_(2:end)+binz2_(1:end-1))/2;

mylw=1.066;


ns = 2;

tight_subplot(ns,4,1,1, guttera0, marginsa0)

cond = 1;
for  par = 1:20
    
    plot(binz2_pos,function_psi(binz2_pos,param(par,cond,1),param(par,cond,2), param(par,cond,3)),'Color',bluee_shade); hold on;
    plot(binz2_pos,function_psi(binz2_pos,param(20+par,cond,1),param(20+par,cond,2), param(20+par,cond,3)),'Color',redd_shade); hold on;
end
plot(binz2_pos,median(function_psi(binz2_pos,param([1:20],cond,1),param([1:20],cond,2), param([1:20],cond,3))),'Color',bluee,'Linewidth',mylw*1.5); hold on;
plot(binz2_pos,median(function_psi(binz2_pos,param([21:40],cond,1),param([21:40],cond,2), param([21:40],cond,3))),'Color',redd,'Linewidth',mylw*1.5); hold on;
box off

xlim([xlim_min xlim_max])
set(gca, 'xtick',[-0.5:0.25:0.5])
set(gca, 'ytick',[0:0.25:1])
set(gca, 'xticklabels',{'-0.5','','0','','0.5'},'FontName', 'Helvetica', 'FontSize', 0.8*fontsz)
set(gca, 'yticklabels',{'0','','0.5','','1'},'FontName', 'Helvetica', 'FontSize', 0.8*fontsz)
set(gca, 'Tickdir', 'out')
set(gca, 'ticklength', [0.0400    0.0400])
title('Ori','FontName', 'Helvetica', 'FontSize', fontsz)

tight_subplot(ns,4,1,2, guttera0, marginsa0)

cond = 2;
for  par = 1:20
    
    plot(binz2_pos,function_psi(binz2_pos,param(par,cond,1),param(par,cond,2), param(par,cond,3)),'Color',bluee_shade); hold on;
    plot(binz2_pos,function_psi(binz2_pos,param(20+par,cond,1),param(20+par,cond,2), param(20+par,cond,3)),'Color',redd_shade); hold on;
end
plot(binz2_pos,median(function_psi(binz2_pos,param([1:20],cond,1),param([1:20],cond,2), param([1:20],cond,3))),'Color',bluee,'Linewidth',mylw*1.5); hold on;
plot(binz2_pos,median(function_psi(binz2_pos,param([21:40],cond,1),param([21:40],cond,2), param([21:40],cond,3))),'Color',redd,'Linewidth',mylw*1.5); hold on;
box off
xlim([-0.5 0.5])
set(gca, 'xtick',[-0.5:0.25:0.5])
set(gca, 'ytick',[0:0.25:1])
set(gca, 'xticklabels',{'-0.5','','0','','0.5'},'FontName', 'Helvetica', 'FontSize', 0.8*fontsz)
set(gca, 'yticklabels',{'0','','0.5','','1'},'FontName', 'Helvetica', 'FontSize', 0.8*fontsz)
set(gca, 'Tickdir', 'out')
set(gca, 'ticklength', [0.04 0.04])
title('OriS','FontName', 'Helvetica', 'FontSize', fontsz)


tight_subplot(ns,4,1,3, guttera0, marginsa0)

cond = 3;

for  par = 1:20
    
    plot(binz2_pos,function_psi(binz2_pos,param(par,cond,1),param(par,cond,2), param(par,cond,3)),'Color',bluee_shade); hold on;
    plot(binz2_pos,function_psi(binz2_pos,param(20+par,cond,1),param(20+par,cond,2), param(20+par,cond,3)),'Color',redd_shade); hold on;
end

plot(binz2_pos,median(function_psi(binz2_pos,param([1:20],cond,1),param([1:20],cond,2), param([1:20],cond,3))),'Color',bluee,'Linewidth',mylw*1.5); hold on;
plot(binz2_pos,median(function_psi(binz2_pos,param([21:40],cond,1),param([21:40],cond,2), param([21:40],cond,3))),'Color',redd,'Linewidth',mylw*1.5); hold on;
box off
xlim([-0.5 0.5])
set(gca, 'xtick',[-0.5:0.25:0.5])
set(gca, 'ytick',[0:0.25:1])
set(gca, 'xticklabels',{'-0.5','','0','','0.5'},'FontName', 'Helvetica', 'FontSize', 0.8*fontsz)
set(gca, 'yticklabels',{'0','','0.5','','1'},'FontName', 'Helvetica', 'FontSize', 0.8*fontsz)
set(gca, 'Tickdir', 'out')
set(gca, 'ticklength', [0.04 0.04])
title('Col','FontName', 'Helvetica', 'FontSize', fontsz)

tight_subplot(ns,4,1,4, guttera0, marginsa0)

cond = 4;
for  par = 1:20
    
    plot(binz2_pos,function_psi(binz2_pos,param(par,cond,1),param(par,cond,2), param(par,cond,3)),'Color',bluee_shade); hold on;
    plot(binz2_pos,function_psi(binz2_pos,param(20+par,cond,1),param(20+par,cond,2), param(20+par,cond,3)),'Color',redd_shade); hold on;
end
plot(binz2_pos,median(function_psi(binz2_pos,param([1:20],cond,1),param([1:20],cond,2), param([1:20],cond,3))),'Color',bluee,'Linewidth',mylw*1.5); hold on;
plot(binz2_pos,median(function_psi(binz2_pos,param([21:40],cond,1),param([21:40],cond,2), param([21:40],cond,3))),'Color',redd,'Linewidth',mylw*1.5); hold on;
box off
xlim([-0.5 0.5])
set(gca, 'xtick',[-0.5:0.25:0.5])
set(gca, 'ytick',[0:0.25:1])
set(gca, 'xticklabels',{'-0.5','','0','','0.5'},'FontName', 'Helvetica', 'FontSize', 0.8*fontsz)
set(gca, 'yticklabels',{'0','','0.5','','1'},'FontName', 'Helvetica', 'FontSize', 0.8*fontsz)
set(gca, 'Tickdir', 'out')
set(gca, 'ticklength', [0.04 0.04])

title('ColS','FontName', 'Helvetica', 'FontSize', fontsz)


jj_all =[ 1 3];

tight_subplot(ns,4,2,4, guttera, marginsa)
for jji = 1:2
    jj = jj_all(jji);
    
    ij = 2*(jji-1)+1;
    ii = ij;
    h(ii) = bar(ii,median_param_ctrl(jj,3)); hold on;
    set(h(ii), 'FaceColor', colormat(2*jj-1,:), 'EdgeColor',colormat(2*jj-1,:))
    he(ii) = errorbar(ii,median_param_ctrl(jj,3), median_param_ctrl(jj,3)-bci_par_ctrl(jj,3),bci_par_ctrl(4+jj,3)-median_param_ctrl(jj,3)); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 2)
    errorbarT(he(ii),eb_w,eb_t)
end


for jji = 1:2
    jj = jj_all(jji);
    
    ij = 2*jji;
    ii = ij;
    h(ii)=bar(ii,median_param_adhd(jj,3)); hold on;
    set(h(ii), 'FaceColor', colormat(2*jj,:), 'EdgeColor',colormat(2*jj,:))
    he(ii)=errorbar(ii,median_param_adhd(jj,3), median_param_adhd(jj,3)-bci_par_adhd(jj,3), bci_par_adhd(4+jj,3)-median_param_adhd(jj,3)); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 2)
    errorbarT(he(ii),eb_w,eb_t)
end
set(gca, 'XTick',[1.5 3.5]);
set(gca, 'xTickLabel',{'Ori','Col'}, 'Fontname', 'Helvetica', 'FontSize', fontsz);

box off
set(gca, 'Tickdir', 'out')
set(gca, 'ticklength', [0.04 0.04])
set(gca, 'ytick',[0:0.1:0.4])
set(gca, 'yticklabels',{'0','','0.2','','0.4'},'Fontname', 'Helvetica', 'FontSize', 0.8*fontsz)
xlim([0 4.5])
ylim([0 0.45])
ylabel('Lapse','Fontname', 'Helvetica', 'FontSize', fontsz)




axes('Position',[0.81 0.36 0.06 0.07])
plot(binz2_pos,function_psi(binz2_pos,0,0.03, 0.01), 'Color','k'); hold on;
p1=plot(binz2_pos,function_psi(binz2_pos,0,0.03, 0.35), 'Color', [0.5 0.5 0.5]); hold on;
xlim([-0.24 0.24])
set(gca, 'xtick',[])
set(gca, 'ytick',[])
box off


tight_subplot(ns,4,2,[2 3], guttera, marginsa)

for jj=1:4
    
    ii=bar_ind_ctrl(jj);
    ij=2*(jj-1)+1;
    h(ii)=bar(ii,median_param_ctrl(jj,2)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii)=errorbar(ii,median_param_ctrl(jj,2), median_param_ctrl(jj,2)-bci_par_ctrl(jj,2), bci_par_ctrl(4+jj,2)-median_param_ctrl(jj,2)); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 2)
    errorbarT(he(ii),eb_w,eb_t)
end


for jj=1:4
    ii=bar_ind_adhd(jj);
    ij=2*jj;
    h(ii)=bar(ii,median_param_adhd(jj,2)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii)=errorbar(ii,median_param_adhd(jj,2), median_param_adhd(jj,2)- bci_par_adhd(jj,2), bci_par_adhd(4+jj,2)-median_param_adhd(jj,2)); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 2)
    errorbarT(he(ii),eb_w,eb_t)
end

box off
set(gca, 'Tickdir', 'out')
set(gca, 'XTick',[1.5 4.5 8.5 11.5]);
set(gca, 'xTickLabel',{'Ori', 'OriS', 'Col', 'ColS'}, 'Fontname', 'Helvetica', 'FontSize', fontsz);

xlim([0 13])
set(gca, 'ytick',[0:0.025:0.125])
set(gca, 'yticklabels',{'0','','0.05','','0.1',''},'Fontname', 'Helvetica', 'FontSize', 0.8*fontsz)
ylim([0 0.16])
set(gca, 'Ticklength', [0.0400    0.0400])
l=legend([ h(bar_ind_ctrl(1)) h(bar_ind_adhd(1))], { strcat('Control'), strcat('ADHD')})
set(l, 'Position', [0.1187    0.3604    0.0367    0.0404])
legend boxoff

box off

ylabel('Noise','Fontname', 'Helvetica', 'FontSize', fontsz)


axes('Position',[0.60 0.36 0.06 0.07])
plot(binz2_pos,function_psi(binz2_pos,0,0.03, 0.01), 'Color','k'); hold on;
p1=plot(binz2_pos,function_psi(binz2_pos,0,0.1, 0.01), 'Color', [0.5 0.5 0.5]); hold on;
xlim([-0.24 0.24])
set(gca, 'xtick',[])
set(gca, 'ytick',[])
box off


psname_par=['paramsF.pdf'];
%print_pdf(psname_par)

end