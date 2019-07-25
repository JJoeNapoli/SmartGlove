function  [] = handVisualization(qm,hand,S)
    
    clf

    hand = SGdefineSynergies(hand,S(:,1:4),qm);    
    hand = SGmoveHand(hand,qm);
    grid on
    
    SGplotHand(hand);
    hold on
    grid on
    
    pause(0.0001)
    
    

end