function name = idx2name(idx)

tmp = [];
lat = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H'];
long = 1:12;

for i=0:11
    
    if idx-8*i == mod(idx,8)
        
        tmp = i;
        
    end
    
end

if isempty(tmp) == 0
    
    if mod(idx, 8) == 0
        
        latname = lat(8);
        longname = long(end-tmp+1);
        
    else
        
        latname = lat(mod(idx, 8));
        longname = long(end-tmp);
        
    end    

    name = sprintf('%s-%d', latname, longname);    

elseif idx == 96
    
    name = 'H-1';
    
else
    
    return
    
end