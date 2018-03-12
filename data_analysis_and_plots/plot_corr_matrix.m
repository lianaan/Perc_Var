function plot_corr_matrix(fig_ind,data_all, measures)
   


[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();

col_sig=[0 0 0];
col_nsig=[0.5 0.5 0.5];
dsz = 2;%7;
dsz2 = 4;
fontsz = 9;


nm = 7;
corr_mat = nan(nm,nm);
for i = 1:nm %[1 4] %to look only at TIMO and perc_var
    for j = 1:nm %[1 4] %1:5
        [corr_mat(j,i) ] = corr(data_all(:,i),data_all(:,j),'type','Spearman');
        [corr_mat_ctrl(j,i) ] = corr(data_all(1:20,i),data_all(1:20,j),'type','Spearman');
        [corr_mat_adhd(j,i) ] = corr(data_all(21:40,i),data_all(21:40,j),'type','Spearman');
    end
end
%{
var_eig = var(eig(corr_mat));
M = nm;
Meff = 1+(M-1)*(1-var_eig/M);
alph = 0.05;
%alph_sidak = 1-(1-alph)^(1/Meff)
%}
% inserted here since it cant be computed as we cant make public the
% clinical records
alph_sidak = 0.0089;


%var_eig_ctrl = var(eig(corr_mat_ctrl));
%Meff_ctrl = 1+(M-1)*(1-var_eig_ctrl/M);
%alph_sidak_ctrl = 1-(1-alph)^(1/Meff_ctrl)
alph_sidak_ctrl = 0.0083;

%var_eig_adhd = var(eig(corr_mat_adhd));
%Meff_adhd = 1+(M-1)*(1-var_eig_adhd/M);
%alph_sidak_adhd = 1-(1-alph)^(1/Meff_adhd)
alph_sidak_adhd = 0.0082;

figure(fig_ind)

set(gcf, 'Position', [100 100 520 560])

%for GEC
xlim1 = 30;
xlim2 = 95;
%for ACDS
xlim1 = 0;
xlim2 = 100;

marginsa = [0.08 0.08 0.1 0.1];
guttera = [0.04 0.07];

nm = length(measures);

corr_r=nan(nm,nm);
corr_p=nan(nm,nm);
corr_r_ctrl = nan(nm,nm);
corr_p_ctrl = nan(nm,nm);
corr_r_adhd = nan(nm,nm);
corr_p_adhd = nan(nm,nm);

%fontsz =9;
%fontsz = 9;
for i = 1:(nm-1) %1:nm%
    for j = (i+1):nm %1:nm%
        [corr_r(j,i) corr_p(j,i)] = corr(data_all(:,i),data_all(:,j),'type','Spearman');
        
        [corr_r_ctrl(j,i) corr_p_ctrl(j,i)] = corr(data_all(1:20,i),data_all(1:20,j),'type','Spearman');
        [corr_r_adhd(j,i) corr_p_adhd(j,i)] = corr(data_all(21:40,i),data_all(21:40,j),'type','Spearman');
        
        tight_subplot(nm-1,nm-1,j-1,i,guttera,marginsa)
        
        plot(log(data_all(1:20,i)), log(data_all(1:20,j)), 'o', 'MarkerFaceColor', bluee, 'MarkerEdgeColor', bluee, 'MarkerSize', dsz); hold on;
        plot(log(data_all(21:40,i)), log(data_all(21:40,j)), 'o', 'MarkerFaceColor', redd, 'MarkerEdgeColor', redd, 'MarkerSize', dsz); hold on;
        
        
        if corr_p(j,i) < alph_sidak
            text(min(log(data_all(:,i)))-0.05*abs(min(log(data_all(:,i)))),1.01*max(log(data_all(:,j))),['r = ',num2str(corr_r(j,i),'%0.2f'),'**'],'Color',col_sig,'FontName','Helvetica','FontSize',fontsz)
            
            if corr_p(j,i)<0.0001
                text(min(log(data_all(:,i)))-0.05*abs(min(log(data_all(:,i)))),1.01*max(log(data_all(:,j))),['r = ',num2str(corr_r(j,i),'%0.2f'),'***'],'Color',col_sig,'FontName','Helvetica','FontSize',fontsz)
                
            end
        else
            
            text(min(log(data_all(:,i)))-0.05*abs(min(log(data_all(:,i)))),1.01*max(log(data_all(:,j))),['r = ',num2str(corr_r(j,i),'%0.2f')],'Color',col_sig,'FontName','Helvetica','FontSize',fontsz)
            
        end
        
        box off
        
        if i ==1
            xlim([-5 0])
            set(gca, 'xtick',[-5:1:0])
            set(gca, 'xticklabels',{'','-4','','-2','','0'},'FontName','Helvetica','FontSize',fontsz)
            if ismember(j,[2 3])
                ylim([-2 2])
                set(gca, 'ytick',[-2:1:2])
                set(gca, 'yticklabels',{'-2','','0','','2'},'FontName','Helvetica','FontSize',fontsz)
            elseif ismember(j,[4 5])
                ylim([-5 0])
                set(gca, 'ytick',[-5:1:0])
                set(gca, 'yticklabels',{'','-4','','-2','','0'},'FontName','Helvetica','FontSize',fontsz)
            elseif ismember(j,[6 7])
                ylim([0 100])
                set(gca, 'ytick',[0:25:100])
                set(gca, 'yticklabels',{'0','','50','','100'},'FontName','Helvetica','FontSize',fontsz)
            end
        elseif i ==2
            xlim([-2 2])
            set(gca, 'xtick',[-2:1:2])
            set(gca, 'xticklabels',{'-2','','0','','2'},'FontName','Helvetica','FontSize',fontsz)
            if j == 3
                ylim([-2 2])
                set(gca, 'ytick',[-2:1:2])
                set(gca, 'yticklabels',{'-2','','0','','2'},'FontName','Helvetica','FontSize',fontsz)
            elseif ismember(j,[4 5])
                ylim([-5 0])
                set(gca, 'ytick',[-5:1:0])
                set(gca, 'yticklabels',{'','-4','','-2','','0'},'FontName','Helvetica','FontSize',fontsz)
            elseif ismember(j,[6 7])
                ylim([0 100])
                set(gca, 'ytick',[0:25:100])
                set(gca, 'yticklabels',{'0','','50','','100'},'FontName','Helvetica','FontSize',fontsz)
            end
        elseif i ==3
            xlim([-2 2])
            set(gca, 'xtick',[-2:1:2])
            set(gca, 'xticklabels',{'-2','','0','','2'},'FontName','Helvetica','FontSize',fontsz)
            if ismember(j,[4 5])
                ylim([-5 0])
                set(gca, 'ytick',[-5:1:0])
                set(gca, 'yticklabels',{'','-4','','-2','','0'},'FontName','Helvetica','FontSize',fontsz)
            elseif ismember(j,[6 7])
                ylim([0 100])
                set(gca, 'ytick',[0:25:100])
                set(gca, 'yticklabels',{'0','','50','','100'},'FontName','Helvetica','FontSize',fontsz)
            end
        elseif i==4
            set(gca, 'xtick',[-4:1:0])
            xlim([-4 0])
            set(gca, 'xticklabels',{'-4','','-2','','0'},'FontName','Helvetica','FontSize',fontsz)
            if j == 5
                ylim([-5 0])
                set(gca, 'ytick',[-5:1:0])
                set(gca, 'yticklabels',{'','-4','','-2','','0'},'FontName','Helvetica','FontSize',fontsz)
            elseif ismember(j,[6 7])
                ylim([0 100])
                set(gca, 'ytick',[0:25:100])
                set(gca, 'yticklabels',{'0','','50','','100'},'FontName','Helvetica','FontSize',fontsz)
            end
        elseif i==5
            set(gca, 'xtick',[-5:1:0])
            xlim([-5 0])
            set(gca, 'xticklabels',{'','-4','','-2','','0'},'FontName','Helvetica','FontSize',fontsz)
            
            if ismember(j,[6 7])
                ylim([0 100])
                set(gca, 'ytick',[0:25:100])
                set(gca, 'yticklabels',{'0','','50','','100'},'FontName','Helvetica','FontSize',fontsz)
            end
        elseif i==6
            xlim([0 100])
            set(gca, 'xtick',[0:25:100])
            set(gca, 'xticklabels',{'0','','50','','100'},'FontName','Helvetica','FontSize',fontsz)
            ylim([0 100])
            set(gca, 'ytick',[0:25:100])
            set(gca, 'yticklabels',{'0','','50','','100'},'FontName','Helvetica','FontSize',fontsz)
            
        end
        
        set(gca,'tickdir','out')
        set(gca, 'ticklength', [0.04 0.04])
        
        
    end
end

%
%psname = 'metrics_correlations_allFF.pdf';
%print_pdf(psname)




%% corr ADHD vs Controls remove columns 1 and 2 since they are GEC and ACDS
%permutation test
%{
diff_corr = corr_r_adhd - corr_r_ctrl;
np = 1000;
Nsbj = size(data_all,1);

corr_r_ctrlS = nan(np, nm, nm);
corr_r_adhdS = nan(np, nm, nm);
corr_p_ctrlS = nan(np, nm, nm);
corr_p_adhdS = nan(np, nm, nm);

for pi =1 :np
    ind_shf = randperm(Nsbj);
    for i = 3:(nm-1)
        for j = (i+1):nm
            
            [corr_r_ctrlS(pi,j,i) corr_p_ctrlS(pi,j,i)] = corr(data_all(ind_shf(1:20),i),data_all(ind_shf(1:20),j),'type','Spearman');
            [corr_r_adhdS(pi,j,i) corr_p_adhdS(pi,j,i)] = corr(data_all(ind_shf(21:40),i),data_all(ind_shf(21:40),j),'type','Spearman');
            
            distt(pi,j,i) =  corr_r_adhdS(pi,j,i)- corr_r_ctrlS(pi,j,i);
        end
    end
end
%%
for i = 3:(nm-1)
    for j = (i+1):nm
        corr_distt(j,i) = sum(squeeze(distt(:,j,i))>=diff_corr(j,i))/np;
    end
end
corr_distt;
%}

end