function [out]=battleship(moves,names)
[xlsText xlsNum xlsRaw]=xlsread(names); %#ok<NASGU,ASGLU>
%initial setup from inputs%%%%%%%%
times=numel(moves);
a=1;
cellT={}; % cell we're building as targeter
while a<=times
temp=moves(a);% grab this cell
temp=cell2mat(temp); %go to char
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(temp(1),'A')
    test=str2num(temp(2:end)); %#ok<*ST2NM>
    vec=[1,test];
elseif strcmp(temp(1),'B')
    test=str2num(temp(2:end));
    vec=[2,test];
elseif strcmp(temp(1),'C')
    test=str2num(temp(2:end));
    vec=[3,test] ;
elseif strcmp(temp(1),'D')
    test=str2num(temp(2:end));
    vec=[4,test];      
elseif strcmp(temp(1),'E')
    test=str2num(temp(2:end));
    vec=[5,test];       
elseif strcmp(temp(1),'F')
    test=str2num(temp(2:end));
    vec=[6,test]; 
elseif strcmp(temp(1),'G')
    test=str2num(temp(2:end));
    vec=[7,test] ;
elseif strcmp(temp(1),'H')
    test=str2num(temp(2:end));
    vec=[8,test];      
elseif strcmp(temp(1),'I')
    test=str2num(temp(2:end));
    vec=[9,test];       
elseif strcmp(temp(1),'J')
    test=str2num(temp(2:end));
    vec=[10,test]; 
else
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% if/else for target
cellT(1,a)=mat2cell(vec); %#ok<AGROW> %insert vec into targeter cell
a=a+1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% targeter cell made
x=1;
temp=xlsNum;
while x<=numel(cellT)
    cycle=cell2mat(cellT(x)); % pt we're checking
    box=temp(cycle(1),cycle(2)); % proper box called
    box=cell2mat(box); % grab from cell and make char
    if strcmp(box,'')
    temp(cycle(1),cycle(2))={'O'};
    elseif strcmp(box,'D') || strcmp(box,'S') || strcmp(box,'B') || strcmp(box,'AC') || strcmp(box,'P')
    temp(cycle(1),cycle(2))={'X'};       
    else
    end
   
    x=x+1;
end
board=temp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOARD IS NOW PAINTED
%%%%%%%% are any of these ships present?
P=any(any(strcmpi(xlsNum,'P')));
D=any(any(strcmpi(xlsNum,'D')));
S=any(any(strcmpi(xlsNum,'S')));
B=any(any(strcmpi(xlsNum,'B')));
AC=any(any(strcmpi(xlsNum,'AC')));
%%%%%%%%
Pd=any(any(strcmpi(board,'P')));
Dd=any(any(strcmpi(board,'D')));
Sd=any(any(strcmpi(board,'S')));
Bd=any(any(strcmpi(board,'B')));
ACd=any(any(strcmpi(board,'AC')));
%%%%%%%% are they still present after attack?
sunk={}; % create sunk cell
if P==Pd
    sunk(1,5)={''};
else
    sunk(1,5)={'Patrol Boat'};
end
if D==Dd
    sunk(1,3)={''};
else
    sunk(1,3)={'Destroyer'};
end
if S==Sd
    sunk(1,4)={''};
else
    sunk(1,4)={'Submarine'};
end
if B==Bd
    sunk(1,2)={''};
else
    sunk(1,2)={'Battleship'};
end
if AC==ACd
    sunk(1,1)={''};
else
    sunk(1,1)={'Aircraft Carrier'};
end
%%%%%%%% did it change? Now sunks show what died
w=1;
t=1;
preO={};
while w<=5
if strcmp(sunk(1,w),'')
else
    preO(1,t)=sunk(1,w); %#ok<AGROW> %if success grab that value and put in exporter
    t=t+1; %only count up T if we're successful
end   
w=w+1; 
end

%%%%%%%%%%%%%%%%%%%% EXCEL EXPORT SECTION
temp=(names(1:end-4));
add='_solution.xls';
namer=[temp add];
xlswrite(namer,board)
%%%%%%%%%%%%%%%%%%%% EXCEL EXPORT SECTION

out=preO;

end


%%%% Test Cases: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   clear
%   names='battleship_board.xls'
%   moves={}
%   [out]=battleship(moves,names)
%   
%   out => {}
%   Output file looks like 'battleship_soln1.xls'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   clear
%   names='battleship_board.xls'
%   moves={'A1', 'A2', 'A3', 'E2', 'I2', 'J2', 'H10', 'I10', 'J10'};
%   [out]=battleship(moves,names)
%   
%   out =>{'Destroyer', 'Patrol Boat'};
%   Output file looks like 'battleship_soln2.xls'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   clear
%   names='battleship_board.xls'
%   moves={'A1', 'A3', 'A7', 'A10', 'B2', 'B4', 'B5', 'B6', 'B7', ...
%               'B10', 'C1', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C10', ...
%               'D1', 'D2', 'D10', 'E2', 'E7', 'E10', 'F1', 'F2', 'F5', ...
%               'G1', 'G2', 'G4', 'G5', 'G10', 'H1', 'H2', 'H5', ...
%               'I2', 'I4', 'I7', 'I10', 'J1', 'J4', 'J5', 'J6', 'J7'}
%   [out]=battleship(moves,names)
%   
%   out1 =>  {'Aircraft Carrier', 'Battleship', 'Submarine'};
%   Output file looks like 'battleship_soln3.xls'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

%%%% ALL TEST CASES WORK! :D Time for a cold one!
