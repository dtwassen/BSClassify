function [r2vals] = anaR2( datx, daty )
%% Compute R2-values after Pearson
%
%  input:   datx [trials 1..n x channels 1..ch x samples 1..i], 
%           daty [labels 1..n]
%  output:  r2vals [1..ch, 1..i]

% init
r2vals = zeros(size(datx,2), size(datx,3));
% check daty orientation and possibly correct
if size(datx,1) == length(daty) & size(datx,1) ~= size(daty,1)
    daty = daty';
end
% compute R-values
for ch=1:size(r2vals,1)
    for bin=1:size(r2vals,2)
        [r2vals(ch,bin),p]=corr(datx(:,ch,bin),daty);
    end
end
% squaring
r2vals = r2vals.^2;
end