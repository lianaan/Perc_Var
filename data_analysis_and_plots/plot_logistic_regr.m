function plot_logistic_regr(fig_ind,data_all, diag)

[fontsz, dsz, msz1, msz2, eb_w, eb_t, nboot, ci_bnd_low, ci_bnd_high, redd, bluee, redd_shade, bluee_shade, colormat, bar_ind_ctrl, bar_ind_adhd] = set_plotting_params();

sigm = log(data_all(:,4));
resp = log(data_all(:,1));

y = diag;
x = [sigm resp];


[b_fit,dev,stats] = glmfit(x,y,'binomial','link','logit')
[b_fitS,dev,stats] = glmfit(x(:,1),y,'binomial','link','logit')
[b_fitR,dev,stats] = glmfit(x(:,2),y,'binomial','link','logit')
p_diag = glmval(b_fit,x(:,[1 2]),'logit');
y_diag = p_diag >=0.5;
accuracy = mean(y_diag ==y)
hit_rate = sum(y_diag == 1 & y == 1)/sum(y == 1)
fa_rate = sum(y_diag == 1 & y == 0)/sum(y == 0)



x = [log(data_all(:,4)) log(data_all(:,1)) log(data_all(:,2)) ...
      log(data_all(:,3)) log(data_all(:,5))];
    

  
color_sens = [152 167 52]/255;
color_resp = [192, 128, 129]/255; % old rose %[140 85 107]/255;


color_all = [80 16 189]/255;%[1 56 89]/255;
color_list = [ 0 0 0; color_sens; color_resp; color_all];

marginsa = [0.12 0.08 0.27 0.16]; %[LEFT RIGHT BOTTOM TOP]
guttera = [0.08 0.03];


% cross-validation


regr_ind = {[1 2]; 1; 2; [1 2 3 4 5]};


figure(fig_ind)
set(gcf, 'Position', [100 100 500 140])
dsz = 4;
fontsz = 12;

tight_subplot(3,3,[1 2 3],1, guttera, marginsa)
h1=plot(sigm(1:20),resp(1:20), 'o','MarkerFaceColor', bluee, 'MarkerEdgeColor',bluee, 'MarkerSize', dsz); hold on;
h2=plot(sigm(21:40),resp(21:40),'o','MarkerFaceColor',redd, 'MarkerEdgeColor',redd, 'MarkerSize', dsz); hold on;
xlim([-3.8 -0.65])
ylim([-5 -0.5])

% prepare a grid of points to evaluate the model at
ax = axis;
nvals = 10; %200;
xvals = linspace(ax(1),ax(2),nvals);
yvals = linspace(ax(3),ax(4),nvals);
[xx,yy] = meshgrid(xvals,yvals);
gridX = [xx(:) yy(:)];

outputimageA = glmval(b_fit,gridX,'logit');
outputimageA = reshape(outputimageA,[length(yvals) length(xvals)]);
[d,hA] = contour(xvals,yvals,outputimageA,[.5 .5]); hold on;
set(hA,'LineStyle','--','LineWidth',1.0,'LineColor',[0 0 0]);  hold on;


outputimageS = glmval([b_fitS;0],gridX,'logit');
outputimageS = reshape(outputimageS,[length(yvals) length(xvals)]);
[d,hS] = contour(xvals,yvals,outputimageS,[.5 .5]); hold on;
set(hS, 'LineStyle','--','LineWidth',1.0,'LineColor',color_sens);  hold on;


outputimageR = glmval([b_fitR(1);0; b_fitR(2)],gridX,'logit');
outputimageR = reshape(outputimageR,[length(yvals) length(xvals)]);
[d,hR] = contour(xvals,yvals,outputimageR,[.5 .5]); hold on;
set(hR,'LineStyle','--','LineWidth',1.0,'LineColor',color_resp);  hold on;


set(gca, 'tickdir', 'out')
set(gca,'TickLength',[0.04,0.04])
xlabel('log \sigma', 'FontName','Helvetica', 'FontSize', fontsz)
ylabel('log TIMO', 'FontName','Helvetica', 'FontSize', fontsz)
box off


