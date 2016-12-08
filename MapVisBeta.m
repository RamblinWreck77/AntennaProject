%Visualize the default map data
% Eric Pate

load('Cell_Info.mat');
load('Fake_Data_EFGH.mat');

figure
subplot(2,2,1)
imagesc(Cell_Info_A.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Original 1')

subplot(2,2,2)
imagesc(Cell_Info_B.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Original 2')

subplot(2,2,3)
imagesc(Cell_Info_C.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Original 3')

subplot(2,2,4)
imagesc(Cell_Info_D.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Original 4')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(2,2,1)
imagesc(Cell_Info_E.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('E 1')

subplot(2,2,2)
imagesc(Cell_Info_F.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('F 2')

subplot(2,2,3)
imagesc(Cell_Info_G.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('G 3')

subplot(2,2,4)
imagesc(Cell_Info_H.ReceivedPowerMap); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('H 4')