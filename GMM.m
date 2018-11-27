%% Single Gaussian Color Segmentation

files = {'68.jpg', '76.jpg', '91.jpg', '99.jpg', '106.jpg', '114.jpg', '121.jpg', '137.jpg', '144.jpg', '152.jpg'...
         '160.jpg', '168.jpg', '176.jpg', '192.jpg', '200.jpg', '208.jpg', '216.jpg', '223.jpg', '231.jpg'...
         '248.jpg', '256.jpg', '264.jpg', '280.jpg'}
     
Opix = []
     
for i = files
    path = strcat('train_images/', i)
   
    A = imread(path{1})

    image(A)

    B = roipoly()

    Bint = uint8(B)
    ind = find(Bint(:,:,1))

    A1 = A(:,:,1)
    A2 = A(:,:,2)
    A3 = A(:,:,3)

    R = A1(ind)
    G = A2(ind)
    B = A3(ind)

    newPix = [R G B]'
    
    Opix = [Opix newPix]
end

s = length(Opix(1,:))
Or = sum(Opix(1,:))/s
Og = sum(Opix(2,:))/s
Ob = sum(Opix(3,:))/s

Omean = [Or;
         Og;
         Ob]
     
Ovar = double(Opix) - Omean

Ocov = (1/s).*(Ovar*transpose(Ovar))

probsMatrix = zeros(640,480)

for i = 1:length(A(:,1,1))
    for j = 1:length(A(1,:,1))
        p = probX(double([A(i,j,1); A(i,j,2); A(i,j,3)]), Omean, Ocov)
        probsMatrix(i,j) = p;
    end
end

m = max(probsMatrix(:))

normProbsMatrix = probsMatrix./m

tMatrix = normProbsMatrix > 0.4


%% GMM Color Segmentation

trainGMM;

testGMM;

fitDistance;

measureDepth;