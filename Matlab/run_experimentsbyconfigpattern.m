function run_experimentsbyconfigpattern( pattern )
% run_experimentsbyconfigpattern run experiments on saved configs matching
% a file pattern regex. When we run the GA on the cloud we don't have the
% dataset up there so can't run the final results after getting the best
% config

if nargin < 1
   pattern = 'config.+?(heur|trac).+?\.mat'; 
end

d = dir('results');

for i=1:length(d)
   if ~isempty( regexp( d(i).name, pattern, 'ONCE' ) )
       run_experimentsbyconfig( d(i).name )
   end
end

end