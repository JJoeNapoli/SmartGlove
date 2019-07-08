%% se becca dei mrks che prima non beccava
function A = adjust_A(A,Vold,Vnew,miss_mrkrs)
size_real = size(Vold,1) - miss_mrkrs;
for i = 1 : (size(Vnew,1) - size_real)
    for j = 1 : miss_mrkrs
        dist(i,j) = norm(Vnew(size_real+i)-Vold(size_real+j));
    end
    [~,ind] = min(dist(i,:));
    
    temp=A(:,size_real+ind);
    A(:,size_real+ind)=[];
    A = [A(:,1:size_real+i-1),temp,A(:,size_real+i:(size(Vold,1)-1))];
    
end
end

