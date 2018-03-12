function psych_curves_pars_fit_block(parmi)


load('alldata_blocks.mat')

par = mod(parmi,length(alldata))+1;
mi = floor(parmi/40)+1;

data = alldata(par);


nmu = 201;
nsigma = 201;
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



%cond_list ={'Ori', 'OriS', 'Col', 'ColS'};
cond_list ={'Ori1', 'Ori2', 'Col1', 'Col2', 'OriS1', 'ColS1', 'OriS2', 'ColS2'};

all_vals=nan(250,8);
all_resp=nan(250,8);


for cond=1:length(cond_list)
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
        
        
        
        
        
    case 2 % shared mu's, 8 sigmas, shared lambdas -> 12 pars
        % fit cond 1, 2 and 5 and 7
        sigma_e = nan(8,1);
        cond_ori = [1 2 5 7];
        for l12_i=1:nlambda
            l12_i
            lambda_val=lambda_tabl(l12_i);
            for mu12_i=1:nmu
                mu_val=mu_tabl(mu12_i);
                for ci = 1:4
                    
                    for sigma_i=1:nsigma
                        sigma_val=sigma_tabl(sigma_i);
                        LL_sig(ci,sigma_i)=loglike(all_vals(:,cond_ori(ci)),all_resp(:,cond_ori(ci)), mu_val, sigma_val, lambda_val);
                    end
                    indi_max=[];
                    indi_max=find(LL_sig(ci,:)==max(LL_sig(ci,:)));
                    sigma_mi(ci,l12_i,mu12_i)=indi_max(1);
                    
                end
                
                
                LL_all_1257(l12_i,mu12_i) = max(LL_sig(1,:)) + max(LL_sig(2,:)) +...
                    max(LL_sig(3,:)) + max(LL_sig(4,:)) ;
            end
        end
        
        [li12_mi mu12_mi] = ind2sub(size(LL_all_1257), find(LL_all_1257==max(max(LL_all_1257))))
        
        lambda12_e=lambda_tabl(li12_mi);
        mu12_e=mu_tabl(mu12_mi);
        
        for ci = 1:4
            sigma_e(cond_ori(ci)) = sigma_tabl(sigma_mi(ci, li12_mi,mu12_mi));
        end
        
        % fit cond 3, 4 and 6 and 8
        cond_col = [3 4 6 8];
        for l34_i=1:nlambda
            l34_i
            lambda_val=lambda_tabl(l34_i);
            for mu34_i=1:nmu
                mu_val=mu_tabl(mu34_i);
                
                for ci = 1: 4
                    for sigma_i=1:nsigma
                        sigma_val=sigma_tabl(sigma_i);
                        LL_sigg(ci,sigma_i)=loglike(all_vals(:,cond_col(ci)),all_resp(:,cond_col(ci)), mu_val, sigma_val, lambda_val);
                    end
                    indi_max=[];
                    indi_max=find(LL_sigg(ci,:)==max(LL_sigg(ci,:)));
                    sigma_mii(ci, l34_i,mu34_i)=indi_max(1);
                end
                LL_all_3468(l34_i,mu34_i) = max(LL_sigg(1,:)) + max(LL_sigg(2,:)) +...
                    max(LL_sigg(3,:)) + max(LL_sigg(4,:)) ;
            end
        end
        [li34_mi mu34_mi]=ind2sub(size(LL_all_3468), find(LL_all_3468==max(max(LL_all_3468))))
        
        lambda34_e=lambda_tabl(li34_mi);
        mu34_e=mu_tabl(mu34_mi);
        
        for ci = 1:4
            sigma_e(cond_col(ci)) =sigma_tabl(sigma_mii(ci, li34_mi,mu34_mi));
        end
        
        
        %write these values inside pop
        pop(par).mu.mean=[mu12_e mu12_e mu34_e mu34_e mu12_e mu34_e mu12_e mu34_e];
        pop(par).sigma.mean=sigma_e;
        pop(par).lambda.mean=[lambda12_e lambda12_e lambda34_e lambda34_e lambda12_e lambda34_e lambda12_e lambda34_e];
        
end




savefilename=['psych_curve_par_estim_EF_blocks',num2str(par),'_model',num2str(mi), '.mat'];
save(savefilename,'pop','-mat')


