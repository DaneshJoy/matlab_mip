function [ img, info ] = ReadDicomSeries( prefix, fnum, ext )

%% Read Dicom Series
%----------------------------------------------------------------------
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
  img(:,:,i) = dicomread(fname);
  waitbar((i)/fnum)
end
delete(hWaitBar)

return
end

