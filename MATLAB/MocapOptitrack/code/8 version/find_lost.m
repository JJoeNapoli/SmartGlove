function ind = find_lost(V1,V2,threshold)
min_num_mrks = min([size(V1,1),size(V2,1)]);
% figure(),hold on;
for j = 1 : min_num_mrks
    dist = norm(V1(j,:)-V2(j,:));
%     plot(j,dist,"o")
    if dist>threshold
        ind = j;
        break
    end
    ind = min_num_mrks + 1;
end
end