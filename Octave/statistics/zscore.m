function [i,v,m] = zscore(i,DIM)
% ZSCORE removes the mean and normalizes the data 
% to a variance of 1. Can be used for Pre-Whitening of the data, too. 
%
% [z,r,m] = zscore(x,DIM)
%   z   z-score of x along dimension DIM
%   r   is the inverse of the standard deviation
%   m   is the mean of x
%
% The data x can be reconstrated with 
%     x = z*diag(1./r) + repmat(m,size(z)./size(m))  
%     z = x*diag(r) - repmat(m.*v,size(z)./size(m))  
%
% DIM dimension
%     1: STATS of columns
%     2: STATS of rows
%     default or []: first DIMENSION, with more than 1 element
%
% see also: SUMSKIPNAN, MEAN, STD, DETREND
%
% REFERENCE(S):
% [1] http://mathworld.wolfram.com/z-Score.html

%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; If not, see <http://www.gnu.org/licenses/>.


%     $Id: zscore.m,v 1.1.1.1 2012/09/05 21:42:41 magnottav Exp $
%     Copyright (C) 2000-2003,2009 by Alois Schloegl <a.schloegl@ieee.org>    
%       This is part of the NaN-toolbox for Octave and Matlab 
%       see also: http://hci.tugraz.at/schloegl/matlab/NaN/       


if any(size(i)==0); return; end;

if nargin<2
        DIM=1; 
end
if isempty(DIM), 
        DIM=min(find(size(i)>1));
        if isempty(DIM), DIM=1; end;
end;


% pre-whitening
m = mean(i,DIM);
i = i-repmat(m,size(i)./size(m));  % remove mean
v = 1./sqrt(mean(i.^2,DIM));
i = i.*repmat(v,size(i)./size(v)); % scale to var=1

