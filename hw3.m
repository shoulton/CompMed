% deform image I to match J
% regularization energy is \|Lv\|^2_{L_2}/2, L = Id - alpha^2 Laplacian,
% matching energy is \|I(phiinv) - J\|^2_{L_2}/2/sigma^2 for phiinv(x) = x - vx 
% optimization using gradient descent with stepsize epsilon for nIter steps
% energy gradient is -(I(x - v) - J(x))nabla(I)(x - v)
function [] = hw3()
I =  double(imread('Con.png') > 0);
J =  double(imread('Alz.png') > 0);
[ID, bx, by] = translateImage(I, J, .05, 20);
imwrite(ID, "translatedImage.png");
fprintf("[%d, %d]", bx, by);
figure;
subplot(2,2,1),imshow(I), title("Template");
subplot(2,2,2), imshow(ID), title("Translated");
subplot(2,2,3), imshow(J), title("Target");

figure;
subplot(2,2,1),imshow(I - J), title("Template - Target"), colorbar;
subplot(2,2,2), imshow(ID - J), title("Translated - Target"), colorbar;


function [ID,bx,by] = translateImage(I,J,epsilon,nIter)
% initialize velocity field
bx = 1;
by = 1;
file = fopen('translatefile.txt', 'w');
for i = 1 : nIter
    % deform image 
    ID = applyVToImage(I,bx,by);
    % energy (cost function)
    
    E = sum(sum((ID-J).^2))/2;
    
    % I had to use matlab online, so I put the output because the outputs
    % are too much to process online
    fprintf(file, 'Iter %d of %d, energy is %g, bx is %d, by is %d\n',i, nIter, E, bx, by);
   
    newImg = ID - J
    %imshow(newImg)
    % gradient of I
    [gradIx,gradIy] = gradient(ID - J);
    %imshow(gradIx)
    % energy gradient
    gradx = max(max(gradIx));
    grady = max(max(gradIy));
    % update velocity
    bx = bx - gradx*epsilon;
    by = by - grady*epsilon;
end
fclose(file);

function ID = applyVToImage(I,bx,by)
% deform image by composing with x-v (interpolating at specified points)
[X,Y] = meshgrid(1:size(I,2),1:size(I,1));
ID = interp2(I,X-bx,Y-by,'linear',0);
