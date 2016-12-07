% takes 5 pixel loss map and turns it into a -dB map, values are based on
% (?)
% Eric Pate

function [Output]=Loss2DB(Input)
i=1;
k=1;
while i<203
    temp=Input(i,:);
    while k<203
        target=temp(k);
        if target==0
            Input(i,k)=-1;
            
        elseif target==1
            Input(i,k)=-3;   
            
        elseif target==2
            Input(i,k)=-18;
            
        elseif target==3
            Input(i,k)=-5;
            
        elseif target==4
            Input(i,k)=-10;
            
        end
        k=k+1;
    end
    k=1;
i=i+1;
end

Output=Input;