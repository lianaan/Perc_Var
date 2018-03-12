function nll = RT_models_nll(mi,RTs,pars)
nll = -sum(RT_models_logpdf(mi,RTs,pars));
end