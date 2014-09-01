classdef show
    %SHOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        file = '';
        indfile = '';
        chops = '';
        actual
        predicted
        indexes
        audio_low = nan
        
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

