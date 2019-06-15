clear all      %no variables
close all   %no figures
clc         %empty command window

%% Read Dicom Series
%----------------------------------------------------------------------
prefix = '../images/DICOM/liver/image_';
fnum = 128;
ext = '';

%first filename in series
fname = [prefix num2str(0) ext];

%read file header
info = dicominfo(fname);

%extract spacing info from metadata
voxel_size = [info.PixelSpacing; info.SliceThickness];

%extract size info from metadata
size = [info.Rows info.Columns fnum];

%initialize img
img = zeros(size);

%read slice images
hWaitBar = waitbar(0,'Reading DICOM files');
for i=1:fnum
  fname = [prefix num2str(i-1) ext];
  img(:,:,i) = int16(dicomread(fname));
  waitbar((i)/fnum)
end
delete(hWaitBar)

%% Visualization
%----------------------------------------------------------------------
i = 60;  
im = squeeze(img(:,:,i)); %axial slice

%default colormap: gray
figure
imshow(im, []);

%add title
title(['Axial Slice #' num2str(i)]);

%add intensity legend
colorbar

%change colormap
figure
imshow(im, [], 'Colormap', jet);
title(['Axial Slice #' num2str(i)]);
colorbar

%% Write slices to new folder
%----------------------------------------------------------------------
new_prefix = '../images/DICOM/liver2/image_';
ext = '.dcm';

% Create new directory
mkdir('../Images/DICOM/liver2/')

%write slice images
hWaitBar = waitbar(0,'Writing DICOM files');
for i=1:fnum
  fname = [new_prefix num2str(i-1) ext];
  slice = squeeze(img(:,:,i));
  dicomwrite(slice, fname, info);
  waitbar((i)/fnum)
end
delete(hWaitBar)
