% set_Vdes
% main_nocche

%% tf rviz sucks
clc
clear
close all

%% load knucles
load("knucles.mat")
load("desired_config.mat")

%% load bag file
bag_name="../../bag_file/m_pollice.bag";
% bag_name="../../bag_file/2019-07-09-17-37-07.bag"; % usa set_Vdes2
% bag_name="../../bag_file/2019-07-09-17-47-47.bag";

% bag_name="../../bag_file/2019-07-01-18-21-37.bag";
% bag_name="../../bag_file/2019-07-01-18-30-15.bag";

[V_struct,RB_struct]=load_and_fill(bag_name);
% my_plot(V_struct(1).field)

%% clean from bad data
[V,RB]=clean_noises(V_struct,RB_struct);
clear V_struct RB_struct;
% my_plot(V(1).field)

%% transformation matrix for each msg
num_msgs=min(length(V),length(RB));

trustV=false(size(mVdes,1),num_msgs);
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
    
    %% remember if is a true value (TRUE) or an estimation (FALSE)
    trustV(1:size(V(I,1).field,1),I)=true(size(V(I,1).field,1),1);
end

%% findA
ii=1;
A=eye(size(V(ii,1).field,1));
Vdes = my_transform(mVdes,oTm(:,:,ii));
[W(:,:,ii),A]=my_sort(V(ii,1).field,Vdes,A,mTo(:,:,ii),mTo(:,:,ii),oTm(:,:,ii));

% my_plot(W(:,:,ii))
figure(1),

%% sort data
clc
num_mrkrs=size(V(ii,1).field,1);
for I = ii+1 : num_msgs
    if I == 199
        I;
    end
    
    %% don't worry be happy
    [W(:,:,I),A]= my_sort(V(I,1).field,W(:,:,I-1),A,mTo(:,:,I),mTo(:,:,I-1),oTm(:,:,I));
    num_msgs
    I
    
    %% mangia un pochino, figgeu!
    nocche=my_transform(mnocche,oTm(:,:,I));
    
    my_skeleton(W(:,:,I),nocche)
    
    pause(0.01)
    clf
    
end
nocche=my_transform(mnocche,oTm(:,:,I));

my_skeleton(W(:,:,I),nocche)
% %% plot the skeleton
% close all
% I=132;
% nocche=my_transform(mnocche,oTm(:,:,I));
% my_skeleton(W(:,:,I),nocche)
%         pause(0.01);



