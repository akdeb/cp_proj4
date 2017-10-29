function latlon = mirrorball2latlon( mirrorball_hdr )
    [h,w,d] = size(mirrorball_hdr);
    assert(h==w,'Mirror ball image must be square!');
    assert(mod(h,2)~=0, 'Mirror ball image size must be odd!');
    
    % Viewing vector constant for every pixel
    V = zeros(h,h,3);
    R = zeros(h,h,3);
    phitheta = zeros(h,h,3);
    V(:,:,3) = -1*ones(h);
    
    % Normal vector for every pixel of mirror ball
    N = zeros(h,h,3);
    [N(:,:,1), N(:,:,2)] = meshgrid(-1:2/(h-1):1, -1:2/(h-1):1);
    A = N(:,:,1).^2 + N(:,:,2).^2;
    
    for i=1:h
        for j=1:h
            if A(i,j)>1
                N(i,j,:) = [0,0,0];
            else
                N(i,j,3) = sqrt(1-A(i,j));
            end
        end
    end
    %figure(1);
    %imagesc(N);
    R = double(V) - 2 .* double(sum(V.*N, 3)) .* double(N);
    %scale it because there might be negative values
    Rscale = (R-min(R(:)))/(max(R(:))-min(R(:)));
    %figure(3);
    %imagesc(Rscale);
    
    %% calculate phi and theta from the R vector
    phi = atan2(R(:,:,2),R(:,:,1));
    theta = asin(R(:,:,3));
    phitheta(:,:,1) = phi;
    phitheta(:,:,2) = theta;
    phithetascale = (phitheta-min(phitheta(:)))/(max(phitheta(:))-min(phitheta(:)));
    figure(4);
    imshow(phithetascale);
    
    %% calculate mesh grid rn
    [phis, thetas] = meshgrid([pi:pi/360:2*pi 0:pi/360:pi], 0:pi/360:pi);
    [mh, mw] = size(phis);
    equir = zeros(mh, mw,3);
    equir(:,:,1) = phis;    
    equir(:,:,2) = thetas;
    equir_scale = (equir-min(equir(:)))/(max(equir(:))-min(equir(:)));
    
    % required for aesthetic mesh grid tbh
    for j=1:mh
        [equir_scale(:,j+mh,:), equir_scale(:,j,:)] = deal(equir_scale(:,j,:), equir_scale(:,j+mh,:));
    end
  
    %figure(5);
    %imshow(equir_scale);
    
    %% plot now
    %{
    for i=1:d
        F = TriScatteredInterp(phi(:), theta(:), mirrorball_hdr(:,:,i));
        latlon(:,:,i) = F(phis, thetas);
    end
    figure(1);
    imshow(latlon);
    %}
    %Create equirectangular (latitude-longitude) image here
end