nfold = 10;%5;%10;
n_runs = 100;%1000;%50;% 200;%1000;


clear b;
clear y_predk;
clear y_predR;
clear accuracy;
clear accuracy_all;
clear error_rate_all

ya = linspace(0,1,20);


accuracy_m_all = nan(length(regr_ind), n_runs);


for regr_i = 1:length(regr_ind)
    rei = regr_ind{regr_i};
    clear b;
    clear y_predk;
    for ri = 1:n_runs%:1000 %100 runs
        % Train-test splitting, do this 5 times if nfold=4; 2*nfold/40
        
        indi1 = randperm(20);
        indi2 = 20+randperm(20);
        
        accuracy = nan(nfold,1);
        for k = 1:nfold
            
            indi_test = [indi1((1+(k-1)*40/(2*nfold)):(2+(k-1)*40/(2*nfold)))...
                indi2((1+(k-1)*40/(2*nfold)):(2+(k-1)*40/(2*nfold)))]; %size 4
            indi_train = setdiff(1:1:40,indi_test);
            
            [b(:,k,ri),dev,stats] = glmfit(x(indi_train,rei),y(indi_train),'binomial','link','logit');
            y_predk(k,ri,:) = glmval(b(:,k,ri),x(indi_test,rei),'logit');
            y_predd = squeeze(y_predk(k,ri,:)) >= 0.5; %thresh
            error_rate(k) = mean(y_predd ~= y(indi_test));
            accuracy(k) = 1 - error_rate(k);
            accuracy_all(regr_i,ri,k) = accuracy(k);
        end
        accuracy_m_all(regr_i,ri) = mean(accuracy);
        
    end
    
    
end
box off


accuracies = nan(length(regr_ind), n_runs*nfold);
for regr_i = 1:length(regr_ind)
    accuracies(regr_i,:) = reshape(squeeze(accuracy_all(regr_i,:,:)),1, n_runs*nfold);
end


%% ROC curve NOT cross-validated
threshv = linspace(0,1,1000);
clear hit_rate;
clear fa_rate;
clear hit_rateE;
clear fa_rateE;

hit_rate = nan(length(regr_ind),length(threshv));
fa_rate = nan(length(regr_ind),length(threshv));

for regr_i = 1 : length(regr_ind)
    rei = regr_ind{regr_i};
    clear b;
    for ti = 1:length(threshv)
        clear b;
        
        indi_train = [1:1:40]';
        indi_test = indi_train;
        
        [b,dev,stats] = glmfit(x(indi_train,rei),y(indi_train),'binomial','link','logit');
        y_predk = glmval(b,x(indi_train,rei),'logit');
        y_pred = squeeze(y_predk) >=threshv(ti); %thresh
        
        hit_rate(regr_i,ti) = sum(y_pred == 1 & y(indi_test) == 1)/sum(y(indi_test) ==1);
        fa_rate(regr_i,ti) = sum(y_pred == 1 & y(indi_test) == 0)/sum(y(indi_test) ==0);
        
    end
    
    figure(fig_ind)
    
    tight_subplot(3,3,[1 2 3],2, guttera, marginsa)
    hROC(regr_i) = plot(fa_rate(regr_i,:),hit_rate(regr_i,:),'Color',color_list(regr_i,:), 'Linewidth', 1.5); hold on;
    axis equal
    if regr_i == length(regr_ind)
        plot([0 1],[0 1],'--','Color',[0.5 0.5 0.5]); hold on;
        xlabel('false-alarm rate','FontName', 'Helvetica','FontSize',fontsz)
        ylabel('hit rate','FontName', 'Helvetica','FontSize',fontsz)
        box off
    end
    axis equal
    xlim([0 1.01])
    ylim([0 1.01])
    set(gca, 'xtick',[0:0.25:1])
    set(gca, 'ytick',[0:0.25:1])
    set(gca, 'xticklabels', {'0', '','0.5','','1'}, 'FontName', 'Helvetica', 'FontSize', fontsz)
    set(gca, 'xticklabels', {'0', '','0.5','','1'}, 'FontName', 'Helvetica', 'FontSize', fontsz)
    set(gca, 'tickdir', 'out')
    set(gca,'TickLength',[0.04,0.04])
    
