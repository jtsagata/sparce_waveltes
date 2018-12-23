function [new_signal,new_level] = wsplit1D(signal,level,hi_kernel,lo_kernel)
    signal=signal(:);
    signal=signal';
    
    L=size(signal,2);
    
    new_signal=signal;
    new_level = level +1;
    
    last_index = L /(2^level);
    work_signal = new_signal(1:last_index);
    
    h_sig=pconv(hi_kernel,work_signal);
    l_sig=pconv(lo_kernel,work_signal);
    
    h_sig=h_sig(1:2:end);
    l_sig=l_sig(1:2:end);
    
    comp = [l_sig h_sig];
    new_signal(1:last_index) = comp;
end

