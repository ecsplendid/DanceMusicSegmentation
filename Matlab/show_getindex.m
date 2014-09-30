function si = show_getindex(s)
if ~isempty(strfind(s,'state'))
    si=1;
elseif ~isempty(strfind(s,'around'))
    si=3;
elseif ~isempty(strfind(s,'magic'))
    si=2;
elseif ~isempty(strfind(s,'lindmik'))
    si=4;
else
    si = 5;
end
end