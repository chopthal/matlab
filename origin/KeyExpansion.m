function w = KeyExpansion(key,Nk)
key=hex2dec(reshape(key,2,[])');
w=reshape(key,4,[]);
for i=Nk:4*(Nk+7)-1
    temp=w(:,i);
    if mod(i,Nk)==0
        temp=SubBytes(circshift(temp,-1));
        n=1;
        m=0;
        while m<i/Nk-1%needed to modulate higher powers of 2 per standard
            n=xtime(2,n);
            m=m+1;
        end
        temp=bitxor(temp,[n,0,0,0]');
    elseif Nk>6 && mod(i,8)==4
        temp=SubBytes(temp);
    end
    w(:,i+1)=bitxor(w(:,i-Nk+1),temp);
end
end