%% get W from any possible fucking situation
function [W,A] = my_sort(Vnew,Wold,A,mTo_new,mTo_old,oTm_new)

% 
% Vnew=V(2,1).field;
% Wold=W(:,:,1);
% mTo_new=mTo(:,:,2);
% mTo_old=mTo(:,:,1);
% oTm_new=oTm(:,:,2);
%% get mVold
Vold = A' * Wold;
mVold = my_transform(Vold,mTo_old);

%% get mVnew
mVnew = my_transform(Vnew,mTo_new);

diff = my_diff(mVold,mVnew);
count=0;
while count ~= size(diff,1)-1
    %% 3D differences
    diff = my_diff(mVold,mVnew);
    count=0;
    for i = 2 : size(diff,1)
        if diff(i,1:3) == mVold(i,1:3)
            mVnew=[mVnew;mVold(i,:)];
            
            break
            
        elseif max(abs(diff(i,:)))>0.015
            % change mVold
            temp=mVold(i,:);
            mVold(i,:)=[];
            mVold=[mVold;temp];
            
            % change A
            tempA=A(:,i);
            A(:,i)=[];
            A=[A,tempA];
            break
            
        else
            count = count+1;
        end
        
    end
    count
end


Vnew=my_transform(mVnew,oTm_new);
W= A * Vnew;



end
