function psych_curves_pars_fit(parmi)

load('alldata.mat')

par = mod(parmi,length(alldata))+1;
mi = floor(parmi/40)+1;

data = alldata(par);


nmu = 201;
nsigma =201;
nlambda = 201;

mu_range=[-0.2, 0.2];
sigma_range=[0.002,0.6];
lambda_range=[0.001, 0.4];

mu_tabl=[mu_range(1):0.002:mu_range(2)];
nmu=length(mu_tabl);
sigma_tabl=exp(linspace(log(sigma_range(1)), log(sigma_range(2)),nsigma));
lambda_tabl=exp(linspace(log(lambda_range(1)), log(lambda_range(2)), nlambda));



mu_tab(:,1,1) = mu_tabl;
sigma_tab(1,:,1)=sigma_tabl;
lambda_tab(1,1,:) = lambda_tabl;


cond_list ={'Ori', 'OriS', 'Col', 'ColS'};

all_vals=nan(250,4);
all_resp=nan(250,4);


for cond=1:4
    clear eval;
    all_vals(1:length(eval(['alldata(par).cond_',cond_list{cond},'.stims'])),cond) = eval(['alldata(par).cond_',cond_list{cond},'.stims']);
    all_resp(1:length(eval(['alldata(par).cond_',cond_list{cond},'.resp'])),cond) = eval(['alldata(par).cond_',cond_list{cond},'.resp']);
end




switch mi
    case 1 % full model, 12 parameters
        
        sigma_e = nan(8,1);
        mu_e = nan(8,1);
        lambda_e = nan(8,1);
        for cond = 1 : length(cond_list)
            for l_i = 1:nlambda
                l_i
                lambda_val=lambda_tabl(l_i);
                for mu_i=1:nmu
                    mu_val=mu_tabl(mu_i);
                    for sigma_i=1:nsigma
                        sigma_val=sigma_tabl(sigma_i);
                        LL_all_cond(l_i,mu_i, sigma_i)=loglike(all_vals(:,cond),all_resp(:,cond), mu_val, sigma_val, lambda_val);
                    end
                end
            end
            
            [li_mi(cond) mu_mi(cond) sigma_mi(cond)] = ind2sub(size(LL_all_cond), find(LL_all_cond==max(max(max(LL_all_cond)))));
            lambda_e(cond) = lambda_tabl(li_mi(cond));
            mu_e(cond) = mu_tabl(mu_mi(cond));
            sigma_e(cond) = sigma_tabl(sigma_mi(cond));
            
        end
        
        pop(par).mu.mean = mu_e;
        pop(par).sigma.mean = sigma_e;
        pop(par).lambda.mean = lambda_e;
        
    case 2 % shared mu's, 4 sigmas, shared lambdas, 8 pars
        % fit cond 1 and 2
        for l12_i=1:nlambda
            l12_i
            lambda_val=lambda_tabl(l12_i);
            for mu12_i=1:nmu
                mu_val=mu_tabl(mu12_i);
                for sigma1_i=1:nsigma
                    sigma_val=sigma_tabl(sigma1_i);
                    LL_sig1(sigma1_i)=loglike(all_vals(:,1),all_resp(:,1), mu_val, sigma_val, lambda_val);
                end
                indi_max=[];
                indi_max=find(LL_sig1==max(LL_sig1));
                sigma1_mi(l12_i,mu12_i)=indi_max(1);
                
                for sigma2_i=1:nsigma
                    sigma_val=sigma_tabl(sigma2_i);
                    LL_sig2(sigma2_i)=loglike(all_vals(:,2),all_resp(:,2), mu_val, sigma_val, lambda_val);
                end
                sigma2_mi(l12_i,mu12_i)=find(LL_sig2==max(LL_sig2));
                
                LL_all_12(l12_i,mu12_i)=max(LL_sig1)+max(LL_sig2);
            end
        end
        
        [li12_mi mu12_mi]=ind2sub(size(LL_all_12), find(LL_all_12==max(max(LL_all_12))))
        
        lambda12_e=lambda_tabl(li12_mi);
        mu12_e=mu_tabl(mu12_mi);
        
        sigma1_e=sigma_tabl(sigma1_mi(li12_mi,mu12_mi));
        sigma2_e=sigma_tabl(sigma2_mi(li12_mi,mu12_mi));
        
        % fit cond 3 and 4
        for l34_i=1:nlambda
            l34_i
            lambda_val=lambda_tabl(l34_i);
            for mu34_i=1:nmu
                mu_val=mu_tabl(mu34_i);
                for sigma3_i=1:nsigma
                    sigma_val=sigma_tabl(sigma3_i);
                    LL_sig3(sigma3_i)=loglike(all_vals(:,3),all_resp(:,3), mu_val, sigma_val, lambda_val);
                end
                sigma3_mi(l34_i,mu34_i)=find(LL_sig3==max(LL_sig3));
                
                for sigma4_i=1:nsigma
                    sigma_val=sigma_tabl(sigma4_i);
                    LL_sig4(sigma4_i)=loglike(all_vals(:,4),all_resp(:,4), mu_val, sigma_val, lambda_val);
                end
                indi_max=[];
                indi_max=find(LL_sig4==max(LL_sig4));
                sigma4_mi(l34_i,mu34_i)=indi_max(1);
                
                LL_all_34(l34_i,mu34_i)=max(LL_sig3)+max(LL_sig4);
            end
        end
        [li34_mi mu34_mi]=ind2sub(size(LL_all_34), find(LL_all_34==max(max(LL_all_34))))
        
        lambda34_e=lambda_tabl(li34_mi);
        mu34_e=mu_tabl(mu34_mi);
        
        sigma3_e=sigma_tabl(sigma3_mi(li34_mi,mu34_mi));
        sigma4_e=sigma_tabl(sigma4_mi(li34_mi,mu34_mi));
        
        
        %write these values inside pop
        pop(par).mu.mean=[mu12_e mu12_e mu34_e mu34_e];
        pop(par).sigma.mean=[sigma1_e sigma2_e sigma3_e sigma4_e];
        pop(par).lambda.mean=[lambda12_e lambda12_e lambda34_e lambda34_e];
        
        
end



savefilename=['psych_curve_par_estim_',num2str(par),'_model',num2str(mi), '.mat'];
save(savefilename,'pop','-mat')


