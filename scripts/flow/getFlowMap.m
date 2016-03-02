
function llmap_large = getFlowMap(fx, fy)

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

