%% funziona solo con "../../bag_file/mano_rb.bag"

function mVdes=set_Vdes(V,mTo)
% nota: V è campo e mTo è 2D

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

% set the right dimensions
mVdes=my_transform(temp,mTo);
end

