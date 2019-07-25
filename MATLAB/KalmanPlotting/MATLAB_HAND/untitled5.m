    clear all
    close all
    
    
    hand = SGparadigmatic;

    [~,S] = SGsantelloSynergies;

    qm = zeros(1,20);
    
    qm(6)=pi/4;
    qm(7)=pi/4+qm(6);
    
    figure(2)
    
    hand = SGdefineSynergies(hand,S(:,1:4),qm);    
    hand = SGmoveHand(hand,qm);
    grid on
    
    SGplotHand(hand);
    hold on
    grid on
    view(3);
    pause(0.001)
  