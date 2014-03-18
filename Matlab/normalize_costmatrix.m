function [SC] = normalize_costmatrix( SC )
% put the values of SC onto the [-1, 1] interval

mx = max( SC( ~isinf( SC ) ) );
ms = min( SC( ~isinf( SC ) ) );

SC = (((SC-ms)./ (mx-ms)).*2)-1;

end