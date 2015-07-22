function varargout = ampd(Signal, option)
%AMPD Automatic Multiscale-based Peak Detection
%   INPUTS:
%       Signal [*] - This is a real vector containing the data from the
%                    maxima will be found.
% 
%   OUTPUTS:
%       index     - The indicies of the identified peaks in "Signal".
% 
%   USAGE:
%       [index] = ampd(Signal)
%                 Returns the indicies of local maxima detected in 
%                 'Signal'.
% 
%   REFERENCES:
%       [ 1 ] Scholkmann F., Boss J. and Wolf M. "An Efficient Algorithm 
%             for Automatic Peak Detection in Noisy Periodic and 
%             Quasi-Periodic Signals." Algorithms 2012, 5, 588-603;
%             doi:10.3390/a5040588.
% 
	narginchk(1,2);
    nargoutchk(0,2);

    if ~isvector(Signal) || isscalar(Signal)
        error('Input argument ''Signal'' must be a vector')

    elseif ~isfloat(Signal)
        error('Class of input argument ''Signal'' must be ''double''')

    elseif ~isrow(Signal)
        Signal = Signal';

    end

    time = 1:numel(Signal);

    [fitPolynomial,fitError] = polyfit(time,Signal,1);
    [fitSignal,~] = polyval(fitPolynomial,time,fitError);

    dtrSignal = Signal - fitSignal;

    N = length(dtrSignal);
    L = ceil(N/2.0)-1;

    RNG = RandStream('mt19937ar');
    LSM = 1 + rand(RNG,L,N);
    
    for k=1:L
        m = 1;
        for i=k+2:N-k+1
            if(Signal(i-1)>Signal(i-k-1) && Signal(i-1)>Signal(i+k-1))
                LSM(k,i) = 0;
            end
        end
    end

	G = sum(LSM,2);
    [~,l] = min(G);

    %% TODO : for customizing
    % LSM = LSM(1:l,:);     % Original
    LSM = LSM(l-2:l+2,:);   % Selected range

    S = std(LSM);
    varargout{1} = find(S==0)-1;
    % ADDITIONAL PROCESSING
    switch lower(option)
        case 'ecg'
            dtrPt = dtrSignal(varargout{1})';
            dtrPtIdx        = varargout{1}';
            medPt           = medfilt1(dtrPt, 15);
            diff_ExtPt      = dtrPt - medPt;
            diff_ExtPt_max  = max(diff_ExtPt);
            diff_ExtPt_min  = min(diff_ExtPt);
            diff_ExtPt_thr  = (diff_ExtPt_max - diff_ExtPt_min) * 0.4; % Selected Threshold
            idx__           = find(diff_ExtPt > diff_ExtPt_thr);
            idx_            = dtrPtIdx(idx__);
            pt_             = dtrSignal(idx_)';
            diff_candidate  = [idx_ pt_];
            ret             = findnearmaxpoint(diff_candidate, 10);
            varargout{2}    = ret(:,1)';
        otherwise
                
    end
    
end