function A=findA(V,mVdes,mTo)
%note: V,mVdes,mTo matrices
mV=my_transform(V,mTo);

[num_mrks,~]=size(mVdes);

A=zeros(num_mrks);
dist=zeros(num_mrks,1);
for i=1:num_mrks
    for j=1:num_mrks
        dist(j,i)=norm(mV(i,:)-mVdes(j,:));
    end
%     [~,id]=min(dist);
%     A(id,i)=1;  %la riga i-esima va nella riga id-esima
end
dist
for i=1:num_mrks
    [~,id]=min(dist(:,i));
    dist(id,:)=100*ones(num_mrks,1);
    A(id,i)=1;
end
end

