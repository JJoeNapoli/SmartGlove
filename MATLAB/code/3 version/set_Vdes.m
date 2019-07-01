function temp=set_Vdes(V,mTo)

% mV=mTo(:,:,1)*V(1,1).field;

temp=[  V(1,1).field(1,:)
    V(1,1).field(7,:)
    V(1,1).field(8,:)
    V(1,1).field(5,:)
    V(1,1).field(12,:)
    V(1,1).field(4,:)
    V(1,1).field(10,:)
    V(1,1).field(3,:)
    V(1,1).field(6,:)
    V(1,1).field(2,:)
    V(1,1).field(9,:)
    V(1,1).field(11,:)];
mVdes=temp;
for i=1:size(V(1,1).field,1)
    mVdes(i,:)=(mTo(:,:,1)*(temp(i,:))')';
end

end

