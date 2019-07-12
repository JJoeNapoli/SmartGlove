function []=my_skeleton(mrkrs,nocche)
%% plot the mrkrs and knucles
hold on,axis equal,grid on, view(3),
% W = [mrkrs;nocche(:,:)];
W = mrkrs;
for i=1:size(W,1)
    plot3(W(i,1), W(i,2), W(i,3),'Marker', 'o', 'Color', 'red','MarkerSize', 9);
    text(double(W(i,1)), double(W(i,2)), double(W(i,3)),[int2str(i) '   '], 'Color', 'blue', 'HorizontalAlignment', 'right', 'FontSize', 9);
end
%% lines
%  plot([coords(1), (N+coords(3))], [coords(2), coords(4)], 'b', 'LineWidth', 1);

for i=1:5
    
    prima_linea(i,:) = mrkrs(2*i,:) - nocche(i,:);
    nocche(6+i,:) = mrkrs(2*i,:) + 0.25*prima_linea(i,:);
    
    seconda_linea(i,:) = mrkrs(1+2*i,:) - nocche(6+i,:);
    nocche(11+i,:) = mrkrs(1+2*i,:) + 1.25*seconda_linea(i,:);
    
    plot3([nocche(i,1),nocche(1+i,1)],[nocche(i,2),nocche(1+i,2)],...
        [nocche(i,3),nocche(1+i,3)],'-r');
    plot3([nocche(i,1),nocche(6+i,1)],[nocche(i,2),nocche(6+i,2)],...
        [nocche(i,3),nocche(6+i,3)],'-k');
    %     plot3([nocche(i,1),W(3+2*i,1)],[nocche(i,2),W(3+2*i,2)],...
    %         [nocche(i,3),W(3+2*i,3)],'-r');
    plot3([nocche(6+i,1),nocche(11+i,1)],[nocche(6+i,2),nocche(11+i,2)],...
        [nocche(6+i,3),nocche(11+i,3)],'-k');
    
end
plot3([nocche(6,1),mrkrs(12,1)],[nocche(6,2),mrkrs(12,2)],...
    [nocche(6,3),mrkrs(12,3)],'-k');
plot3([nocche(6,1),nocche(1,1)],[nocche(6,2),nocche(1,2)],...
    [nocche(6,3),nocche(1,3)],'-r');
% hold off



end
