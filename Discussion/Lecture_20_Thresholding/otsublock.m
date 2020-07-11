function out = otsublock(I)
%GRAYTHRESH Global image threshold using Otsu's method.
%   LEVEL = GRAYTHRESH(I) computes a global threshold (LEVEL) that can be
%   used to convert an intensity image to a binary image with IMBINARIZE.
%   LEVEL is a normalized intensity value that lies in the range [0, 1].
%   GRAYTHRESH uses Otsu's method, which chooses the threshold to minimize
%   the intraclass variance of the thresholded black and white pixels.
%
%   [LEVEL, EM] = GRAYTHRESH(I) returns effectiveness metric, EM, as the
%   second output argument. It indicates the effectiveness of thresholding
%   of the input image and it is in the range [0, 1]. The lower bound is
%   attainable only by images having a single gray level, and the upper
%   bound is attainable only by two-valued images.
%
%   Class Support
%   -------------
%   The input image I can be uint8, uint16, int16, single, or double, and it
%   must be nonsparse.  LEVEL and EM are double scalars. 
%
%   Example
%   -------
%       I = imread('coins.png');
%       level = graythresh(I);
%       BW = imbinarize(I,level);
%       figure, imshow(BW)
%
%   See also OTSUTHRESH, IMBINARIZE, IMQUANTIZE, MULTITHRESH, RGB2IND.

%   Copyright 1993-2015 The MathWorks, Inc.

% Reference:
% N. Otsu, "A Threshold Selection Method from Gray-Level Histograms,"
% IEEE Transactions on Systems, Man, and Cybernetics, vol. 9, no. 1,
% pp. 62-66, 1979.


if isstruct(I)
    I = I.data;
end

if ~isempty(I)
  % Convert all N-D arrays into a single column.  Convert to uint8 for
  % fastest histogram computation.
  im = I;
  I = im2uint8(I(:));
  num_bins = 256;
  counts = imhist(I,num_bins);
 % Variable name are chosen to be similar to the formations in the Otsu
  % paper
  p  = counts/ sum(counts);
  omega = cumsum(p);
  mu = cumsum(p.*(1:num_bins)');
  mu_t = mu(end);
  
  previous_state = warning('off','Matlab:dividedByZero');
  sigma_b_squared = (mu_t*omega-mu).^2./omega.* mu_t;
  warning(previous_state);
  
  
  % find the location of the maximum value of sigma_b_square
  % The maximum may extend over several bins, so avearge  may at different
  % locations. If maxval is NaN, meaning that sigma_b_square is none,
  % return .
  maxval = max(sigma_b_squared);
  isfinite_maxval = isfinite(maxval);
  if isfinite_maxval
      idx = mean(find(sigma_b_squared == maxval));    
      level = (idx - 1)/(num_bins - 1);
  else
      level = 0.0;
  end
else
    level = 0.0;
end

% Compute the effectiveness metric
if nargout > 1
    if isfinite_maxval
        em = maxval/(sum(p.*((1:num_bins).^2)') - mu_t^2);
    else
        em = 0;
    end
end

out = (im >  level*max(im(:)));
disp(['Threshold = ',num2str(round(255*level))]);

