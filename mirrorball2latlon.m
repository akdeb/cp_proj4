function latlon = mirrorball2latlon( mirrorball_hdr )
    [h,w,d] = size(mirrorball_hdr);
    assert(h==w,'Mirror ball image must be square!');
    assert(mod(h,2)~=0, 'Mirror ball image size must be odd!');
    
    % Viewing vector constant for every pixel
    N = zeros(h,h,3);
    R = zeros(h,h,3);
    mid = floor(h/2);
    phitheta = zeros(h,h,3);
    count =0;
    
    % Normal vector for every pixel of mirror ball
    for i=1:h
        for j=1:h
            nx = (j - mid) / mid;
            ny = (i - mid) / mid;
            if 1 - nx^2 - ny^2 < 0
                nx = 0;
                ny = 0;
                nz = 0;
                N(i,j,:) = [0,0,0];
            else
                nz = sqrt(1 - nx^2 - ny^2);
                N(i,j,:) = [nx,ny,nz];
            end
            
            if nx == 0 && ny == 0 && nz == 0
                R(i,j,:) = [0,0,0];
            else
                V = [0; 0; -1];
                n = [nx,ny,nz];
                r = V - 2 * n * V * n.';
                R(i,j,1) = r(1, 1) / norm(r);
                R(i,j,2) = r(2, 1) / norm(r);
                R(i,j,3) = r(3, 1) / norm(r);
                count = count + 1;
            end
        end
    end
    figure(1), imshow(N)
    Rscale = (R-min(R(:)))/(max(R(:))-min(R(:)));
    for i=1:h
        for j=1:h
            nx = (j - mid) / mid;
            ny = (i - mid) / mid;
            if 1 - nx^2 - ny^2 < 0
                Rscale(i,j,:) = [0,0,0];
            end
        end
    end
    
    figure(2), imshow(Rscale)
    
    %% calculate phi and theta from the R vector
    phi = atan2(R(:,:,1),(-1*R(:,:,3)));
    theta = acos(-1*R(:,:,2));
    phitheta(:,:,1) = phi + pi;
    phitheta(:,:,2) = theta;
    phithetascale = (phitheta-min(phitheta(:)))/(max(phitheta(:))-min(phitheta(:)));
    
    for i=1:h
        for j=1:h
            nx = (j - mid) / mid;
            ny = (i - mid) / mid;
            if 1 - nx^2 - ny^2 < 0
                phitheta(i,j,:) = [0,0,0];
                phithetascale(i,j,:) = [0,0,0];
            end
        end
    end
    figure(3), imshow(phithetascale)
    
    %% calculate mesh grid rn
    [phis, thetas] = meshgrid(0:pi/360:2*pi, 0:pi/360:pi);
    [mh, mw] = size(phis);
    equir = zeros(mh, mw,3);
    equir(:,:,1) = phis;    
    equir(:,:,2) = thetas;
    equir_scale = (equir-min(equir(:)))/(max(equir(:))-min(equir(:)));
  
    figure(4), imshow(equir_scale)
    %% plot
    
    X = zeros(count, 1);
    Y = zeros(count, 1);
    R = zeros(count, 1);
    G = zeros(count, 1);
    B = zeros(count, 1);
    
    k = 1;
    for i = 1:h
        for j = 1:h
            if phitheta(i, j, 1) == 0 && phitheta(i, j, 2) == 0
                continue;
            end
            X(k, 1) = phitheta(i, j, 1);
            Y(k, 1) = phitheta(i, j, 2);
            R(k, 1) = mirrorball_hdr(i, j, 1);
            G(k, 1) = mirrorball_hdr(i, j, 2);
            B(k, 1) = mirrorball_hdr(i, j, 3);
            k = k + 1;
        end
    end
    
    Fr = scatteredInterpolant(X, Y, R);
    Fg = scatteredInterpolant(X, Y, G);
    Fb = scatteredInterpolant(X, Y, B);
    
    Qr = Fr(phis, thetas);
    Qg = Fg(phis, thetas);
    Qb = Fb(phis, thetas);
    
    Q = cat(3, Qr, Qg, Qb);
    Q(Q < 0) = 0;
    latlon = Q;
    
    figure(5), imshow(tonemap(latlon))
end
