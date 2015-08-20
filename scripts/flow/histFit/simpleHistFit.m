function simpleHistFit
close all
% Testing Andrew Fitzgibbon's idea

%  first import some data

fix = csvread('../saccs/Clarke2013saccs.txt');
z = fix(:,3:4);
%  transform to 20x15 space
z(:,1) = z(:,1) + 1;
z(:,2) = z(:,2) + 0.75;
z = ceil(20*z);
z(z(:)==0) = 1;
n1 = 40; n2 = 30;
z = z(1:10000,:);
x0 = rand(n1,n2); x0 = x0./sum(x0(:));
x0 = x0(:);

options = optimoptions(@fmincon, 'PlotFcns', 'optimplotx', 'Display', 'iter');
x = fmincon(@(x)getHistLik(z,x), x0, [],[], ones(1, n1*n2), 1, eps*ones(1, n1*n2), ones(1, n1*n2), [], options);
x = reshape(x, [n1,n2]);
figure
 imshow(imresize(x', 5, 'nearest'),[])
end

function loglik = getHistLik(z, x)

lambda = 0;
x = log(x);
x = reshape(x, [40,30]);
J = abs(2*x(2:end, 2:end) - x(1:(end-1), 2:end) - x(2:end, 1:(end-1)));
loglik = -sum(sum(x(z(:,1), z(:,2)))) + lambda*sum(J(:));

end
