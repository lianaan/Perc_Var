function logpdf = RT_models_logpdf(mi,RTs, pars)


switch mi
    case 1 % ex-Gaussian
        
        mu    = exp(pars(1));
        sigma = exp(pars(2));
        tau   = exp(pars(3));
        
        logpdf     = -log(tau)+ ...
            ((mu - RTs)./tau) + ((sigma.^2)./(2.*tau.^2))+ ...
            log(.5.*(1+erf((((RTs-mu)./sigma) - (sigma./tau))./sqrt(2))));
  
    case 2 % Gamma
        k      = exp(pars(1));
        theta  = exp(pars(2));
        
        logpdf = -log(gamma(k))-log(theta^k)+(k-1)*log(RTs)-...
            RTs/theta;
        
    case 3 % log Normal
        mu    = exp(pars(1));
        sigma = exp(pars(2));
        
        logpdf = -log(RTs)- log(sigma *sqrt(2*pi))-...
            ((log(RTs)-mu).^2)/(2*sigma^2);
        
 
end



