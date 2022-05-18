function state = AddRoundKey(state,w)
for k=1:4
    state(:,k)=bitxor(state(:,k),w(:,k));
end
end