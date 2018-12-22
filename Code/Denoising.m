function [wave_image, dsnr] = Denoising(signal,level, Ho, theshold_type)

    % Do Wavelet composition
    wcR=fwt_or_2d(0, signal(:,:,1), level, Ho);
    wcG=fwt_or_2d(0, signal(:,:,2), level, Ho);
    wcB=fwt_or_2d(0, signal(:,:,3), level, Ho);
    
     % Apply Thresholding
    wcR_t = perform_thresholding(wcR, getThreshold(wcR,level),theshold_type);
    wcG_t = perform_thresholding(wcG, getThreshold(wcG,level),theshold_type);
    wcB_t = perform_thresholding(wcB, getThreshold(wcB,level),theshold_type);
    
    % Do Wavelet decomposition
    f_Rc=fwt_or_2d(1,wcR_t,level,Ho);
    f_Gc=fwt_or_2d(1,wcG_t,level,Ho);
    f_Bc=fwt_or_2d(1,wcB_t,level,Ho);
    wave_image = cat(3, f_Rc , f_Gc , f_Bc);

    dsnr = snr(signal, wave_image);
end

