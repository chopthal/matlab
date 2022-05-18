function State = MixColumns(state)
State=state;
for a=1:4:13
    State(a)=bitxor(bitxor(bitxor(xtime(state(a),2),xtime(state(a+1),3)),state(a+2)),state(a+3));
    State(a+1)=bitxor(bitxor(bitxor(xtime(state(a+1),2),xtime(state(a+2),3)),state(a)),state(a+3));
    State(a+2)=bitxor(bitxor(bitxor(xtime(state(a+2),2),xtime(state(a+3),3)),state(a)),state(a+1));
    State(a+3)=bitxor(bitxor(bitxor(xtime(state(a+3),2),xtime(state(a),3)),state(a+1)),state(a+2));
end
end