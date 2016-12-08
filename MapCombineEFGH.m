% Copy of ABCD to make EFGH

% Eric Pate

%clear everything
clc
clear all
close all
com.mathworks.mlservices.MatlabDesktopServices.getDesktop.closeGroup('Web Browser')
load('Cell_Info.mat');
load('mapCampusLoss.mat');

% Antenna Type
% An1=dipole('Length',1.829,'Width',0.305);       % THIS IS PLACEHOLDER DATA, need: full antenna toolbox type and specifications

%note: ABCD -> EFGH as ABBC 
%
An1=dipole('Length',0.4,'Width',0.001,'Tilt',0);    
An2=dipole('Length',2,'Width',0.043,'Tilt',0);      
An3=dipole('Length',2,'Width',0.043,'Tilt',0);   
An4=dipole('Length',1.2,'Width',0.080,'Tilt',0); 
%

%  BEST Mean Antennas
%{
An1=dipole('Length',2,'Width',0.014,'Tilt',0);      % mean of -0.03 dB, std dev of 14.35 dB
An2=dipole('Length',2,'Width',0.043,'Tilt',0);      % mean of -0.07 dB, std dev of 10.24 dB
An3=dipole('Length',2,'Width',0.040,'Tilt',0);
An4=dipole('Length',2,'Width',0.001999,'Tilt',0);   % mean of +0.39 dB, std dev of 12.32 dB
%}
%

%  BEST RPS Antennas 11.6
%{
An1=dipole('Length',0.4,'Width',0.001,'Tilt',0);    %A mean of +10.00 dB, std dev of 11.58 dB
An2=dipole('Length',2,'Width',0.043,'Tilt',0);      %B mean of -0.07 dB, std dev of 10.24 dB
An3=dipole('Length',1.2,'Width',0.080,'Tilt',0);    %C mean of +13.97 dB, std dev of 11.21 dB
An4=dipole('Length',0.3,'Width',0.001999,'Tilt',0); %D mean of +14.00 dB, std dev of 10.97 dB
%}
%

% Target Power Maps
PMap1=Cell_Info_A.ReceivedPowerMap;         % Same lat/lon as A!
PMap2=Cell_Info_B.ReceivedPowerMap;         % Same lat/lon as B!
PMap3=Cell_Info_B.ReceivedPowerMap;         % Same lat/lon as B!         
PMap4=Cell_Info_C.ReceivedPowerMap;         % Same lat/lon as C!

%%% Import and shift the Loss Maps
LossPrim=final_4; % The initial                         
LossPrimE=LossPrim; % Does not need shift
LossPrimF=imageShifter(LossPrim,32,25); %X & Y are reversed B's old shift
LossPrimG=imageShifter(LossPrim,32,25); %X & Y are reversed B's old shift
LossPrimH=imageShifter(LossPrim,25,-26);    % C's old shift

% debug Output Boundary Coords A/B/C/D
%Cell_Info_A.Lon_UL Cell_Info_A.Lat_UL Cell_Info_A.Lon_LR Cell_Info_A.Lat_LR

%%% Precision
Prec=0.01; %KM

%%%%% Target Antenna Coords:
Elat=Cell_Info_E.lat; Elon=Cell_Info_E.lon;
EnegX=-pos2dist(Elat,Elon,Cell_Info_E.Lat_LR,Elon,1);
EposX=pos2dist(Elat,Elon,Cell_Info_E.Lat_UL,Elon,1);
EnegY=-pos2dist(Elat,Elon,Elat,Cell_Info_E.Lon_LR,1);
EposY=pos2dist(Elat,Elon,Elat,Cell_Info_E.Lon_UL,1);

Flat=Cell_Info_F.lat; Flon=Cell_Info_F.lon;
FnegX=-pos2dist(Flat,Flon,Cell_Info_F.Lat_LR,Flon,1);
FposX=pos2dist(Flat,Flon,Cell_Info_F.Lat_UL,Flon,1);
FnegY=-pos2dist(Flat,Flon,Flat,Cell_Info_F.Lon_LR,1);
FposY=pos2dist(Flat,Flon,Flat,Cell_Info_F.Lon_UL,1);

