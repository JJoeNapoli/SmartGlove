function A=findA(Vmedio,Vdes)

[num_mrks,~]=size(Vmedio);

A=zeros(num_mrks);
dist=zeros(num_mrks,1);
for i=1:num_mrks
    for j=1:num_mrks
        dist(j,1)=norm(Vmedio(i,:)-Vdes(j,:));
    end
    [~,id]=min(dist);
    A(id,i)=1;  %la riga i-esima va nella riga id-esima
end

end