function WriteDicomSeries( img, info, prefix, ext )
    %write slice images
    fnum = size(img,3);
    hWaitBar = waitbar(0,'Writing DICOM files');
    for i=1:fnum
      fname = [prefix num2str(i-1) ext];
      slice = squeeze(img(:,:,i));
      dicomwrite(slice, fname, info);
      waitbar((i)/fnum)
    end
    delete(hWaitBar)
end