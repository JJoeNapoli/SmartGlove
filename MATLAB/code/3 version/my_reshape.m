function V=my_reshape(v)

num_mrks=size(v,1)/3;
V=reshape(v,3,num_mrks);
V=V';
temp(:,1)=V(:,2);
V(:,2)=-V(:,3);
V(:,3)=temp(:,1);
end