end




%% ROC curve cross-validated
threshv = linspace(0,1,10);
clear hit_rate;
clear fa_rate;
clear hit_rateE;
clear fa_rateE;

clear y_predk;
clear y_predR;
clear accuracy;
clear accuracy_all;
clear error_rate_all


hit_rate = nan(length(regr_ind),length(threshv), n_runs, nfold);
fa_rate = nan(length(regr_ind),length(threshv), n_runs, nfold);
hit_rate_kE = nan( length(regr_ind),length(threshv), n_runs);
fa_rate_kE = nan( length(regr_ind),length(threshv), n_runs);

for regr_i = 1: length(regr_ind)
    rei = regr_ind{regr_i};
    clear b;
    for ti = 1:length(threshv)
        clear b;
        for ri = 1:n_runs%:1000 %100 runs
            % Train-test splitting, do this 5 times if nfold=4; 2*nfold/40
            
            indi1 = randperm(20);
            indi2 = 20+randperm(20);
            
            for k = 1:nfold
                
                
                indi_test = [indi1((1+(k-1)*40/(2*nfold)):(2+(k-1)*40/(2*nfold)))...
                    indi2((1+(k-1)*40/(2*nfold)):(2+(k-1)*40/(2*nfold)))]; %size 4
                indi_train = setdiff(1:1:40,indi_test); %size 36
                
                [b(:,k,ri),dev,stats] = glmfit(x(indi_train,rei),y(indi_train),'binomial','link','logit');
                y_predk(k,ri,:) = glmval(b(:,k,ri),x(indi_test,rei),'logit');
                y_pred = squeeze(y_predk(k,ri,:)) >=threshv(ti); %thresh
                error_rate(k) = mean(y_pred ~= y(indi_test));
                accuracy(k) = 1- error_rate(k);
                accuracy_all(regr_i,ti,ri,k) = accuracy(k);
                
                hit_rate(regr_i,ti,ri,k) = sum(y_pred == 1 & y(indi_test) == 1)/sum(y(indi_test) ==1);
                fa_rate(regr_i,ti, ri,k) = sum(y_pred == 1 & y(indi_test) == 0)/sum(y(indi_test) ==0);
                
            end
            accuracy_m_ti_all(regr_i,ti,ri) = mean(accuracy);
            hit_rate_kE(regr_i, ti, ri) = mean(hit_rate(regr_i,ti,ri,1:nfold),4);
            fa_rate_kE(regr_i, ti, ri) = mean(fa_rate(regr_i,ti,ri,1:nfold),4);
        end
        
        hit_rateE(regr_i,ti) = mean(hit_rate_kE(regr_i,ti,:),3);
        fa_rateE(regr_i,ti) = mean(fa_rate_kE(regr_i,ti,:),3);
    end
    
    figure(fig_ind)
    
    tight_subplot(3,3,[1 2 3],3, guttera, marginsa)
    hROC(regr_i) = plot(fa_rateE(regr_i,:),hit_rateE(regr_i,:),'Color',color_list(regr_i,:), 'Linewidth', 1.5); hold on;
    axis equal
    if regr_i == length(regr_ind)
        plot([0 1],[0 1],'--','Color',[0.5 0.5 0.5]); hold on;
        xlabel('False alarm rate','FontName', 'Helvetica','FontSize',fontsz)
        ylabel('Hit rate','FontName', 'Helvetica','FontSize',fontsz)
        box off
    end
    axis equal
    xlim([0 1.0])
    ylim([0 1.0])
    set(gca, 'xtick',[0:0.25:1])
    set(gca, 'ytick',[0:0.25:1])
    set(gca, 'xticklabels', {'0', '','0.5','','1'}, 'FontName', 'Helvetica', 'FontSize', fontsz)
    set(gca, 'xticklabels', {'0', '','0.5','','1'}, 'FontName', 'Helvetica', 'FontSize', fontsz)
    set(gca, 'tickdir', 'out')
    set(gca,'TickLength',[0.04,0.04])
    
end

psname ='log_regr_classif_allFFF.pdf'
%print_pdf(psname)


end
