function plot_TIMO_Supp(fig_ind,rec_par,ind_ctrl, ind_adhd, resp_types_all, TIMO, TIMO_div)

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();


rec_sum = sum(~isnan(rec_par),2);
rec_sum_ind = find(rec_sum > 0);
ind_ctrl_rec = rec_sum_ind(rec_sum_ind<=20);
ind_adhd_rec = rec_sum_ind(rec_sum_ind>20);

TIMO_m_ctrl=median(irrel_buttons(ind_ctrl,:),1);
TIMO_m_adhd=median(TIMO(ind_adhd,:),1);

% further characterization of responses
% modified since we changed the order to Ori, OriS, Col, ColS
TIMO_divR = [squeeze(TIMO_div(:,1,1:2)) ...
    squeeze(TIMO_div(:,2,1:4)) ...
    squeeze(TIMO_div(:,3,1:2)) ...
    squeeze(TIMO_div(:,4,1:4))];


TIMO_m_div_ctrl=median(TIMO_divR(ind_ctrl,:),1);
TIMO_m_div_adhd=median(TIMO_divR(ind_adhd,:),1);

sample=[];
sample2=[];
for kk = 1:nboot
    for jj = 1:12
        
        sample=randsample(TIMO_divR(ind_ctrl,jj),length(ind_ctrl),1);
        IB_div_ctrl(kk,jj)=median(sample);
        
        sample2=randsample(TIMO_divR(ind_adhd,jj),length(ind_adhd),1);
        IB_div_adhd(kk,jj)=median(sample2);
        
    end
end

bci_ib_div_ctrl = [quantile(IB_div_ctrl,ci_bnd_low); quantile(IB_div_ctrl,ci_bnd_high)];
bci_ib_div_adhd = [quantile(IB_div_adhd,ci_bnd_low); quantile(IB_div_adhd,ci_bnd_high)];


% further characterization of responses plots

close;
figure(fig_ind)
%set(gcf, 'Position', [100 100 530 280])
set(gcf, 'Position', [100 100 500 240])
marginsa = [0.1200    0.1200    0.1000    0.1000];
guttera =[0.1 0.09];


msz = 3;


%prop_corr_lin = reshape(prop_corr, 4*40,1);
prop_corr_all(1:40,1:4) = squeeze(resp_types_all(1:40,:,1))./(squeeze(resp_types_all(1:40,:,1))+squeeze(resp_types_all(1:40,:,2)));
prop_corr_m_ctrl = median(prop_corr_all(ind_ctrl,:),1);
prop_corr_m_adhd = median(prop_corr_all(ind_adhd,:),1);



sample = [];
sample2 = [];
for kk = 1:nboot
    for jj=1:4
        sample=randsample(prop_corr_all(ind_ctrl,jj),length(ind_ctrl),1);
        PC_ctrl(kk,jj)=median(sample);
        
        sample2=randsample(prop_corr_all(ind_adhd,jj),length(ind_adhd),1);
        PC_adhd(kk,jj)=median(sample2);
    end
end

bci_pc_ctrl = [quantile(PC_ctrl,ci_bnd_low); quantile(PC_ctrl,ci_bnd_high)];
bci_pc_adhd = [quantile(PC_adhd,ci_bnd_low); quantile(PC_adhd,ci_bnd_high)];



tight_subplot(2,3,1,1, guttera, marginsa)
pc=plot(bar_ind_ctrl, prop_corr_all(1:20,:), '-o','MarkerSize', 1.7*msz,'MarkerFaceColor', bluee,'MarkerEdgeColor', bluee, 'Color', bluee); hold on;
pa=plot(bar_ind_adhd, prop_corr_all(21:40,:), '-o','MarkerSize', 1.7*msz,'MarkerFaceColor',redd,'MarkerEdgeColor',redd,  'Color', redd); hold on;
l = legend([pc(1) pa(1)], {'Control', 'ADHD'} )
legend boxoff
set(l, 'Location', 'SouthEast', 'FontName', 'Helvetica', 'FontSize', fontsz)
ylim([0 1])
set(gca, 'tickdir', 'out')
set(gca, 'ticklength', [0.04 0.04])
set(gca, 'XTick',[1.5 4.5 8.5  11.5]);
set(gca, 'ytick', [0:0.25:1])
set(gca, 'xticklabels',{'Ori', 'OriS', 'Col', 'ColS'},'FontName', 'Helvetica', 'FontSize', fontsz)
xlim([0 13])
box off
ylabel('Accuracy','FontName', 'Helvetica', 'FontSize', fontsz)


%

%CHANGE COLORS
color3=[37 52 148]/255;%[20 190 214]/255; %all blues
color4=[34 94 168]/255;%(color3 + [1 1 1])/2; %lighter blue
color5=[29 145 192]/255;%[144 171 255]/255;
color6=[65 182 196]/255;%(color5 + [1 1 1])/2;
color7=[127 205 187]/255;%[19 204 255]/255;
color8=[199 233 180]/255;%(color7 + [1 1 1])/2;

color33=[197 0 0]/255;%[255 194 182]/255; %all reds
color44=[215 48 31]/255;%(color33 + [1 1 1])/2;
color55=[239 101 72]/255;%[243 167 206]/255;
color66=[253 187 132]/255;%(color55 + [1 1 1])/2;
color77=[253 212 118]/255;%[232 113 83]/255;
color88=[253 212 158]/255;%(color77 + [1 1 1])/2;


% re arrange resp_types_all: put 5 and 6 instead of 3 and 4
resp_types_original = resp_types_all;
resp_types_all(:,:,[5 6]) = resp_types_original(:,:,[3 4]);
resp_types_all(:,:,[3 4]) = resp_types_original(:,:,[5 6]);

bar_valz_all_ctrl=[ TIMO_m_ctrl(1)*sum(squeeze(resp_types_all(ind_ctrl_rec,1,3:8)),1)/sum(sum(squeeze(resp_types_all(ind_ctrl_rec,1,3:8)),1)); ...
    ...
    TIMO_m_ctrl(2)*sum(squeeze(resp_types_all(ind_ctrl_rec,2,3:8)),1)/sum(sum(squeeze(resp_types_all(ind_ctrl_rec,2,3:8)),1)); ... %];
    
    TIMO_m_ctrl(3)*sum(squeeze(resp_types_all(ind_ctrl_rec,3,3:8)),1)/sum(sum(squeeze(resp_types_all(ind_ctrl_rec,3,3:8)),1));...
    
    TIMO_m_ctrl(4)*sum(squeeze(resp_types_all(ind_ctrl_rec,4,3:8)),1)/sum(sum(squeeze(resp_types_all(ind_ctrl_rec,4,3:8)),1));...
    ];


bar_valz_all_adhd=[ ...
    TIMO_m_adhd(1)*sum(squeeze(resp_types_all(ind_adhd_rec,1,3:8)),1)/sum(sum(squeeze(resp_types_all(ind_adhd_rec,1,3:8)),1));...
    
    TIMO_m_adhd(2)*sum(squeeze(resp_types_all(ind_adhd_rec,2,3:8)),1)/sum(sum(squeeze(resp_types_all(ind_adhd_rec,2,3:8)),1));...
    
    TIMO_m_adhd(3)*sum(squeeze(resp_types_all(ind_adhd_rec,3,3:8)),1)/sum(sum(squeeze(resp_types_all(ind_adhd_rec,3,3:8)),1));...
    
    TIMO_m_adhd(4)*sum(squeeze(resp_types_all(ind_adhd_rec,4,3:8)),1)/sum(sum(squeeze(resp_types_all(ind_adhd_rec,4,3:8)),1))];



tight_subplot(2,3,1,2, guttera, marginsa)
hc =  bar([bar_ind_ctrl],bar_valz_all_ctrl, 'stacked', 'Barwidth', 0.2); hold on;
set(hc(1), 'FaceColor', color3, 'EdgeColor', 'k')
set(hc(2), 'FaceColor', color4, 'EdgeColor', 'k')
set(hc(3), 'FaceColor', color5, 'EdgeColor', 'k')
set(hc(4), 'FaceColor', color6, 'EdgeColor', 'k')
set(hc(5), 'FaceColor', color7, 'EdgeColor', 'k')
set(hc(6), 'FaceColor', color8, 'EdgeColor', 'k')
set(gca, 'tickdir', 'out')


ha =  bar([bar_ind_adhd],bar_valz_all_adhd, 'stacked', 'Barwidth', 0.25); hold on;
set(ha(1), 'FaceColor', color33, 'EdgeColor', 'k')
set(ha(2), 'FaceColor', color44, 'EdgeColor', 'k')
set(ha(3), 'FaceColor', color55, 'EdgeColor', 'k')
set(ha(4), 'FaceColor', color66, 'EdgeColor', 'k')
set(ha(5), 'FaceColor', color77, 'EdgeColor', 'k')
set(ha(6), 'FaceColor', color88, 'EdgeColor', 'k')
set(gca, 'tickdir', 'out')

set(gca, 'XTick',[1.5 4.5 8.5  11.5]);
set(gca, 'xTickLabel',{'Ori', 'OriS','Col', 'ColS'}, 'Fontname', 'Helvetica', 'FontSize', fontsz);
set(gca, 'yTick',[0:0.025:0.1]);
set(gca, 'yticklabels',{'0','','0.05','','0.1'})
set(gca,'tickdir', 'out')
set(gca, 'ticklength', [0.04 0.04])
ylabel('Breakdown by error type', 'FontName', 'Helvetica', 'FontSize', fontsz)

box off
lc=legend([hc(1) hc(2) hc(3) hc(4) hc(5) hc(6)], { 'feat corr, space inc, cat corr', 'feat corr, space inc, cat inc',...
    'feat inc, space corr, cat corr', 'feat inc,space corr, cat inc',...
    'feat inc, space inc, cat corr', 'feat inc, space inc, cat inc'});
