function weight = under_over_merge(z)
    w = @(z) double(128 - abs(z-128));
    weight = w(z);
end