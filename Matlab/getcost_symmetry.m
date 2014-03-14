function [ SC ] = getcost_symmetry( C, W, min_w  )
%%
T = size(C,1);

SC = nan( T, W );

% matrix of diagonals 
D = nan( W, T );
assert(size(C,1)==size(C,2));
  
 for i=1:W
    D( i, 1:T-(i-1) ) = diag( C, i-1 ); 
 end
 
D = (D)';
 
for t=1:T
   for w=1:W
      
        s = (  D( t, 1:w ) ); 
       
        SC( t,w ) =  ( 1-D( t, 1 ) * 1-D( t, w ) ) * w;
        %SC( t,w ) =  ( s * s') ;
   end
   
end

SC = normalize_costmatrix( SC );
for t=1:T
   SC( t, : ) = 1-(SC( t, : ) .* (W:-1:1));
end

SC = normalize_costmatrix( SC );


SC(SC>0.6)=1;
SC=SC.^0.3;

SC( isnan(SC) )=inf;
SC( SC<0 )=0;

%SC(SC<0.35)=inf;
%SC=SC.^0.5;

%basic_sizenormalization = repmat( (1:W), size(SC,1), 1);
%SC = SC ./ basic_sizenormalization;
%SC = normalize_costmatrix( SC );

%SC = 1-SC;


% D = cumsum( 1-D )';

% SC = D;
% SC(SC<0)=0;

%SC = [ nan(T,1) SC ];

%SC(:,1:min_w )=inf;


%[predictions, matched_tracks] = compute_trackplacement( ...
%        showname, SC, drawsimmat, space, indexes, solution_shift, tileWidthSecs, C, w );



%%

end