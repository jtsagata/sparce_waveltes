function [result,TVEnergy] = ImpaintingPrimalDual(y,NumFrames,sigma, tau, theta, Phi)

    % Functors
    K = @(f) grad(f);
    KS = @(u) - div(u);
    Amplitude = @(u) sqrt(sum(u.^2,3));
    F = @(u) sum(sum(Amplitude(u)));

    ProxF  = @(u,lambda) max(0, 1-lambda./repmat(Amplitude(u), [1 1 2])).*u;
    ProxFS = @(y,sigma) y - sigma*ProxF(y/sigma,1/sigma);
    ProxG  = @(f,tau) f + Phi(y -Phi(f));

    
    f=y;
    g=K(y)*0;
    f1=f;
    

    TVEnergy=zeros(NumFrames,1);
    TVEnergy(1) =  F(K(f1));
    for ii=2:NumFrames
        % Iteration
        fold = f;
        g = ProxFS( g+sigma*K(f1), sigma);
        f = ProxG(f-tau*KS(g), tau);
        f1 = f + theta * (f-fold);
    
        TVEnergy(ii) = F(K(f1));    
        f= f1;
    end
    
    result = f1;
end

