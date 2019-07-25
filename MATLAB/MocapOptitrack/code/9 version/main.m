set_Vdes
main_nocche

%% MOCAP OPTITRACK PLOTTING HAND
%% tf rviz sucks
clc
clear
close all

%% load knucles
load("knucles.mat")
load("desired_config.mat")

%% load bag file

% bag_name="../../bag_file/m_6e8_p_far.bag";
bag_name="../../bag_file/good/ref_incl_up_down_br.bag";
% bag_name="../../bag_file/ref_incl.bag";
% bag_name="../../bag_file/up_down.bag";
% bag_name="../../bag_file/m_anul_mign.bag";
% bag_name="../../bag_file/m_pollice.bag";
% bag_name="../../bag_file/ref_p_far_mrkrs.bag";
% bag_name="../../bag_file/ref_calib_other_side.bag";
% bag_name="../../bag_file/reference_calibration_2.bag";
% bag_name="../../bag_file/good/reference_calibration.bag";

% TODO %%%%
% bag_name="../../bag_file/move_objs.bag";% CONTROLLA
% bag_name="../../bag_file/fist.bag";% CONTROLLA
% bag_name="../../bag_file/ref_rest.bag";% CONTROLLA
% bag_name="../../bag_file/clockwise.bag";% CONTROLLA
% bag_name="../../bag_file/up_down_broken.bag";% CONTROLLA
% bag_name="../../bag_file/m_anul_mign_2.bag"; % CONTROLLA

[V_struct,RB_struct]=load_and_fill(bag_name);
% my_plot(V_struct(1).field)

%% clean from bad data
[V,RB]=clean_noises(V_struct,RB_struct);
clear V_struct RB_struct;
% my_plot(V(1).field)

%% transformation matrix for each msg
num_msgs=min(length(V),length(RB));

%% how much do we trust Vyou?
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
A=eye(size(mVdes,1));
Vdes = my_transform(mVdes,oTm(:,:,ii));
[W(:,:,ii),A]=my_sort(V(ii,1).field,Vdes,A,mTo(:,:,ii),mTo(:,:,ii),oTm(:,:,ii));

% my_plot(W(:,:,ii))
figure('units','normalized','outerposition',[0 0 1 1],'Resize','off'),

%% sort data
clc
num_mrkrs=size(V(ii,1).field,1);
for I = ii+1 : num_msgs
    if I == 199
        I;
    end
    
    %% W is V sorted
    [W(:,:,I),A,no_faith]= my_sort(V(I,1).field,W(:,:,I-1),A,mTo(:,:,I),mTo(:,:,I-1),oTm(:,:,I));
    num_msgs
    I
    
    if no_faith(1,1) == false
        trustV(:,I)= no_faith;
    end
    
    %% plot the skeleton
    nocche=my_transform(mnocche,oTm(:,:,I));
    Itrust=A*trustV(:,I);
    my_skeleton(W(:,:,I),nocche,Itrust)
    
    pause(0.01)
    clf
    
end
nocche=my_transform(mnocche,oTm(:,:,I));

my_skeleton(W(:,:,I),nocche,Itrust)

%% plot how many markers do we see
my_wave(trustV);




