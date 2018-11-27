%% Script for testing GMM model with testing images

files = {'1.jpg', '2.jpg', '3.jpg', '4.jpg', '5.jpg', '6.jpg', '7.jpg', '8.jpg'}
vars = load('GMM_vars.mat')
q = 1

for p = files
    path = strcat('test_images/', p)
   
    A = imread(path{1})
    
    
    for i = 1:length(A(:,1,1))
        for j = 1:length(A(1,:,1))
            g1 = probX(double([A(i,j,1); A(i,j,2); A(i,j,3)]), vars.mean1, vars.S1);
            g2 = probX(double([A(i,j,1); A(i,j,2); A(i,j,3)]), vars.mean2, vars.S2);
            g3 = probX(double([A(i,j,1); A(i,j,2); A(i,j,3)]), vars.mean3, vars.S3);
            probability = vars.p1*g1 + vars.p2*g2 + vars.p3*g3;
            probsMatrix(i,j) = probability;
        end
    end
    
    string = strcat('GMM_prob', num2str(q), '.mat')
    save(string, 'probsMatrix')
    maxProb = max(probsMatrix(:))
    heatMatrix = probsMatrix/maxProb;
    heatMatrix = heatMatrix > 0.9985
    
    figure(q)
    heatmap(double(heatMatrix))
    q = q + 1
end

function Xprob = probX(x, Om, Oc)

Xprob = (1/sqrt(((2*pi).^3)*det(Oc)))*exp((-1/2).*(transpose(x - Om)*inv(Oc)*(x - Om)));

end