function loss = criticLossFunction(qPrediction,lossData)
%     Observation = qPrediction{1};
%     Action = qPrediction{2};
% 
%     q = getValue(critic1,Observation,Action);
     q = qPrediction{1};

    loss = mse(q,lossData.targetQValues);
end