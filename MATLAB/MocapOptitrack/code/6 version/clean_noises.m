%% pulisce i messaggi dei mrks da quelli che non c'entrano
function [V,RB]=clean_noises(V_struct,RB_struct)
% 20 cm 
thresh=0.20;

%numero messaggi
num_msgs=min(length(V_struct),length(RB_struct));

for i=1:num_msgs
    num_mrks=size(V_struct(i,1).field,1);
    salta=0;
    for j=1:num_mrks
        dist=norm(RB_struct(i,1).field - V_struct(i,1).field(j-salta,:));
        if dist > thresh
            V_struct(i,1).field(j-salta,:)=[];
            salta=salta+1;
        end
    end
end
ind=1;
for i = 1 : num_msgs
   if size(V_struct(i,1).field,1) ==  size(V_struct(1,1).field,1)       
       V(:,:,ind) = V_struct(i,1).field;
       RB(:,:,ind) = RB_struct(i,1).field;
       ind=ind+1;
   end
end
end
