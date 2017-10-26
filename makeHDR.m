function hdr_over_under = makeHDR(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light
 
    hdr_over_under = zeros(size(ldrs(:,:,:,1)));
    
    %LDR Mergin without under and over exposed regions
    w = @(z)double(128-abs(z-128));
    
    for i=1:1:5
       im_r = w(ldrs(:,:,1,i));
       im_g = w(ldrs(:,:,2,i));
       im_b = w(ldrs(:,:,3,i));
      
       im_r = double(im_r)./exposures(i);
       im_g = double(im_g)./exposures(i);
       im_b = double(im_b)./exposures(i);
       
       hdr_over_under(:,:,1) = hdr_over_under(:,:,1) + im_r;
       hdr_over_under(:,:,2) = hdr_over_under(:,:,2) + im_g;
       hdr_over_under(:,:,3) = hdr_over_under(:,:,3) + im_b;
    end
    
    hdr_over_under(:,:,1) = hdr_over_under(:,:,1)./5;
    hdr_over_under(:,:,2) = hdr_over_under(:,:,2)./5;
    hdr_over_under(:,:,3) = hdr_over_under(:,:,3)./5;
    
    hdr_over_under(:,:,1) = (hdr_over_under(:,:,1) - min(min(hdr_over_under(:,:,1))))/(max(max(hdr_over_under(:,:,1))) - min(min(hdr_over_under(:,:,1))));
    hdr_over_under(:,:,2) = (hdr_over_under(:,:,2) - min(min(hdr_over_under(:,:,2))))/(max(max(hdr_over_under(:,:,2))) - min(min(hdr_over_under(:,:,2))));
    hdr_over_under(:,:,3) = (hdr_over_under(:,:,3) - min(min(hdr_over_under(:,:,3))))/(max(max(hdr_over_under(:,:,3))) - min(min(hdr_over_under(:,:,3))));
    
    hdrwrite(hdr_over_under, 'hdr-2.hdr');
    figure(2), imagesc(hdr_over_under)
    
    %LDR Merging with response function estimation
    rows = randperm(size(ldrs(:,:,:,1),1), 100);
    cols = randperm(size(ldrs(:,:,:,1),2), 100);
    
    Z_r = zeros(100,5);
    Z_g = zeros(100,5);
    Z_b = zeros(100,5);
    
    lambda = 1;
    
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
        
end
