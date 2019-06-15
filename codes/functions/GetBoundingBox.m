function [ROI, ROI_Coordinate] = GetBoundingBox(Image, Mask, pad)

[y, x, z] = ind2sub(size(Mask), find(Mask));

minX = max(1, min(x) - pad);  minY = max(1, min(y) - pad);  minZ = max(1, min(z) - pad); 
maxX = min(size(Mask,2) , max(x) + pad);  maxY = min(size(Mask,1) , max(y) + pad);  maxZ = min(size(Mask,3) , max(z) + pad); 

ROI_Coordinate.minX = minX;  ROI_Coordinate.minY = minY;  ROI_Coordinate.minZ = minZ;
ROI_Coordinate.maxX = maxX;  ROI_Coordinate.maxY = maxY;  ROI_Coordinate.maxZ = maxZ;

ROI = Image(minY:maxY, minX:maxX, minZ:maxZ);
return