Glat=Cell_Info_G.lat; Glon=Cell_Info_G.lon;
GnegX=-pos2dist(Glat,Glon,Cell_Info_G.Lat_LR,Glon,1);
GposX=pos2dist(Glat,Glon,Cell_Info_G.Lat_UL,Glon,1);
GnegY=-pos2dist(Glat,Glon,Glat,Cell_Info_G.Lon_LR,1);
GposY=pos2dist(Glat,Glon,Glat,Cell_Info_G.Lon_UL,1);

Hlat=Cell_Info_H.lat; Hlon=Cell_Info_H.lon;
HnegX=-pos2dist(Hlat,Hlon,Cell_Info_H.Lat_LR,Hlon,1);
HposX=pos2dist(Hlat,Hlon,Cell_Info_H.Lat_UL,Hlon,1);
HnegY=-pos2dist(Hlat,Hlon,Hlat,Cell_Info_H.Lon_LR,1);
HposY=pos2dist(Hlat,Hlon,Hlat,Cell_Info_H.Lon_UL,1);

% Freq
fr=0.85e9; %all are 850mhz

% AntennaModelingCore(freq,antenna,xRange,yRange,latCenter,lonCenter,Plot#);
figure
[X1,Y1,Emag1,Dvec1]=AntennaModelingCore(fr,An1,(EnegX:Prec:EposX),(EnegY:Prec:EposY),Elat,Elon,1);
[X2,Y2,Emag2,Dvec2]=AntennaModelingCore(fr,An2,(FnegX:Prec:FposX),(FnegY:Prec:FposY),Flat,Flon,2);
[X3,Y3,Emag3,Dvec3]=AntennaModelingCore(fr,An3,(GnegX:Prec:GposX),(GnegY:Prec:GposY),Glat,Glon,3);
[X4,Y4,Emag4,Dvec4]=AntennaModelingCore(fr,An4,(HnegX:Prec:HposX),(HnegY:Prec:HposY),Hlat,Hlon,4);

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
ELossDB=Loss2DB(LossPrimE);
FLossDB=Loss2DB(LossPrimF);
GLossDB=Loss2DB(LossPrimG);
HLossDB=Loss2DB(LossPrimH);

% Reduce Emag's according to weighted and shifted lossmap. 
EmagL1=Emag1+ELossDB;
EmagL2=Emag2+FLossDB;
EmagL3=Emag3+GLossDB;
EmagL4=Emag4+HLossDB;

% STREET Knockout Culling
KnockE=KnockOut(PMap1);
KnockF=KnockOut(PMap2);
KnockG=KnockOut(PMap3);
KnockH=KnockOut(PMap4);

% Cull Emag Maps to Campus Street Data
Final1=KnockE.*EmagL1;
Final2=KnockF.*EmagL2;
Final3=KnockG.*EmagL3;
Final4=KnockH.*EmagL4;

% Loss Map Render %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(2,2,1)
imagesc(LossPrimE); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('LossMap 1')


subplot(2,2,2)
imagesc(LossPrimF); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('LossMap 2')

subplot(2,2,3)
imagesc(LossPrimG); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('LossMap 3')

subplot(2,2,4)
imagesc(LossPrimH); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
title('LossMap 4')

% Emag + Campus Render %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% Final Render %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%Save & Compare Values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create the necessary structure and filenames to run the comparison 
Simulation_Info.Cell_Info_E.ReceivedPowerMap=Final1;
Simulation_Info.Cell_Info_F.ReceivedPowerMap=Final2;
Simulation_Info.Cell_Info_G.ReceivedPowerMap=Final3;
Simulation_Info.Cell_Info_H.ReceivedPowerMap=Final4;
save('Simulation_Info_EFGH.mat','-struct','Simulation_Info')


[mu1,sigma1] = CompareMaps('Cell_Info.mat','Simulation_Info_EFGH.mat');


