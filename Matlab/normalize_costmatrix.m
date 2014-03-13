function [SC] = normalize_costmatrix( SC )
% put the values of SC onto the [0-1] interval

ms = max( SC( ~isinf( SC ) ) );
SC = SC./ms;

end