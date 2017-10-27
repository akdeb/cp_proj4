function log_radiance(ldrs)
    for i=1:5
        figure(i), imshow(tonemap(exp(log(im2double(ldrs(:,:,:,i))))))
    end
end