function my_wave(trustV)

[num_mrks,num_msgs]=size(trustV);
point=zeros(2,num_msgs);
for j = 1:num_msgs
    point(1,j)=j;
    for i = 1:num_mrks
        if trustV(i,j) == true
            point(2,j)=point(2,j)+1;
        end
        
    end
end

figure(2),hold on, ylim([0,15]), grid on, plot(point(1,:),point(2,:),'-b')
end
