subplot(2,2,1)
imagesc(Cell_Info_A.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph

subplot(2,2,2)
imagesc(Cell_Info_B.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph

subplot(2,2,3)
imagesc(Cell_Info_C.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph

subplot(2,2,4)
imagesc(Cell_Info_D.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph