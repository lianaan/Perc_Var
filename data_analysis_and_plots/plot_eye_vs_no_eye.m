function plot_eye_vs_no_eye(fig_ind, eye_tr, data_all)

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();

% Caveat supp plot - eye tracking lack of influence on behavioral measures

inde1 = find(eye_tr == 1);
inde0 = find(eye_tr == 0);


for kk=1:nboot
    for jj=1:5
        
        sample1 = randsample(log(data_all(inde1,jj)),length(inde1),1);
        metr_1(kk,jj) = median(sample1);
        
        sample0 = randsample(log(data_all(inde0,jj)),length(inde0),1);
        metr_0(kk,jj) = median(sample0);
        
        
    end
end

for jj = 1:5
    
    bci_metr_med_1(jj,:) = [quantile(metr_1(:,jj), ci_bnd_low); quantile(metr_1(:,jj), ci_bnd_high)];
    bci_metr_med_0(jj,:) = [quantile(metr_0(:,jj), ci_bnd_low); quantile(metr_0(:,jj), ci_bnd_high)];
    
    
end

%}

dist = 0.1;
dsz = 2;

figure(fig_ind)
set(gcf, 'Position', [100 100 440 100])

marginsa=[0.08 0.16 0.22 0.28]; %[LEFT RIGHT BOTTOM TOP]
guttera=[0.11 0.1];

ylimsen1 = [-4 0];
ylimsen2 = [-3 1];

colore = [224 102 105]/255;

for i = 1:5
    tight_subplot(1,5,1,i,guttera,marginsa)
    
    he(i) = bar(1, median(log(data_all(inde1,i)))); hold on;
    set(he(i),'BarWidth',0.6, 'FaceColor', colore, 'EdgeColor',colore)
    he(i) = errorbar(1,median(log(data_all(inde1,i))), median(log(data_all(inde1,i)))-bci_metr_med_1(jj,1),bci_metr_med_1(jj,2)-median(log(data_all(inde1,i)))); hold on;
    set(he(i), 'Color', 'k', 'Linewidth', 2)
    errorbarT(he(i),eb_w,eb_t)
    
    %heye_not(i)=plot(linspace(2-dist,2+dist,Nsbj/2)', log(data_all(eye_tr==0,i)),'o', 'MarkerFaceColor',col_nsig, 'MarkerEdgeColor', col_nsig, 'MarkerSize', dsz ); hold on;
    hn(i) = bar(2, median(log(data_all(inde0,i)))); hold on;
    set(hn(i),'BarWidth',0.6, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor',[0.5 0.5 0.5])
    hn(i) = errorbar(2,median(log(data_all(inde0,i))), median(log(data_all(inde0,i)))-bci_metr_med_0(jj,1),bci_metr_med_0(jj,2)-median(log(data_all(inde0,i)))); hold on;
    set(hn(i), 'Color', 'k', 'Linewidth', 2)
    errorbarT(hn(i),eb_w,eb_t)
    
    [p_eye(i), h_eye(i)] = ranksum(log(data_all(eye_tr==1,i)),log(data_all(eye_tr==0,i)))
    if ismember(i, [2 3])
        set(gca, 'ytick', ylimsen2(1):1:ylimsen2(2))
        set (gca, 'yticklabels', {'-3', '', '-1','', '1'}, 'FontName', 'Helvetica','FontSize',fontsz)
        ylim([ylimsen2(1)*1.3 ylimsen2(2)])
    else
        set(gca, 'ytick', ylimsen1(1):1:ylimsen1(2))
        set (gca, 'yticklabels', {'-4','', '-2','', '0'}, 'FontName', 'Helvetica','FontSize',fontsz)
        ylim([ylimsen1(1) ylimsen1(2)*0.8])
    end
    xlim([0.4 2.6])
    box off
    %ylabel(measures{i},'FontName','Helvetica','FontSize',fontsz)
    set(gca, 'xtick', [1 2])
    set(gca, 'xticklabels', {'E', 'NE'}, 'FontName','Helvetica','FontSize',fontsz)
    
    set(gca, 'Tickdir', 'out')
    set(gca, 'ticklength', [0.04 0.04])
end
leg_eye = legend([he(i) hn(i)],{'Eye tracked', 'Not eye tracked'})
set(leg_eye, 'FontName','Helvetica','FontSize',fontsz*0.8, 'Position', [0.8 0.40 0.2 0.2])
legend boxoff

psname = 'metrics_eye_track_vs_notENEF.pdf';
%print_pdf(psname)

end