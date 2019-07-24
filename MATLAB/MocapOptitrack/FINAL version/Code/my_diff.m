%% calcola le differenze tra due vettori di dimensioni diverse
function diff = my_diff(v,w)
size_v=size(v,1);
size_w=size(w,1);
max_size = max([size_v,size_w]);
if size_v ~= max_size
    v=[v;zeros(max_size-size_v,3),ones(max_size-size_w,1)];
end
if size_w ~= max_size
    w=[w;zeros(max_size-size_w,3),ones(max_size-size_w,1)];
end
for i=1:max_size
    diff(i,:)=v(i,:)-w(i,:);
end
end
