%function [ new_cost ] = get_contigscore( p1, p2, costcontig_incentivebalance, progression, width )
%get_contigscore gets the score of a pair of contig points
%made into a script for performance

new_cost = 0;

if( max(p1, p2) < 0)
new_cost = (abs(p1)+abs(p2))/2;
% contiguity more important in the center 
% of the expected track size
% contiguity more important the further away it is
new_cost = new_cost / width;
new_cost = new_cost / progression;
new_cost = new_cost * costcontig_incentivebalance;
new_cost=-new_cost;
end

if( min(p1,p2) > 0 )
new_cost = (abs(p1)+abs(p2))/2;
% contiguity more important in the center 
% of the expected track size
% contiguity more important the further away it is
new_cost = new_cost / width;
new_cost = new_cost / progression;
new_cost = new_cost * (1-costcontig_incentivebalance);
new_cost = +new_cost;
end

%end

