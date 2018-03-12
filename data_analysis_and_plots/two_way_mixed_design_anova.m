function two_way_mixed_design_anova(vals)
subjects = [mod(([1:1:40]-1),20)+1, mod(([1:1:40]-1),20)+1];
group = [[ones(1,40) 2*ones(1,40)]; ...
    [ones(1,20) 2* ones(1,20) ones(1,20) 2* ones(1,20)]];

y = [vals(1:20,1); vals(1:20,2);  ...
    vals(21:40,1); vals(21:40,2)];
p = anovan(y, [group' subjects'], 'random', 3,...
    'nested', [0 0 0 ; 0 0 0 ; 1 0 0 ],...
    'varnames', {'Group','Feature', 'Subject'}, 'model' ,'full')

end