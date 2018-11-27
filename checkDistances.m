files = {'68', '76', '91', '99', '106', '114', '121', '137', '144', '152'...
         '160', '168', '176', '192', '200', '208', '216', '223', '231'...
         '248', '256', '264', '280'}
     
file1 = {'68'}

vars = load('GMM_vars_fixed.mat')
f = load('fitFunction.mat')

distArr = []
     
for w = files
    path = strcat('train_images/', w, '.jpg')
    
    A = imread(path{1});
    
    probsMatrix = zeros(length(A(:,1,1)), length(A(1,:,1)))

    for i = 1:length(A(:,1,1))lkl
        for j = 1:length(A(1,:,1))
            g1 = probX(double([A(i,j,1); A(i,j,2); A(i,j,3)]), vars.mean1, vars.S1);
            g2 = probX(double([A(i,j,1); A(i,j,2); A(i,j,3)]), vars.mean2, vars.S2);
            g3 = probX(double([A(i,j,1); A(i,j,2); A(i,j,3)]), vars.mean3, vars.S3);
            probability = vars.p1*g1 + vars.p2*g2 + vars.p3*g3;
            probsMatrix(i,j) = probability;
        end
    end

    m = max(probsMatrix(:));

    normProbsMatrix = probsMatrix./m;

    tMatrix = normProbsMatrix > 0.0005;
    
    P = regionprops(tMatrix, 'Area')
    
    m = 0
    for h = 1:length(P)
        if P(h).Area > m
            m = P(h).Area
        end
    end
    
    distArr = [distArr f.f(m)]
end