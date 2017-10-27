%starter

im1 = imread('proj4_materials/1.jpg');
im2 = imread('proj4_materials/2.jpg');
im3 = imread('proj4_materials/3.jpg');
im4 = imread('proj4_materials/4.jpg');
im5 = imread('proj4_materials/5.jpg');

im1 = imresize(im1, [375,375],'bilinear');
im2 = imresize(im2, [375,375],'bilinear');
im3 = imresize(im3, [375,375],'bilinear');
im4 = imresize(im4, [375,375],'bilinear');
im5 = imresize(im5, [375,375],'bilinear');

ldrs = cat(4,im1, im2, im3, im4, im5);
x = ones(1,5);
x(1) = 1.0/24.0;
x(2) = 1.0/60.0;
x(3) = 1.0/120.0;
x(4) = 1.0/205.0;
x(5) = 1.0/533.0;
