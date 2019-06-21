function Vmedio=meanV(V)

[num_mrks,~,~]=size(V);
Vmedio=zeros(num_mrks,3);
for i=1:10
    Vmedio=Vmedio+V(:,:,i);
end
Vmedio=Vmedio/10;

end