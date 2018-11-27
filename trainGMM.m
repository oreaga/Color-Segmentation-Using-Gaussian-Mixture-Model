%% Script for training a GMM model

Ostruct = load('Opixels.mat')
Opix = double(Ostruct.Opix)
s = length(Opix(1,:))
subLength = floor(s/3)

maxNorm = norm([255; 255; 255])

sub1 = []
sub2 = []
sub3 = []

for i = 1: length(Opix(1,:))
    N = norm(Opix(:, i));
    
    if N < maxNorm/3
        sub1 = [sub1 Opix(:, i)];
    elseif N > 2*maxNorm/3
        sub2 = [sub2 Opix(:, i)];
    else
        sub3 = [sub3 Opix(:, i)];
    end
        
end

% sub1 = Opix(:, 1:subLength)
% sub2 = Opix(:, subLength+1:2*subLength)
% sub3 = Opix(:, 2*subLength+1:end-1)

mean1 = sum(sub1, 2)./(length(sub1(1,:)))
mean2 = sum(sub2, 2)./(length(sub2(1,:)))
mean3 = sum(sub3, 2)./(length(sub3(1,:)))

S1 = (1/(length(sub1(1,:))))*((sub1-mean1)*transpose(sub1-mean1))
S2 = (1/(length(sub2(1,:))))*((sub2-mean2)*transpose(sub2-mean2))
S3 = (1/(length(sub3(1,:))))*((sub3-mean3)*transpose(sub3-mean3))

j = 0;
conSum = 100;
p1 = 1/4;
p2 = 1/2;
p3 = 1/4;

alphaNum1 = zeros(1, s)
alphaNum2 = zeros(1, s)
alphaNum3 = zeros(1, s)

while (j < 200 && conSum > .001)
    for i = 1:s
       alphaNum1(i) = p1*probX(Opix(:,i), mean1, S1);
       alphaNum2(i) = p2*probX(Opix(:,i), mean2, S2);
       alphaNum3(i) = p3*probX(Opix(:,i), mean3, S3);
    end
    
    alphaNums = [alphaNum1;
                 alphaNum2;
                 alphaNum3];
    
    denomSums = sum(alphaNums);
    denominators = [denomSums;
                    denomSums;
                    denomSums];
                
    alphas = alphaNums./denominators;
    
    oldMean1 = mean1;
    oldMean2 = mean2;
    oldMean3 = mean3;
    
    mean1 = Opix*transpose(alphas(1,:))/sum(alphas(1,:));
    mean2 = Opix*transpose(alphas(2,:))/sum(alphas(2,:));
    mean3 = Opix*transpose(alphas(3,:))/sum(alphas(3,:));
    
    S1 = (repmat(alphas(1,:), 3, 1).*(Opix-mean1))*transpose(Opix-mean1)/sum(alphas(1,:));
    S2 = (repmat(alphas(2,:), 3, 1).*(Opix-mean2))*transpose(Opix-mean2)/sum(alphas(2,:));
    S3 = (repmat(alphas(3,:), 3, 1).*(Opix-mean3))*transpose(Opix-mean3)/sum(alphas(3,:));
    
    p1 = sum(alphas(1,:))/s;
    p2 = sum(alphas(2,:))/s;
    p3 = sum(alphas(3,:))/s;
    
    meanDiffNorms = [norm(mean1 - oldMean1); norm(mean2 - oldMean2); norm(mean3 - oldMean3)];
    conSum = sum(meanDiffNorms);
    j = j + 1
end


function Xprob = probX(x, Om, Oc)

Xprob = (1/sqrt(((2*pi).^3)*det(Oc)))*exp((-1/2).*(transpose(x - Om)*inv(Oc)*(x - Om)));

end
    