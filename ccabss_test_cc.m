function [Y,W,r] = ccabss_test_cc(X)
% CCABSS -  Blind Source Separation by Canonical Correlation Analysis
%
% Y = CCABSS(X) is the BSS of X=A*S
% S is a set of unknown source signals and A is an unknown mixing matrix
% The components in S are supposed to be independent
% Y is an estimate of S appart from permutation and scaling
% For mixed 1-D signals, X is 2-D
% The first index refer to the different components and the second index refers to the signal parameter
%
% [Y W] = CCABSS(X) also gives the 'de-mixing' matrix W, such that Y = W'*X.
%
% © 2000 Magnus Borga

A = X(:,2:end-1); % correlation with delayed version of itself
B = conv2(X,[1 0 1],'valid'); % Temporal correlation

[Wa, ~, r] = cc(A,B); % CCA
Y = Wa'*X;

if nargout > 1
  W = Wa;
end

end