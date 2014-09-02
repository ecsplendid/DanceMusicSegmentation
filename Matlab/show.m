classdef show
    %SHOW class to describe the show we are currently working on
    
    properties
        number
        file = '';
        indfile = '';
        chops = '';
        actual
        indexes
        audio = nan
        showname
        CosineMatrix
        CostMatrix
        space % tiles->seconds mapping
        T
        W % max track length in tiles
        w % min track length in tiles
    end
    
    methods
        
        function sw = show(varargin)
          sw.file = varargin{1};
          sw.indfile = varargin{2};
          sw.indfile;
          sw.indexes = dlmread(varargin{2});
          
          if nargin>2
          	sw.chops = dlmread(varargin{3});
          else
              sw.chops = [];
          end
        end
        
       
    end
end

