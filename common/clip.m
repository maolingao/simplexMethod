function clippedIm = clip(im,tolDown,tolUp)

clippedIm = im;
clippedIm(im < tolDown) = tolDown;
clippedIm(im > tolUp) = tolUp;


end
