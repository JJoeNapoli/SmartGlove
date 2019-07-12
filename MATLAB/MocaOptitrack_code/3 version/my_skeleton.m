function []=my_skeleton(W,nocche)
%% compute the following knucles

% for i=1:4
%     v(i,:)=W(3+2*i,:)-nocche(i,:);
%     nocche(4+i,:)=W(3+2*i,:)+v(i);
% end

%% plot the skeleton

% figure(), hold on, axis equal, grid on,
%
% for i=1:size(W,1)
%     plot3(W(i,1), W(i,2), W(i,3),'Marker', 'o', 'Color', 'red','MarkerSize', 9);
%     text(double(W(i,1)), double(W(i,2)), double(W(i,3)),[int2str(i) '   '], 'Color', 'blue', 'HorizontalAlignment', 'right', 'FontSize', 9);
% end

my_plot([W;nocche(1:4,:)]);

%%
%  plot([coords(1), (N+coords(3))], [coords(2), coords(4)], 'b', 'LineWidth', 1);
for i=1:4
    
    prima_linea(i,:) = W(3+2*i,:) - nocche(i,:);
    nocche(4+i,:) = W(3+2*i,:) + 0.75*prima_linea(i,:);
    
    seconda_linea(i,:) = W(4+2*i,:) - nocche(4+i,:);
    nocche(8+i,:) = W(4+2*i,:) + 2*seconda_linea(i,:);
    
    
    plot3([nocche(i,1),nocche(4+i,1)],[nocche(i,2),nocche(4+i,2)],...
        [nocche(i,3),nocche(4+i,3)],'-k');
%     plot3([nocche(i,1),W(3+2*i,1)],[nocche(i,2),W(3+2*i,2)],...
%         [nocche(i,3),W(3+2*i,3)],'-r');
    plot3([nocche(4+i,1),nocche(8+i,1)],[nocche(4+i,2),nocche(8+i,2)],...
        [nocche(4+i,3),nocche(8+i,3)],'-r');

end
end
