function State = InvMixColumns(state)
State=state;
for a=1:4:13
    State(a)=bitxor(bitxor(bitxor(xtime(state(a),14),xtime(state(a+1),11)),xtime(state(a+2),13)),xtime(state(a+3),9));
    State(a+1)=bitxor(bitxor(bitxor(xtime(state(a),9),xtime(state(a+1),14)),xtime(state(a+2),11)),xtime(state(a+3),13));
    State(a+2)=bitxor(bitxor(bitxor(xtime(state(a),13),xtime(state(a+1),9)),xtime(state(a+2),14)),xtime(state(a+3),11));
    State(a+3)=bitxor(bitxor(bitxor(xtime(state(a),11),xtime(state(a+1),13)),xtime(state(a+2),9)),xtime(state(a+3),14));
end
end