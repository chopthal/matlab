function scanOrderMat = SqrOrderMat(noFrame)

metWidth = noFrame;

ordMet = zeros(metWidth, metWidth);
[c, r] = size(ordMet);

if mod(metWidth, 2) == 1

    cntCor = [(1+c)/2, (1+r)/2];
    
else
    
    cntCor = [c/2+1, r/2];
    
end

R = [0 1];
U = [-1 0];
L = [0 -1];
D = [1 0];

numDir = [R; U; L; D];
numRep = 0;

j = 1;
while sum(numRep) < metWidth^2
    
    numRep(end+1) = j;
    numRep(end+1) = j;
    j = j+1;
    
end

numRep(end) = [];
numRep(end) = [];
numRep(end+1) = j-2;
numRep(1) = [];

% Center (Begins)
numCor = cntCor;
ordMet(numCor(1), numCor(2)) = 1;

i = 1;
iii = 1;
iiii = 1;

while i <= size(numRep, 2)
        
    for ii = 1:numRep(i)
        
        if mod(iiii, 4) == 0
            
            dirNum = 4;
            
        else
            
            dirNum = mod(iiii, 4);
            
        end
        
        numCor = numCor + numDir(dirNum, :);        
        ordMet(numCor(1), numCor(2)) = iii+1;
        iii = iii+1;

    end
    
    iiii = iiii+1;    
    i = i+1;
    
end

scanOrderMat = ordMet;