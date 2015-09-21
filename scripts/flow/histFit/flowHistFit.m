function flowHistFit
close all
% Testing Andrew Fitzgibbon's idea

%  first import some data

z = csvread('../../../data/saccs/Clarke2013saccs.txt');

%  transform to 20x15 space (or whatever)
z(:,1) = z(:,1) + 1;
z(:,2) = z(:,2) + 0.75;
z(:,3) = z(:,3) + 1;
z(:,4) = z(:,4) + 0.75;

sf = 10;
z = ceil(sf*z);
z(z(:)==0) = 1;

n1 = 2*sf; n2 = 1.5*sf;

z = z(1:100,:);

nHist = 5;

x0 = rand(nHist*n1*n2*2,1);
x0 = x0(:);

p.nHist = nHist;
p.n1 = n1;
p.n2 = n2;

options = optimoptions(@fminunc, 'PlotFcns', 'optimplotx', 'Display', 'iter');
 x = fmincon(@(x)getHistLik(z,x, p), x0, [],[], [], [], eps*ones(1, nHist*n1*n2*2), ones(1, nHist*n1*n2*2), [], options);
% x = fminunc(@(x)getHistLik(z,x, p), x0, options);
figure
for h = 1:p.nHist
    a = 1+(h-1)*p.n1*p.n2;
    b = h*p.n1*p.n2;
    H(:,:,h) = reshape(x(a:b), [p.n1, p.n2]);
    subplot(1, p.nHist, h)
    imshow(imresize(H(:,:,h)', 50, 'nearest'), []);
end

figure
for m = 1:p.nHist
    a = 1+(h+m-1)*p.n1*p.n2;
    b = (h+m)*p.n1*p.n2;
    H(:,:,h) = reshape(x(a:b), [p.n1, p.n2]);
    subplot(1, p.nHist, m)
    imshow(imresize(H(:,:,h)', 50, 'nearest'), []);
end

end


function J = getHistLik(z, x, p)
%  first unpack maps and hists
for h = 1:p.nHist
    a = 1+(h-1)*p.n1*p.n2;
    b = h*p.n1*p.n2;
    H(:,:,h) = reshape(x(a:b), [p.n1, p.n2]);
end
for m = 1:p.nHist
    a = 1+(h+m-1)*p.n1*p.n2;
    b = (h+m)*p.n1*p.n2;
    W(m,:,:) = reshape(x(a:b), [p.n1, p.n2]);
end
clear h m

J = 0;
for f = 1:length(z)
    % get weight of basis histograms for saccade starting at (z(f,1),
    % z(f,2))
    w = W(:, z(f,1), z(f,2));
    % combine basis hists to get custom hist for saccade start point
    fixdist = zeros(p.n1, p.n2);
    for h=1:p.nHist
        fixdist = fixdist + w(h) * H(:,:,h);
    end   
    
    % penalise for having sum(fixdist!=1)
    fixdistSumPenalty = abs(sum(fixdist(:))-1);
    % penalise for having values outside (0,1)
    fixdistRange = sum(fixdist(:)<=0) + sum(fixdist(:)>1);
    
    % now scale fixdist so all values are positive
    fixdist = fixdist + min(fixdist(:));
    
    % calcualte loglik of saccade endpoint given this point
    loglik = log(fixdist(z(f,3), z(f,4)));
        
    % add to cost function
    J = J - loglik + fixdistSumPenalty + fixdistRange;
end


end