%function to shift the loss maps by specific coordiantes on a 203x203 grid
% Eric Pate

function [Output]=imageShifter(Input,XShift,YShift)
%{
%%% DEBUG
XShift=50;
YShift=32;
load('mapCampusLoss.mat');
Input=final_4;
%%%
%}
% padders
RowPad=zeros(1,203);
ColPad=zeros(203,1);

% X Shift
if XShift>0
    i=1;
    while i<XShift
        Input=vertcat(RowPad,Input);
        Input=Input(1:203,:);
        i=i+1;    
    end
    
elseif XShift<0
    i=1;
    while i>XShift
        Input=vertcat(Input,RowPad);
        Input=Input(2:204,:);
        i=i-1;    
    end
end

% Y Shift
if YShift>0
    i=1;
    while i<YShift
        Input=horzcat(ColPad,Input);
        Input=Input(:,1:203);
        i=i+1;    
    end
    
elseif YShift<0
    i=1;
    while i>YShift
        Input=horzcat(Input,ColPad);
        Input=Input(:,2:204);
        i=i-1;    
    end
end

Output=Input;

%{
%%%% DEBUG
imagesc(Input); % Plots a 2D image from a matrix
axis equal; % sets aspect ratio equal
axis xy; % vertical flip so (1,1) is at lower-left
colorbar; % puts a colorbar legend on right of graph
%}