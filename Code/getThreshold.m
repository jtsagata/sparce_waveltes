function [threshold] = getThreshold(channel, level)
    n = size(channel,1);

    % Mask the image part
    channel(1:n/(2^level), 1:n/(2^level)) = intmax;
    
    % Covert to vector
    channel=channel(:);
    
    % Remove the image part from vector
    channel(channel==intmax) = [];
    
    % Calculate the Threshold
    sigma=median(abs(channel(:)))/0.6745;
    threshold = 3 * sigma;
end