%% Computes a matrix of row-vectors times a transformation matrix
function V_transf=my_transform(V,T)
%NB: all matrices

%set the right dimensions
V_transf=V;
for i=1:size(V,1)
    V_transf(i,:)=(T(:,:)*(V(i,:))')';
end
end
