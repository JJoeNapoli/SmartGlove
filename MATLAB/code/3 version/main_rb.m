%% tf rviz sucks
clc
clear
close all

%% load bag file
bag_name="../../bag_file/mano_rb.bag";        %qualche mrks in più ma mai in meno

[V,RB]=load_and_fill(bag_name);

% bag = rosbag("../../bag_file/nocche_rb.bag");
% bag = rosbag("../../bag_file/test.bag");
% bag = rosbag("../../bag_file/due_mrkrs.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-23-47.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-21-37.bag");
% bag = rosbag("../../bag_file/2019-07-01-18-30-15.bag");

%% clean from bad data
V=clean_noises(V,RB);

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
% da oTm andiamo a fare l'inversa mTo
% ogni marker lo salviamo relativamente
% nell'ordine che preferiamo
% questo è Vdes

mVdes=set_Vdes(V,mTo(:,:,1));

%% findA
% come nelle versioni precedenti,forse
% sempre nel frame relativo relativo
A=findA(V(1,1).field,mVdes,mTo(:,:,1));

%%  check if some data are lost and sort them

num_mrks=size(V(I,1).field);
for I=1:num_msgs
    
    if num_mrks == size(V(I,1).field)
        %% W
        W(:,:,I) = A * V(1,1).field;
        
    else
        old = A' * W(:,:,I-1);
        mlast_pos = my_transform(old,mTo);
        % vado a vedere le diff dei vettori ripetto a m, il primo
        % più grande è la posizione (ind) di quello scomparso,
        % bisogna farlo per più volte, finché non si raggiunge il numero di
        % markrs iniziale
        % trovato quello scomparso gli si da la stessa posizione relativa
        % di prima
        % usiamo W  e lo disordiniamo perché almeno abbiamo la posizione
        % precedente già aggiustata (se usassimo V e se in due msgs 
        % consecutivi mancasse un mrk sarebbe merda)
    end
end


% graph
% plot the cleaned data

% figure(),hold on
% axis equal
% plot3(V(1,1).field(:,1),V(1,1).field(:,2),V(1,1).field(:,3),'or')
% plot3(RB(1,1).field(1,1),RB(1,1).field(1,2),RB(1,1).field(1,3),'ob'),
% grid on
%
% my_plot(V(1,1).field);
% my_plot(W);
%
% my_plot(mVdes)


%% load knucles
load("knucles.mat")

%% compute the following knucles
nocche=my_transform(mnocche,oTm(:,:,1));
% my_plot([W;nocche]);
%
% mV=my_transform(V(1,1).field,mTo(:,:,1));
% my_plot([mV;mnocche]);

my_skeleton(W,nocche)

%%
num_mrks=size(V(1,1).field,1);
for i=1:num_msgs
    min_mrkrs(i)=(size(V(i,1).field,1));
    if num_mrks ~= min_mrkrs(i)
        i
        min_mrks(i)
    end
end
% min_mrkrs
% min(min_mrkrs)

