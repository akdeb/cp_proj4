function makehdr_response_function(ldrs,exposures)

    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light
    
    w = @(z)double(128-abs(128-z));
    lambda = 1;
    
    rows = randperm(size(ldrs(:,:,:,1),1), 100);
    cols = randperm(size(ldrs(:,:,:,1),2), 100);
    
    Z_r = zeros(100,5);
    Z_g = zeros(100,5);
    Z_b = zeros(100,5);
     
    for i=1:1:5
        for j=1:1:100
            Z_r(j,i) = ldrs(rows(j),cols(j),1,i);
            Z_g(j,i) = ldrs(rows(j),cols(j),2,i);
            Z_b(j,i) = ldrs(rows(j),cols(j),3,i);
        end
    end
    
    [g_r,IE] = gsolve(Z_r, exposures, lambda, w);
    [g_g,IE] = gsolve(Z_g, exposures, lambda, w);
    [g_b,IE] = gsolve(Z_b, exposures, lambda, w);
    
    for i=1:1:5
        denom_r = 0;
        denom_g = 0;
        denom_b = 0;
        E = zeros(size(ldrs(:,:,:,1)));
        for j=1:1:100
            E(:,:,1,i) = w(Z_r(j,i))*(g_r(j,i) - log(exposures(j)));
            E(:,:,2,i) = w(Z_g(j,i))*(g_g(j,i) - log(exposures(j)));
            E(:,:,3,i) = w(Z_b(j,i))*(g_b(j,i) - log(exposures(j)));
            denom_r = denom_r + Z_r(j,i);
            denom_g = denom_g + Z_g(j,i);
            denom_b = denom_b + Z_b(j,i);
        end
    end
    E_r = exp(sum(w(Z_r).*(g_r - log(exposures)))/sum(w(Z_r)));
    
    E_r
    figure(3), plot(1:255, 10.^g_r(1:255))
    figure(4), plot(1:255, g_g(1:255))
    figure(5), plot(1:255, g_b(1:255))
end
