function hImage = scalebar(imageName, unitsPerPixel, barSize, units,color,pos)

 % SCALEBAR(imageFile, pixelSize, pixelSize, magnification, units, negative)
 % Adds a scale bar in the lower right-hand corner of an image in the
 % active set of axes. Be sure that your whole scale bar fits within the
 % image width (minus 10%). It should not touch the left edge of your
 % image.
 %
 % Required inputs are:
 % imageName : EITHER an image variable name (e.g. foo)
 % OR a file path and filename (e.g. ~/foo.png)
 % pixelSize (float) : the actual size of a camera pixel (e.g. 7.4)
 % magnification (float) : the microscope magnification (e.g. 40)
 % barScale (float) : bar size in image units (e.g. 100)
 % units (string) : the units of the image (e.g. micron)
 %
 % Adapted from SFNagle 2015 v1

% read in the image and display
 if ischar(imageName)
 image1 = imread(imageName);
 else
 image1 = imageName;
 end
 figure
 hImage = imshow(image1,[],'Border','tight');
 % plot a scale bar in black first
 scaleBarWidth = floor( 1/(unitsPerPixel) * barSize);
 scaleBarHeight = 5;
 if pos == 1
 xPos = size(image1,2)*0.92 - scaleBarWidth;
 else
 xPos = size(image1,2)*0.08;
 end
 yPos = size(image1,1)*0.92 - scaleBarHeight;
 textCenterX = xPos + floor(scaleBarWidth/2);
 textCenterY = yPos + scaleBarHeight*4;
 rectPosition = [xPos, yPos, scaleBarWidth, scaleBarHeight];
 hRect = rectangle('Position', rectPosition);
 set(hRect,'EdgeColor',color,...
 'FaceColor',color);
 % label the scale bar
 str = sprintf(['%4d ' units], barSize);
 hText = text(textCenterX,textCenterY,str);
 set(hText,'HorizontalAlignment','center',...
 'FontSize',20,...
 'FontWeight','bold',...
 'Color',color);
 end
            