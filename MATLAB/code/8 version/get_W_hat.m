%% se non becca dei mrks che prima beccava
function V_sorted = get_W_hat (m_old,m_new,A,oTm)
num_mrkrs = size(m_old,1);
miss_mrkrs = abs(num_mrkrs-size(m_new,1));

for i = 1 : miss_mrkrs
    ind(i) = find_lost(m_old,m_new,0.05);
    
    % mi calcola la nuova matrice A
    old_correlation(i,:) = A(ind(i),:);
    A(ind(i),:)=[];
    
    % aggiusta new
    temp(i,:) = m_old(ind(i),:);
    m_old(ind(i),:)=[];
    
end

A=[A;old_correlation];
m_new = [m_new ; temp];
new = my_transform(m_new,oTm);
% calcola W
V_sorted = A * new;



end
