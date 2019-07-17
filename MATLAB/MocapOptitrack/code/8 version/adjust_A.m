% %% se becca dei mrks che prima non beccava
% function [A,Vnew] = adjust_A(A,Vold,Vnew,miss_mrkrs)
% size_real = size(Vold,1) - miss_mrkrs;
% V_hat=Vold;
% V_hat(1:size_real,:)=[];
% for i = 1 : (size(Vnew,1) - size_real)
%     for j = 1 : miss_mrkrs
%         dist(i,j) = norm(Vnew(size_real+i)-Vold(size_real+j));
%     end
%     [~,ind(i)] = min(dist(i,:));
%     %aggiorna A
%     temp=A(:,size_real+ind(i));
%     A(:,size_real+ind(i))=[];
%     A = [A(:,1:size_real+i-1),temp,A(:,size_real+i:(size(Vold,1)-1))];
%     
% end
% 
% %aggiorna V_hat
% ind=sort(ind,'descend');
% for j=1:length(ind)    
%     V_hat(ind(j),:)=[];
% end
% Vnew=[Vnew;V_hat];
% end
% 


%% se becca dei mrks che prima non beccava
function [A,Vnew] = adjust_A(A,Vold,Vnew,miss_mrkrs)
size_real = size(Vold,1) - miss_mrkrs;
V_hat=Vold;
V_hat(1:size_real,:)=[];
for i = 1 : (size(Vnew,1) - size_real)
    for j = 1 : miss_mrkrs
        dist(i,j) = norm(Vnew(size_real+i)-Vold(size_real+j));
    end
end
for i = 1 : (size(Vnew,1) - size_real)
    [~,ind(i)] = min(dist(i,:));
    dist(:,ind(i))=1000;
    %aggiorna A
    temp=A(:,size_real+ind(i));
    A(:,size_real+ind(i))=[];
    A = [A(:,1:size_real+i-1),temp,A(:,size_real+i:(size(Vold,1)-1))];
    
end

%aggiorna V_hat
ind=sort(ind,'descend');
for j=1:length(ind)    
    V_hat(ind(j),:)=[];
end
Vnew=[Vnew;V_hat];
end

