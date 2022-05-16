function a = xtime(x,c)
a=0;
if bitget(x,1)
    a=c;
end
x=bitshift(x,-1);
while x>0
    c=bitshift(c,1);
    if bitget(c,9)
        c=bitset(c,9,0);
        c=bitxor(c,27);
    end
    if bitget(x,1)
        a=bitxor(a,c);
    end
    x=bitshift(x,-1);
end
end    