% Combined Data Test

% Eric Pate

%clear everything
clc
close all
com.mathworks.mlservices.MatlabDesktopServices.getDesktop.closeGroup('Web Browser')
load('Cell_Info.mat');
load('mapCampusLoss.mat');

%%% Import and shift the Loss Maps
LossPrim=final_4; % The initial 
LossPrimA=LossPrim; % Does not need shift
LossPrimB=imageShifter(LossPrim,32,25); %X & Y are reversed
LossPrimC=imageShifter(LossPrim,25,-26);
LossPrimD=LossPrim; % Does not need shift

% debug Output Boundary Coords A/B/C/D
%Cell_Info_A.Lon_UL Cell_Info_A.Lat_UL Cell_Info_A.Lon_LR Cell_Info_A.Lat_LR

%%% Precision
Prec=0.01; %KM

%%%%% Target Antenna Coords:
Alat=33.777420000000000; Alon=-84.397360000000000;
AnegX=-pos2dist(Alat,Alon,Cell_Info_A.Lat_LR,Alon,1);
AposX=pos2dist(Alat,Alon,Cell_Info_A.Lat_UL,Alon,1);
AnegY=-pos2dist(Alat,Alon,Alat,Cell_Info_A.Lon_LR,1);
AposY=pos2dist(Alat,Alon,Alat,Cell_Info_A.Lon_UL,1);

Blat=33.774590000000000; Blon=-84.400190000000000;
BnegX=-pos2dist(Blat,Blon,Cell_Info_B.Lat_LR,Blon,1);
BposX=pos2dist(Blat,Blon,Cell_Info_B.Lat_UL,Blon,1);
BnegY=-pos2dist(Blat,Blon,Blat,Cell_Info_B.Lon_LR,1);
BposY=pos2dist(Blat,Blon,Blat,Cell_Info_B.Lon_UL,1);

Clat=33.775140000000000; Clon=-84.394640000000000;
CnegX=-pos2dist(Clat,Clon,Cell_Info_C.Lat_LR,Clon,1);
CposX=pos2dist(Clat,Clon,Cell_Info_C.Lat_UL,Clon,1);
CnegY=-pos2dist(Clat,Clon,Clat,Cell_Info_C.Lon_LR,1);
CposY=pos2dist(Clat,Clon,Clat,Cell_Info_C.Lon_UL,1);

Dlat=33.777420000000000; Dlon=-84.397360000000000;
DnegX=-pos2dist(Dlat,Dlon,Cell_Info_D.Lat_LR,Dlon,1);
DposX=pos2dist(Dlat,Dlon,Cell_Info_D.Lat_UL,Dlon,1);
DnegY=-pos2dist(Dlat,Dlon,Dlat,Cell_Info_D.Lon_LR,1);
DposY=pos2dist(Dlat,Dlon,Dlat,Cell_Info_D.Lon_UL,1);


% Antenna Type
% An1=dipole('Length',1.829,'Width',0.305);       % THIS IS PLACEHOLDER DATA, need: full antenna toolbox type and specifications

An1=dipole('Width',0.05,'Tilt',0);
An2=dipole('Width',0.05,'Tilt',0);
An3=dipole('Width',0.05,'Tilt',0);
An4=dipole('Width',0.05,'Tilt',0);

% Freq
fr=0.85e9; %all are 850mhz

% AntennaModelingCore(freq,antenna,xRange,yRange,latCenter,lonCenter,Plot#);
figure
[X1,Y1,Emag1,Dvec1]=AntennaModelingCore(fr,An1,(AnegX:Prec:AposX),(AnegY:Prec:AposY),Alat,Alon,1);
[X2,Y2,Emag2,Dvec2]=AntennaModelingCore(fr,An2,(BnegX:Prec:BposX),(BnegY:Prec:BposY),Blat,Blon,2);
[X3,Y3,Emag3,Dvec3]=AntennaModelingCore(fr,An3,(CnegX:Prec:CposX),(CnegY:Prec:CposY),Clat,Clon,3);
[X4,Y4,Emag4,Dvec4]=AntennaModelingCore(fr,An4,(DnegX:Prec:DposX),(DnegY:Prec:DposY),Dlat,Dlon,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIXER values for
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% emag _> cutout
% dirty hack to solve slight inaccuracy between geomap map and flap,
% suspect curvature of earth was the cause. issue is ON THE EDGE and NOT in
% the final cull area so safe to pad with -95dB
% Pad
Pad=zeros(1,208);
Pad(Pad==0)=-95; 
Emag1=vertcat(Emag1,Pad,Pad,Pad,Pad,Pad,Pad);
Emag2=vertcat(Emag2,Pad,Pad,Pad,Pad,Pad,Pad);
Emag3=vertcat(Emag3,Pad,Pad,Pad,Pad,Pad,Pad);
Emag4=vertcat(Emag4,Pad,Pad,Pad,Pad,Pad,Pad);

% Trim
Emag1=Emag1(:,1:203);
Emag2=Emag2(:,1:203);
Emag3=Emag3(:,1:203);
Emag4=Emag4(:,1:203);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Convert Loss map to LossDBmap
ALossDB=Loss2DB(LossPrimA);
BLossDB=Loss2DB(LossPrimB);
CLossDB=Loss2DB(LossPrimC);
DLossDB=Loss2DB(LossPrimD);

% Reduce Emag's according to weighted and shifted lossmap. 
EmagL1=Emag1+ALossDB;
EmagL2=Emag2+BLossDB;
EmagL3=Emag3+CLossDB;
EmagL4=Emag4+DLossDB;

% STREET Knockout Culling
KnockA=KnockOut(Cell_Info_A.ReceivedPowerMap);
KnockB=KnockOut(Cell_Info_B.ReceivedPowerMap);
KnockC=KnockOut(Cell_Info_C.ReceivedPowerMap);
KnockD=KnockOut(Cell_Info_D.ReceivedPowerMap);

% Cull Emag Maps to Campus Street Data
Final1=KnockA.*EmagL1;
Final2=KnockB.*EmagL2;
Final3=KnockC.*EmagL3;
Final4=KnockD.*EmagL4;

%Loss Map Render %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(2,2,1)
imagesc(LossPrimA); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('LossMap 1')


subplot(2,2,2)
imagesc(LossPrimB); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('LossMap 2')

subplot(2,2,3)
imagesc(LossPrimC); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('LossMap 3')

subplot(2,2,4)
imagesc(LossPrimD); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('LossMap 4')

%Emag + Campus Render %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(2,2,1)
imagesc(EmagL1); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Emag Campus 1')

subplot(2,2,2)
imagesc(EmagL2); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Emag Campus 2')

subplot(2,2,3)
imagesc(EmagL3); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Emag Campus 3')

subplot(2,2,4)
imagesc(EmagL4); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Emag Campus 4')

%Final Render %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(2,2,1)
imagesc(Final1); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Campus 1')

subplot(2,2,2)
imagesc(Final2); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Campus 2')

subplot(2,2,3)
imagesc(Final3); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Campus 3')

subplot(2,2,4)
imagesc(Final4); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('Campus 4')   


