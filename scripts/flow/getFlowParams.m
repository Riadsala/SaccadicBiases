function tN_params = getFlowParams(x,y, txt)


all_coefs = txt{6};
paramNames = txt{3};

uniqueNames = unique(paramNames);
for p = 1:5
    
    idx = strcmp(uniqueNames{p}, paramNames);
    
    v = [1, y, x, x^2, x^3, x^4, y^2, y^3, y^4, x*y, y*x^2, y*x^3, y*x^4, x*y^2, x*y^3, x*y^4];
    
    coefs = all_coefs(idx);
    
    tN_params(p) = v*coefs;
    
end