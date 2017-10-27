function latlon = mirrorball2latlon( mirrorball_hdr )
    [h,w,d] = size(mirrorball_hdr);
    assert(h==w,'Mirror ball image must be square!');
    assert(mod(h,2)~=0, 'Mirror ball image size must be odd!');
    
    % Viewing vector constant for every pixel
    V = zeros(h,h,3);
    R = zeros(h,h,3);
    V(:,:,3) = ones(h);
    
    % Normal vector for every pixel of mirror ball
    N = zeros(h,h,3);
    for i=1:h
        for j=1:h
            numer = j-int16(h/2);
            denom = int16(h/2)-1;
            
            x = double(numer)/double(denom);
            %x = double((j-int16(h/2))/(int16(h/2)-1));
            
            numer = int16(h/2)-i;
            y = double(numer)/double(denom);
            %y = double((int16(h/2)-i)/(int16(h/2)-1));
            
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
    
    R = V - 2 .* dot(V,N) .* N;
    disp(R);
    figure(3);
    imagesc(N(:,:,3));
    %Create equirectangular (latitude-longitude) image here
end
