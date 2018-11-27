vars = load('GMM_vars_fixed.mat')
OpixStruct = load('Opixels.mat')
Opix = OpixStruct.Opix

hold on
grid on
scatter3(transpose(Opix(1,:)), transpose(Opix(2,:)), transpose(Opix(3,:)), '*')
xlabel('x')
ylabel('y')
zlabel('z')
el1 = plotGMMplot(vars.mean1, vars.S1)
set(el1, 'FaceColor', 'red')
el2 = plotGMMplot(vars.mean2, vars.S2)
set(el2, 'FaceColor', 'blue')
el3 = plotGMMplot(vars.mean3, vars.S3)
set(el3, 'FaceColor', 'green')

function el = plotGMMplot(uMean, Sigma)
    [V, D] = eig(Sigma)
    
    S = sort(D(:))
    
    [x,y,z] = ellipsoid(uMean(1), uMean(2), uMean(3), sqrt(S(9)), sqrt(S(8)), sqrt(S(7)))
    
    [val, ind] = max(D(:))
    [i, j] = ind2sub([3,3], ind)
    
    pAxis = V(:, j)
    
    zRot = ((atan(pAxis(2)/pAxis(1)))/(2*pi))*360
    vecRot = ((atan(pAxis(3)/pAxis(1)))/(2*pi))*360
    
    zRatio = pAxis(2)/pAxis(1)
    vecRatio = pAxis(3)/pAxis(1)
    
    axis equal
    el = surf(x, y, z)
    rotate(el, [0, 0, 1], zRot, transpose(uMean))
    if (pAxis(1) > 0 && pAxis(2) > 0)
        rotate(el, [-pAxis(2), pAxis(1), 0], -vecRot, transpose(uMean))
    else
        rotate(el, [-pAxis(2), pAxis(1), 0], vecRot, transpose(uMean))
    end
end