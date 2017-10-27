function latlon = mirrorball2latlon( mirrorball_hdr )
    [h,w,d] = size(mirrorball_hdr);
    assert(h==w,'Mirror ball image must be square!');
    assert(mod(h,2)~=0, 'Mirror ball image size must be odd!');
    
    % Viewing vector constant for every pixel
    V = zeros(h,h,3);
    R = zeros(h,h,3);
    phitheta = zeros(h,h,3);
    V(:,:,3) = -ones(h);
    
    % Normal vector for every pixel of mirror ball
    N = zeros(h,h,3);
    for i=1:h
        for j=1:h
            x = double(j-int16(h/2))/double(int16(h/2)-1);
            y = double(int16(h/2)-i)/double(int16(h/2)-1);
            A = double(x^2+y^2);
            if A <= 1
                z = sqrt(1-A);
            else
                x=0;
                y=0;
                z=0;
            end
            N(i,j,1) = x;
            N(i,j,2) = y;
            N(i,j,3) = z;
        end
    end
    R = double(V) - 2 .* sum(V.*N, 3).* double(N);
    %scale it because there might be negative values
    Rscale = (R-min(R(:)))/(max(R(:))-min(R(:)));
    %figure(2);
    %imagesc(N);
    %figure(3);
    %imagesc(Rscale);
    
    %% calculate phi and theta from the R vector
    phi = atan2d(R(:,:,2),R(:,:,1));
    theta = acos(R(:,:,3));
    phitheta(:,:,1) = phi;
    phitheta(:,:,2) = theta;
    phithetascale = (phitheta-min(phitheta(:)))/(max(phitheta(:))-min(phitheta(:)));
    figure(4);
    %imshow(phithetascale);
    
    %% calculate mesh grid rn
    [phis, thetas] = meshgrid([pi:pi/360:2*pi 0:pi/360:pi], 0:pi/360:pi);
    [mh, mw] = size(phis);
    equir = zeros(mh, mw,3);
    equir(:,:,1) = phis;    
    equir(:,:,2) = thetas;
    equir_scale = (equir-min(equir(:)))/(max(equir(:))-min(equir(:)));
    
    % required for aesthetic mesh grid tbh
    for i=1:mh
        for j=1:mh
            [equir_scale(i,j+mh,:), equir_scale(i,j,:)] = deal(equir_scale(i,j,:), equir_scale(i,j+mh,:));
        end
    end
    imshow(equir_scale);
    %Create equirectangular (latitude-longitude) image here
end
