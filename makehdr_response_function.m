function makehdr_response_function(ldrs,exposures)

    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light
    
    w = @(z)double(128-abs(128-z));
    lambda = 100;
    exposures = log(exposures);
    
    rows = randperm(size(ldrs(:,:,:,1),1), 100);
    cols = randperm(size(ldrs(:,:,:,1),2), 100);
    
    Zr = zeros(size(ldrs(:,:,:,1),1)*size(ldrs(:,:,:,1),2), 5);
    Zg = zeros(size(ldrs(:,:,:,1),1)*size(ldrs(:,:,:,1),2), 5);
    Zb = zeros(size(ldrs(:,:,:,1),1)*size(ldrs(:,:,:,1),2), 5);
    
    for k = 1:1:5
        p = 1;
        for i=1:1:size(ldrs(:,:,:,1),1)
            for j=1:1:size(ldrs(:,:,:,1),2)
                Zr(p,k) = ldrs(j,i,1,k);
                Zg(p,k) = ldrs(j,i,2,k);
                Zb(p,k) = ldrs(j,i,3,k);
                p=p+1;
            end
        end
    end
    
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
    
    hdr_response = zeros(size(ldrs(:,:,:,1)));
    for i=1:1:5 
        E_r = sum(Zr(:,i)).*(g_r(Zr(:,i)+1)-exposures(i))./sum(Zr(:,i));
        E_g = sum(Zg(:,i)).*(g_g(Zg(:,i)+1)-exposures(i))./sum(Zg(:,i));
        E_b = sum(Zb(:,i)).*(g_b(Zb(:,i)+1)-exposures(i))./sum(Zb(:,i));       

        hdr_response(:,:,1) = hdr_response(:,:,1) + reshape(E_r, [size(ldrs(:,:,:,1),1),size(ldrs(:,:,:,1),2)]);
        hdr_response(:,:,2) = hdr_response(:,:,2) + reshape(E_g, [size(ldrs(:,:,:,1),1),size(ldrs(:,:,:,1),2)]);
        hdr_response(:,:,3) = hdr_response(:,:,3) + reshape(E_b, [size(ldrs(:,:,:,1),1),size(ldrs(:,:,:,1),2)]);
    end
    
    hdr_response(:,:,1) = hdr_response(:,:,1)./5;
    hdr_response(:,:,2) = hdr_response(:,:,2)./5;
    hdr_response(:,:,3) = hdr_response(:,:,3)./5;
    
    hdrwrite(hdr_response, 'hdr_response.hdr');
    
%     hdr_response(:,:,1) = (hdr_response(:,:,1) - min(min(hdr_response(:,:,1))))/(max(max(hdr_response(:,:,1))) - min(min(hdr_response(:,:,1))));
%     hdr_response(:,:,2) = (hdr_response(:,:,2) - min(min(hdr_response(:,:,2))))/(max(max(hdr_response(:,:,2))) - min(min(hdr_response(:,:,2))));
%     hdr_response(:,:,3) = (hdr_response(:,:,3) - min(min(hdr_response(:,:,3))))/(max(max(hdr_response(:,:,3))) - min(min(hdr_response(:,:,3))));
    
    figure(1), imshow(tonemap(hdr_response))
    
    figure(3), plot(1:255, g_r(1:255))
    figure(4), plot(1:255, g_g(1:255))
    figure(5), plot(1:255, g_b(1:255))
end
