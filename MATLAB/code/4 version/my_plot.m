function []=my_plot(W)
figure(),hold on
axis equal,grid on, %view(3),
for i=1:size(W,1)
    plot3(W(i,1), W(i,2), W(i,3),'Marker', 'o', 'Color', 'red','MarkerSize', 9);
    text(double(W(i,1)), double(W(i,2)), double(W(i,3)),[int2str(i) '   '], 'Color', 'blue', 'HorizontalAlignment', 'right', 'FontSize', 9);
end
end
