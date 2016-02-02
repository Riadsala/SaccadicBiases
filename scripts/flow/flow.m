
function llmap = getFlowMap(fx, fy)

fid = fopen('models/ALL_flowModels_0.05.txt');
% column names
txt = textscan(fid, '%s',1);
% normal model
txt = textscan(fid, '%s %s %s %s %f %f',80, 'Delimiter', ',', 'Whitespace', '"');
% truncated normal model
txt = textscan(fid, '%s %s %s %s %f %f',80, 'Delimiter', ',', 'Whitespace', '"');
fclose(fid);



flow_params = getFlowParams(fx,fy,txt);

mu = [flow_params(1), flow_params(2)];
sigma = [flow_params(3), flow_params(4); flow_params(4) flow_params(5)];

q = 0.05;
X = -1:q:1;
Y = 0.75:-q:-0.75;
ii = 0;
for x = X
    ii = ii + 1;
    jj = 0;
    for y = Y
        jj = jj + 1;
        
        llmap(jj, ii) = tmvnpdf([x, y], mu, sigma, [-1 -.75], [1 0.75]);
        
    end
end
sum(exp(llmap(:)))
% llmap(find(Y==fy), find(fx==X)) = 0;
llmap_large = imresize(llmap, 5);

imshow(llmap_large, []);



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