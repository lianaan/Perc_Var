function three_way_mixed_design_anova(vals)
vals = log(vals);
ind_rest = 1:40;
vals = vals(ind_rest,:); %Nsbj = 20;
Nsbj = 40;

subjects = [mod(([1:1:(2*Nsbj)]-1),Nsbj/2)+1, mod(([1:1:(2*Nsbj)]-1),Nsbj/2)+1];
group = [[ones(1,(2*Nsbj)) 2*ones(1,(2*Nsbj))]; ...
    [ones(1,Nsbj) 2* ones(1,Nsbj) ones(1,Nsbj) 2* ones(1,Nsbj)];...
    [ones(1,Nsbj/2) 2*ones(1,Nsbj/2)  ones(1,Nsbj/2) 2*ones(1,Nsbj/2) ...
    ones(1,Nsbj/2) 2*ones(1,Nsbj/2)  ones(1,Nsbj/2) 2*ones(1,Nsbj/2)]];

y = [vals(1:Nsbj/2,1); vals(1:Nsbj/2,3); vals(1:Nsbj/2,2); vals(1:Nsbj/2,4); ...
    vals(Nsbj/2+1:Nsbj,1); vals(Nsbj/2+1:Nsbj,3); vals(Nsbj/2+1:Nsbj,2); vals(Nsbj/2+1:Nsbj,4)];
p = anovan(y, [group' subjects'], 'random', 4,...
    'nested', [0 0 0 0; 0 0 0 0; 0 0 0 0; 1 0 0 0],...
    'varnames', {'Group', 'Load', 'Feature', 'Subject'}, 'model' ,'full')
g1 = group(1,:)';
g2 = group(2,:)';
g3 = group(3,:)';

end
