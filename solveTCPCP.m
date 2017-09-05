addpath(genpath(cd))
clear
% read image
I = double(imread('./image/testimg.jpg'));
X = I/255;
X = X(1:10,1:10,:);
dim = size(X);

noise = 0; % 1 for "add noise", 0 for "no noise" on observations
lambda = 1; % lambda in "||L||_* + \lambda ||S||_1"

opts.mu = 1e-3;
opts.tol = 1e-6;
opts.rho = 1.2;
opts.max_iter = 100;
opts.DEBUG = 1;

%% Sampling
% q: int, the number of sampled obeservations
q = floor(0.5*numel(X));
% Gauss sampling matrix GM
GM = randn(q,numel(X));
g = GM*X(:); % sample

%% Noise
if noise == 1
    g = g+ones(q,1).*(0.01*max(abs(g))*normrnd(0,1,[q,1]));
end

%% slove TCPCP
tic
[L, S, obj, err, iter] = tcpcp(dim,g,GM,lambda,opts);
toc

maxP = max(abs(X(:)));

figure(1)
subplot(1,3,1)
imshow(X/maxP)% original picture
subplot(1,3,2)
imshow(L/maxP)% L solved by TCPCP
subplot(1,3,3)
imshow(S/maxP)% S solved by TCPCP