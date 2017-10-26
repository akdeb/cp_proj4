function hdr_naive = makehdr_naive(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light
 
    hdr_naive = zeros(size(ldrs(:,:,:,1)));
    
    for i=1:1:5
       im_r = double(ldrs(:,:,1,i))./exposures(i);
       im_g = double(ldrs(:,:,2,i))./exposures(i);
       im_b = double(ldrs(:,:,3,i))./exposures(i);
       
       hdr_naive(:,:,1) = hdr_naive(:,:,1) + im_r;
       hdr_naive(:,:,2) = hdr_naive(:,:,2) + im_g;
       hdr_naive(:,:,3) = hdr_naive(:,:,3) + im_b;
    end
    
    hdr_naive(:,:,1) = hdr_naive(:,:,1)./5;
    hdr_naive(:,:,2) = hdr_naive(:,:,2)./5;
    hdr_naive(:,:,3) = hdr_naive(:,:,3)./5;
    
    hdr_naive(:,:,1) = (hdr_naive(:,:,1) - min(min(hdr_naive(:,:,1))))/(max(max(hdr_naive(:,:,1))) - min(min(hdr_naive(:,:,1))));
    hdr_naive(:,:,2) = (hdr_naive(:,:,2) - min(min(hdr_naive(:,:,2))))/(max(max(hdr_naive(:,:,2))) - min(min(hdr_naive(:,:,2))));
    hdr_naive(:,:,3) = (hdr_naive(:,:,3) - min(min(hdr_naive(:,:,3))))/(max(max(hdr_naive(:,:,3))) - min(min(hdr_naive(:,:,3))));
    
    hdrwrite(hdr_naive, 'hdr_naive.hdr');
    figure(1), imshow(hdr_naive)
end
