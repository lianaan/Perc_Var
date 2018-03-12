function [pars_fit, nll] = RT_models_fit(mi,RTs)

%based on Bram B. Zandbelt' exGauss package for Matlab

min_val = -5; 

plaus_range = quantile(RTs,0.99)-quantile(RTs,0.01);

costFun  = @RT_models_nll; % Negative log-likelihood

pars_fit = [];
nll = [];


switch mi
    case 1 %ex Gaussian
        nvars = 3;
        
        LB      = [log(min(RTs)), min_val, min_val];
        UB      = [log(max(RTs)), log(plaus_range), log(plaus_range)];
        
        PLB = LB;
        PUB = UB;
        start_pars = (PUB-PLB).*rand(1,nvars) + PLB;
        while isinf(RT_models_nll(mi,RTs,start_pars))
            start_pars = (PUB-PLB).*rand(1,nvars) + PLB;
        end
    case 2 %Gamma
        nvars = 2;
        
        LB      = [log(min(RTs)), min_val];
        UB      = [log(max(RTs)), log(plaus_range)];
        PLB = LB;
        PUB = UB;
        start_pars = (PUB-PLB).*rand(1,nvars) + PLB;
        while isinf(RT_models_nll(mi,RTs,start_pars))
            start_pars = (PUB-PLB).*rand(1,nvars) + PLB;
        end
    case 3  %log Normal
        nvars = 2;
        
        LB      = [log(min(RTs)), min_val];
        UB      = [log(max(RTs)), log(plaus_range)];
        PLB = LB;
        PUB = UB;
        start_pars = (PUB-PLB).*rand(1,nvars) + PLB;
        while isinf(RT_models_nll(mi,RTs,start_pars))
            start_pars = (PUB-PLB).*rand(1,nvars) + PLB;
        end
     
end

% if using Luigi Acerbi's bads optimization method
%options = bads('defaults'); 
%options.Ninit = 2;                      % Only 2 points for initial mesh
%options.UncertaintyHandling = 1;        % Activate noise handling
%options.NoiseSize = 1;  
%[pars_fit,nll] = bads(@(pars) costFun(mi,RTs,pars), start_pars, LB, UB,PLB,PUB,options);

solverOpts   = optimset('Display','off','MaxFunEvals',200*length(start_pars),'MaxIter',200*length(start_pars),'TolFun',1e-4,'TolX',1e-4);
[pars_fit,nll,exitFlag,solverOutput] = fminsearchbnd(@(pars) costFun(mi,RTs,pars),start_pars,LB,UB,solverOpts);

%end
