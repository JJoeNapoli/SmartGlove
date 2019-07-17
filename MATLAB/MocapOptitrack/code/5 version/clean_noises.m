%% pulisce i messaggi dei mrks da quelli che non c'entrano
function V=clean_noises(V,RB)
% 20 cm 
thresh=0.20;

%numero messaggi
num_msgs=min(length(V),length(RB));

for i=1:num_msgs
    num_mrks=size(V(i,1).field,1);
    salta=0;
    for j=1:num_mrks
        dist=norm(RB(i,1).field - V(i,1).field(j-salta,:));
        if dist > thresh
            V(i,1).field(j-salta,:)=[];
            salta=salta+1;
        end
    end
end
jump=0;
for i = 1 : num_msgs
   if size(V(i,1).field,1) >  size(V(1,1).field,1)       
       V(i-jump,1).field = [];
       RB(i-jump,1).field = [];
       jump=jump+1;
   end
end
end
