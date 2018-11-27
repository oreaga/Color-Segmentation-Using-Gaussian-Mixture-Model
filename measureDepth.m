files = {'GMM_prob1.mat', 'GMM_prob2.mat', 'GMM_prob3.mat', 'GMM_prob4.mat', 'GMM_prob5.mat', 'GMM_prob6.mat', 'GMM_prob7.mat', 'GMM_prob8.mat'}
   
f = load('fitFunction.mat')
distArr = []

for w = files
    path = w{1}
    probsMatrixStruct = load(path)
    probsMatrix = probsMatrixStruct.probsMatrix
    m = max(probsMatrix(:))
    normMatrix = probsMatrix/m
    tMatrix = normMatrix > 0.9985
    
    P = regionprops(tMatrix, 'Area')

    biggestArea = 0
    for h = 1:length(P)
        if P(h).Area > biggestArea
            biggestArea = P(h).Area
        end
    end
    
    distArr = [distArr f.f(biggestArea)]
end
    
    
    
    
    
    
    
    
    
    