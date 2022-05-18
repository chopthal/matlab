function output = UseCipher(type, input)
    % length(KEY) = 32 (AES-128), 48 (AES-192), 64 (AES-256)
    % length(input) = 32 -> 16 bytes (hex) : 16 letters
    output = '';
    KEY='000102030405060708090a0b0c0d0e0f'; % 32 (AES-128)
    if strcmpi(type, 'Encrypt')
        output = Cipher(KEY, input);
    elseif strcmpi(type, 'Decrypt')
        output = InvCipher(KEY, input);
    else
        disp('Invalid type');        
    end
end


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


function state = SubBytes(state)
    Sbox=['637c777bf26b6fc53001672bfed7ab76';...
          'ca82c97dfa5947f0add4a2af9ca472c0';...
          'b7fd9326363ff7cc34a5e5f171d83115';...
          '04c723c31896059a071280e2eb27b275';...
          '09832c1a1b6e5aa0523bd6b329e32f84';...
          '53d100ed20fcb15b6acbbe394a4c58cf';...
          'd0efaafb434d338545f9027f503c9fa8';...
          '51a3408f929d38f5bcb6da2110fff3d2';...
          'cd0c13ec5f974417c4a77e3d645d1973';...
          '60814fdc222a908846eeb814de5e0bdb';...
          'e0323a0a4906245cc2d3ac629195e479';...
          'e7c8376d8dd54ea96c56f4ea657aae08';...
          'ba78252e1ca6b4c6e8dd741f4bbd8b8a';...
          '703eb5664803f60e613557b986c11d9e';...
          'e1f8981169d98e949b1e87e9ce5528df';...
          '8ca1890dbfe6426841992d0fb054bb16'];
    Sbox=reshape(hex2dec(reshape(Sbox',2,[])'),16,16);
    state=Sbox(state+1);
end


function state = ShiftRows(state)
    state(2,:)=circshift(state(2,:),[0 -1]);
    state(3,:)=circshift(state(3,:),[0 -2]);
    state(4,:)=circshift(state(4,:),[0 -3]);
end


function State = MixColumns(state)
    State=state;
    for a=1:4:13
        State(a)=bitxor(bitxor(bitxor(xtime(state(a),2),xtime(state(a+1),3)),state(a+2)),state(a+3));
        State(a+1)=bitxor(bitxor(bitxor(xtime(state(a+1),2),xtime(state(a+2),3)),state(a)),state(a+3));
        State(a+2)=bitxor(bitxor(bitxor(xtime(state(a+2),2),xtime(state(a+3),3)),state(a)),state(a+1));
        State(a+3)=bitxor(bitxor(bitxor(xtime(state(a+3),2),xtime(state(a),3)),state(a+1)),state(a+2));
    end
end


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


function state = InvSubBytes(state)
    Sbox=['52096ad53036a538bf40a39e81f3d7fb';...
          '7ce339829b2fff87348e4344c4dee9cb';...
          '547b9432a6c2233dee4c950b42fac34e';...
          '082ea16628d924b2765ba2496d8bd125';...
          '72f8f66486689816d4a45ccc5d65b692';...
          '6c704850fdedb9da5e154657a78d9d84';...
          '90d8ab008cbcd30af7e45805b8b34506';...
          'd02c1e8fca3f0f02c1afbd0301138a6b';...
          '3a9111414f67dcea97f2cfcef0b4e673';...
          '96ac7422e7ad3585e2f937e81c75df6e';...
          '47f11a711d29c5896fb7620eaa18be1b';...
          'fc563e4bc6d279209adbc0fe78cd5af4';...
          '1fdda8338807c731b11210592780ec5f';...
          '60517fa919b54a0d2de57a9f93c99cef';...
          'a0e03b4dae2af5b0c8ebbb3c83539961';...
          '172b047eba77d626e169146355210c7d'];
    Sbox=reshape(hex2dec(reshape(Sbox',2,[])'),16,16); 
    state=Sbox(state+1);
end


function state = InvShiftRows(state)
    state(2,:)=circshift(state(2,:),[0 1]);
    state(3,:)=circshift(state(3,:),[0 2]);
    state(4,:)=circshift(state(4,:),[0 3]);
end


function State = InvMixColumns(state)
    State=state;
    for a=1:4:13
        State(a)=bitxor(bitxor(bitxor(xtime(state(a),14),xtime(state(a+1),11)),xtime(state(a+2),13)),xtime(state(a+3),9));
        State(a+1)=bitxor(bitxor(bitxor(xtime(state(a),9),xtime(state(a+1),14)),xtime(state(a+2),11)),xtime(state(a+3),13));
        State(a+2)=bitxor(bitxor(bitxor(xtime(state(a),13),xtime(state(a+1),9)),xtime(state(a+2),14)),xtime(state(a+3),11));
        State(a+3)=bitxor(bitxor(bitxor(xtime(state(a),11),xtime(state(a+1),13)),xtime(state(a+2),9)),xtime(state(a+3),14));
    end
end


function Out = InvCipher(key,In)
    %AES-128,192,or 256 inverse cipher
    %Impliments FIBS-197, key is 128, 192, or 256-bit hexidecimal input, 
    %message (In) is 128-bit hexidecimal. Application does not check lengths of
    %keys or message input but will error if they are not of the correct
    %length.
    %David Hill
    %Version 1.0.4
    %1-25-2021
    
    Nk=length(key)/8;
    In=hex2dec(reshape(In,2,[])');
    w=KeyExpansion(key,Nk);
    state=reshape(In,4,[]);
    state=AddRoundKey(state,w(:,4*(Nk+6)+1:4*(Nk+7)));
    for k=(Nk+6):-1:2
        state=InvShiftRows(state);
        state=InvSubBytes(state);
        state=AddRoundKey(state,w(:,4*(k-1)+1:4*k));
        state=InvMixColumns(state);
    end
    state=InvShiftRows(state);
    state=InvSubBytes(state);
    state=AddRoundKey(state,w(:,1:4));
    Out=state(:)';
    Out=lower(dec2hex(Out(1:length(In)))');
    Out=Out(:)';
end


function Out = Cipher(key,In)
    %AES-128,192,256 cipher
    %Impliments FIBS-197, key is a 128, 292, or 256-bit hexidecimal input, 
    %message (In) is 128-bit hexidecimal. Application does not check lengths of
    %keys or message input but will error if they are not of the correct
    %length.
    %David Hill
    %Version 1.0.4
    %1-25-2021
    
    Nk=length(key)/8;
    In=hex2dec(reshape(In,2,[])');%converts hex bytes into decimal
    w=KeyExpansion(key,Nk);%key expansion per standard
    state=reshape(In,4,[]);%reshapes input into state matrix
    state=AddRoundKey(state,w(:,1:4));%conducts first round
    for k=2:(Nk+6)%conducts follow-on rounds
        state=SubBytes(state);%per standard
        state=ShiftRows(state);%per standard
        state=MixColumns(state);%per standard
        state=AddRoundKey(state,w(:,4*(k-1)+1:4*k));%per standard
    end
    state=SubBytes(state);
    state=ShiftRows(state);
    state=AddRoundKey(state,w(:,4*(Nk+6)+1:4*(Nk+7)));
    Out=state(:);%changes output to column vector
    Out=lower(dec2hex(Out(1:length(In)))');%converts output to hex
    Out=Out(:)';%converts output to row vector
end


function state = AddRoundKey(state,w)
    for k=1:4
        state(:,k)=bitxor(state(:,k),w(:,k));
    end
end