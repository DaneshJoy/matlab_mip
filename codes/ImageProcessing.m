%% Medical Image Processing

clear, close, clc

%% Load Images

% Meta
% info = metaImageInfo('../Images/Meta/patient.mhd');
% img = metaImageRead(info);
% info = metaImageInfo('../Images/Meta/liver.mhd');
% mask = metaImageRead(info);

% Analyze
img = analyze75read('../Images/Analyze/patient.hdr');
mask = analyze75read('../Images/Analyze/liver.hdr');

% Normalizing the image is important for further processings
% mat2gray will do the job: convert to double and intensity range between 0 and 1
imgSlice = mat2gray(squeeze(img(:,:,35))); 
maskSlice = logical(squeeze(mask(:,:,35)));

%% Overlay

maskSlice_edge = edge(maskSlice, 'canny'); % calculate mask edge
img_ov1 = imoverlay(imgSlice, maskSlice, 'c'); % Mask on image
img_ov2 = imoverlay(imgSlice, maskSlice_edge); % Mask edge on image

figure
subplot(121)
imshow(img_ov1); title('Mask Overlay')
subplot(122)
imshow(img_ov2); title('Mask Edge Overlay')

%% Thresholding

thresh1 = imgSlice > 0.2;
thresh2 = imgSlice > 0.55 & imgSlice < 0.65;
img_thresh1 = imgSlice .* thresh1;
img_thresh2 = imgSlice .* thresh2;

figure
subplot(321)
imshow(imgSlice); title('Input Image')
subplot(322); imhist(imgSlice); axis([0 1 0 3000])
subplot(323)
imshow(img_thresh1); title('img > 0.2')
subplot(324); imhist(img_thresh1); axis([0 1 0 3000])
subplot(325)
imshow(img_thresh2); title('0.52 < img < 0.55')
subplot(326); imhist(img_thresh2); axis([0 1 0 3000])

%% Histogram Equalization

img = imgSlice;
img_eq = histeq(img);
% output of imfuse is uint8 so we use mat2gray again
img_diff = mat2gray(imfuse(img,img_eq,'diff'));
img_blend = mat2gray(imfuse(img,img_eq,'blend'));

figure
subplot(221)
imshow(img); title('Input Image')
subplot(222)
imshow(img_eq); title('Histogram Equalized Image')
subplot(223)
imshow(img_diff); title('Difference')
subplot(224)
imshow(img_blend); title('Blend')

% Histogram
figure
subplot(211); 
imhist(img); axis([0 1 0 3000])
title('Image Histogram')
subplot(212); 
imhist(img_eq); axis([0 1 0 3000])
title('Equalized Histogram')



%% Filtering

img = img_diff;
img_movmean = movmean(img, 5); % Moving average filter
img_movmedian = movmedian(img, 5); % Moving median filter
img_gauss = imgaussfilt(img, 1); % 2-D Gaussian filter

figure
subplot(221)
imshow(img(100:256, 1:150)); title('Input Image')
subplot(222)
imshow(img_movmean(100:256, 1:150)); title('Moving mean')
subplot(223)
imshow(img_movmedian(100:256, 1:150)); title('Moving median')
subplot(224)
imshow(img_gauss(100:256, 1:150)); title('Gaussian, \sigma = 1')

