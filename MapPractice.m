clc
close all

open('Cell_Info.mat')

Alat=33.777420000000000;
Alon=-84.397360000000000;
Blat=33.774590000000000;
Blon=-84.400190000000000;

dist=pos2dist(Alat,Alon,Blat,Blon,1)

Cell_Info_A.Lon_UL
Cell_Info_A.Lat_UL
Cell_Info_A.Lon_LR
Cell_Info_A.Lat_LR