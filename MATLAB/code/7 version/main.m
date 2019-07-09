% main_nocche
% set_Vdes

%% tf rviz sucks
clc
clear
close all


%% load knucles
load("knucles.mat")
load("desired_config.mat")

%% load bag file
bag_name="../../bag_file/tutta_mano_difettosa.bag";        %qualche mrks in più ma mai in meno

[V_struct,RB_struct]=load_and_fill(bag_name);

% bag = rosbag("../../bag_file/nocche_rb.bag");
% bag = rosbag("../../bag_file/test.bag");
% bag = rosbag("../../bag_file/due_mrkrs.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-23-47.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-21-37.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-30-15.bag");

%% clean from bad data
[V,RB]=clean_noises(V_struct,RB_struct);
clear V_struct RB_struct;

%% transformation matrix for each msg
num_msgs=min(length(V),length(RB));

for I=1:num_msgs
    %% set orientation and remove non IMUs
    
    [oRm,ind]=set_orient(V(I,1).field,RB(I,1).field);
    [V,RB]=move_nonimu(V,RB,I,ind);
    
    %% set oTm and mTo
    
    oTm(:,:,I)=[   oRm,        RB(I,1).field';
        zeros(1,3),     1];
    mTo(:,:,I)=[   oRm^-1,       (-oRm^-1)*RB(I,1).field';
        zeros(1,3),     1];
    %     oTm(:,:,I)*mTo(:,:,I) %=eye(4)
    %% homogeneous coordiantes
    
    V(I,1).field=[V(I,1).field,ones(size(V(I,1).field,1),1)];
    
end

%% set Vdes

% mVdes=set_Vdes(V,mTo(:,:,1));

%% findA
A=findA(V(1,1).field,mVdes,mTo(:,:,1));

%%  check if some data are lost and sort them
clc
num_mrkrs=size(V(1,1).field,1);
for I = 2 : num_msgs
    miss_mrkrs(I) = abs(num_mrkrs-size(V(I,1).field,1));
    
    if miss_mrkrs(I) == 0
        if miss_mrkrs(I-1) <= 1
            W(:,:,I) = A * V(I,1).field;
            
        else
            % controllo su A
            % A(1:num_mrkrs-miss_mrkrs(I-1),:) questa va bene
            old = A' * W(:,:,I-1);
            m_old = my_transform(old,mTo(:,:,I-1));
            m_new = my_transform(V(I,1).field,mTo(:,:,I));
            [A,m_new] = adjust_A(A,m_old,m_new,miss_mrkrs(I-1));
            W(:,:,I) = A * V(I,1).field;
            
        end
        
    else
        
        if miss_mrkrs(I) >= miss_mrkrs(I-1)
            old = A' * W(:,:,I-1);
            m_old = my_transform(old,mTo(:,:,I-1));
            m_new = my_transform(V(I,1).field,mTo(:,:,I));
            % settare bene la thresh
            W(:,:,I) = get_W_hat(m_old,m_new,A,oTm(:,:,I));
            
        else
            old = A' * W(:,:,I-1);
            m_old = my_transform(old,mTo(:,:,I-1));
            m_new = my_transform(V(I,1).field,mTo(:,:,I));
            [A,m_new] = adjust_A(A,m_old,m_new,miss_mrkrs(I-1));
            
            new = my_transform(m_new,oTm(:,:,I));
            W(:,:,I) = A * new;
            
        end
    end
    I
    nocche=my_transform(mnocche,oTm(:,:,I));
    my_skeleton(W(:,:,I),nocche)
    
end
%% compute the following knucles
I=2;
%         pause(0.01);