legend boxoff
set(lc, 'Position', [0.68 0.61 0.27 0.27], 'FontName', 'Helvetica', 'FontSize', fontsz)
%la=legend([ha(1) ha(2) ha(3) ha(4) ha(5) ha(6)], {'','','','','','' })
legend boxoff
%set(la, 'Position', [0.78 0.61 0.07 0.07], 'FontName', 'Helvetica', 'FontSize', fontsz)
xlim([0 13])


bar_ind_div_ctrl=[1 4    8 11 14 17      22 25  29 32 35 38  ];
bar_ind_div_adhd=[2 5    9 12 15 18      23 26  30 33 36 39  ];


tight_subplot(2,3,2,[1 2 3],guttera, marginsa)


for jj=1:12  
    ii=bar_ind_div_ctrl(jj);
    ij=1;
    h(ii)=bar(ii,TIMO_m_div_ctrl(jj)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii)=errorbar(ii,TIMO_m_div_ctrl(jj), TIMO_m_div_ctrl(jj)-bci_ib_div_ctrl(1,jj),bci_ib_div_ctrl(2,jj)-TIMO_m_div_ctrl(jj) ); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 1)
    errorbarT(he(ii),eb_w,eb_t)
    
end


for jj=1:12
    ii=bar_ind_div_adhd(jj);
    ij=2;
    h(ii)=bar(ii,TIMO_m_div_adhd(jj)); hold on;
    set(h(ii), 'FaceColor', colormat(ij,:), 'EdgeColor',colormat(ij,:))
    he(ii)=errorbar(ii,TIMO_m_div_adhd(jj), TIMO_m_div_adhd(jj)-bci_ib_div_adhd(1,jj),bci_ib_div_adhd(2,jj)-TIMO_m_div_adhd(jj) ); hold on;
    set(he(ii), 'Color', 'k', 'Linewidth', 1)
    errorbarT(he(ii),eb_w,eb_t)
    
end

box off
xlim([0 40.5])

set(gca, 'XTick',[3  13 24 34]);
set(gca, 'xTickLabel',{'Ori', 'OriS', 'Col', 'ColS' }, 'Fontname', 'Helvetica', 'FontSize', fontsz);
set(gca, 'ytick',[0:0.01:0.06])
set(gca, 'yticklabels',{'0','','0.02','','0.04','','0.06'},'FontName', 'Helvetica', 'FontSize', fontsz)
set(gca,'tickdir', 'out')
set(gca, 'ticklength', [0.02 0.02])
ylabel('Proportion of TIMO','FontName', 'Helvetica', 'FontSize', fontsz)
l=legend([h(1) h(23)], { strcat('Control '),strcat('ADHD ')});
set(l, 'Position', [0.8687    0.4504    0.0667    0.0404],'Fontname', 'Helvetica', 'FontSize', fontsz)
legend boxoff


prop_corr_spatial_errors([ind_ctrl_rec; ind_adhd_rec],1:4) = sum(squeeze(resp_types_all([ind_ctrl_rec; ind_adhd_rec],:,[3 4 7 8])),3)./sum(squeeze(resp_types_all([ind_ctrl_rec; ind_adhd_rec],:,:)),3);
prop_corr_spatial_errorsL = reshape(prop_corr_spatial_errors, size(prop_corr_spatial_errors,1)* size(prop_corr_spatial_errors,2),1); 




%% ratios for reviewers
% pick ind_ctrl_rec vs ind_ctrl &
% ind_adhd_rec vs ind_adhd
for ci = 1:4
    ratio_space_ctrl(ci) = sum(squeeze(resp_types_all(ind_ctrl_rec,ci,3)))...
        /(sum(squeeze(resp_types_all(ind_ctrl_rec,ci,3)))+ sum(squeeze(resp_types_all(ind_ctrl_rec,ci,4))));
    
    ratio_space_adhd(ci) = sum(squeeze(resp_types_all(ind_adhd_rec,ci,3)))...
        /(sum(squeeze(resp_types_all(ind_adhd_rec,ci,3)))+ sum(squeeze(resp_types_all(ind_adhd_rec,ci,4))));
    
     
    ratio_feat_ctrl(ci) = sum(squeeze(resp_types_all(ind_ctrl_rec,ci,5)))...
        /(sum(squeeze(resp_types_all(ind_ctrl_rec,ci,5)))+ sum(squeeze(resp_types_all(ind_ctrl_rec,ci,6))));
    
    ratio_feat_adhd(ci) = sum(squeeze(resp_types_all(ind_adhd_rec,ci,5)))...
        /(sum(squeeze(resp_types_all(ind_adhd_rec,ci,5)))+ sum(squeeze(resp_types_all(ind_adhd_rec,ci,6))));
end

%mean(ratio_space_ctrl)
%mean(ratio_space_adhd)
(mean(ratio_space_ctrl)+mean(ratio_space_adhd))/2;

%mean(ratio_feat_ctrl([2 4])) % only makes sense to look at switch blocks, otherwise few feature errors
%mean(ratio_feat_adhd([2 4])) % only makes sense to look at switch blocks, otherwise few feature errors
(mean(ratio_feat_ctrl([2 4])) + mean(ratio_feat_adhd([2 4])))/2;




end
