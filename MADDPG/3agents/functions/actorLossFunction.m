function loss = actorLossFunction(policy, LossData)
    policy = policy{1};
    x = sum(policy,'all')+1;
    x = x/x; %To bypass the trace dlarray require,emt

    loss = x*LossData.aloss;

    
end