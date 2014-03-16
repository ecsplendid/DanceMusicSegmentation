function [SC] = normalize_costmatrix( SC )
% put the values of SC onto the [0-1] interval

mx = max( SC( ~isinf( SC ) ) );
ms = min( SC( ~isinf( SC ) ) );

SC = (SC-ms)./ (mx-ms);

end