load('MSdata');

%% directly compute
% patch = ones(size(trainx,1), 1);
% trainx = [patch, trainx];
% beta = (trainx.'*trainx)^-1*trainx.'*trainy;
% 
% patch = ones(size(testx,1), 1);
% testx = [patch, testx];
% prediction = testx*beta;
% 
% csvwrite('prediction.csv', prediction)

%% PCA
% meanx = mean(trainx);
% varx = var(trainx);
% for i = 1:90
%     trainx(:,i) = (trainx(:,i) - meanx(i))/sqrt(varx(i));
% end
% [U,V] = eig(trainx.'*trainx);
% pcax = trainx*U(:, 89:90);
% patch = ones(size(trainx,1), 1);
% pcax = [patch, pcax(:,1), pcax(:,2), pcax(:,1).*pcax(:,2)];
% beta = (pcax.'*pcax)^-1*pcax.'*trainy;
% 
% 
% meanx = mean(testx);
% varx = var(testx);
% for i = 1:90
%     testx(:,i) = (testx(:,i) - meanx(i))/sqrt(varx(i));
% end
% [U,V] = eig(testx.'*testx);
% pcaxtest = testx*U(:, 89:90);
% 
% patch = ones(size(testx,1), 1);
% pcaxtest = [patch, pcaxtest(:,1), pcaxtest(:,2), pcaxtest(:,1).*pcaxtest(:,2)];
% prediction = pcaxtest*beta;
% 
% csvwrite('prediction1.csv', prediction)

%% attempt
dict = zeros(89,1);
mu = zeros(89,1);
pri = zeros(89,1);
theta = zeros(89,90,90);
mu(1) = mean(trainx(find(trainy==1922)));
pri(1) = length(find(trainy==1922));
theta(1) = cov(trainx(find(trainy==1922)));
for i = 2:89
    mu(i) = mean(trainx(find(trainy==(i+1922))));
    pri(i) = length(find(trainy==(i+1922)));
    theta(i) = cov(trainx(find(trainy==(i+1922))));
end
dict(1) = 1922;
for i = 2:89
    dict(i) = i+1922;
end
prediction = zeros(51630,1);
pri = pri/size(trainy,1);
for i = 1:51630
    prob = zeros(89,1);
    for j = 1:89
        prob(j) = exp(mvnpdf(testx(i),mu(j),theta(j)+1e-5)*pri(j));
    end
    prob = prob/norm(prob,1);
    prediction(i) = sum(prob.*dict);
end
mean(prediction)
%csvwrite('prediction1.csv', prediction);
