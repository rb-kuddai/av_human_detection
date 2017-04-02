function value = chisquare( histogram_1,  histogram_2)

% HISTOGRAM_COMPARE compare two histograms distributions using the chi
% squared measure
%
% histogram_1, histogram_2 - the histograms to compare
%
% x^2(h1,h2) = 1/2 sum(from 1 to number of bins) (h1(n)- h2(n))^2 / h1(n)+h2(n)

% Author : Scott Blunsden 	
	
chsq = 0;
nbins = size(histogram_1,2);
for j=1:nbins
   if (histogram_1(j) == 0.0 && histogram_2(j) == 0.0)

   else
       temp=histogram_1(j)-histogram_2(j);
       chsq = chsq + (temp*temp/(histogram_1(j)+histogram_2(j))) ;
   end
end
value = chsq;

end

