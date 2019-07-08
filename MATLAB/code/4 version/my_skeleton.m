function []=my_skeleton(mrkrs,nocche)
%% plot the mrkrs and knucles

my_plot([mrkrs;nocche(1:4,:)]);

%% lines
%  plot([coords(1), (N+coords(3))], [coords(2), coords(4)], 'b', 'LineWidth', 1);
for i=1:4
    
    prima_linea(i,:) = mrkrs(3+2*i,:) - nocche(i,:);
    nocche(4+i,:) = mrkrs(3+2*i,:) + 0.75*prima_linea(i,:);
    
    seconda_linea(i,:) = mrkrs(4+2*i,:) - nocche(4+i,:);
    nocche(8+i,:) = mrkrs(4+2*i,:) + 2*seconda_linea(i,:);
    
    
    plot3([nocche(i,1),nocche(4+i,1)],[nocche(i,2),nocche(4+i,2)],...
        [nocche(i,3),nocche(4+i,3)],'-k');
    %     plot3([nocche(i,1),W(3+2*i,1)],[nocche(i,2),W(3+2*i,2)],...
    %         [nocche(i,3),W(3+2*i,3)],'-r');
    plot3([nocche(4+i,1),nocche(8+i,1)],[nocche(4+i,2),nocche(8+i,2)],...
        [nocche(4+i,3),nocche(8+i,3)],'-r');
    
end

end
