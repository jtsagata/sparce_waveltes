function [tmin,tmax] = image_range(img)
    tmax = max(max(img(:)));
    tmin = min(min(img(:)));
end

