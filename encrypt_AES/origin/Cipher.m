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

