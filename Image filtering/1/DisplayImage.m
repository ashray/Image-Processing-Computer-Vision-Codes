function [ fig ] = DisplayImage(ImageMat, varargin)
%DISPLAYIMAGE 
% 
% fig = DisplayImage(ImageMat)
% fig = DisplayImage(ImageMat, 'Option', OptionValue ...)
% 
% Displays the image

	withCbar = true;
	withAxes = true;
	ActualSize = true;
	Tag = [];
	nParams = floor(length(varargin)/2);
	for i = 1:nParams
		if strcmpi(varargin{2*i-1}, 'axes')
			withAxes = varargin{2*i};
		elseif strcmpi(varargin{2*i-1}, 'cbar')
			withCbar = varargin{2*i};
		elseif strcmpi(varargin{2*i-1}, 'actualsize')
			ActualSize = varargin{2*i};
		elseif strcmpi(varargin{2*i-1}, 'tag')
			Tag = varargin{2*i};
		end
	end
	
	fig = figure;
	ImgHandle = imshow(ImageMat, 'Border', 'Tight');
	if ~isempty(Tag)
		set(ImgHandle, 'Tag', Tag);
	end
	
	if ndims(ImageMat) == 2 && withCbar
		colorbar;
	end
	h = gca();
	if withAxes
		set(h, 'Visible', 'on');
	end
	if ActualSize
		set(fig, 'Units', 'pixels');
		set(fig, 'Position', [0, 50, size(ImageMat, 2) + 125, size(ImageMat, 1) + 100]);
		set(h, 'Units', 'pixels');
		set(h, 'Position', [50 50 size(ImageMat, 2) size(ImageMat, 1)]);
	end

end

