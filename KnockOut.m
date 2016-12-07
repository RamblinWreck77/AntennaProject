%Create Knockout Matricies
% Eric Pate

function [Return]=kockout(Input)
i=1;
k=1;
while i<203
    temp=Input(i,:);
    while k<203
        target=temp(k);
        if target~=0
            Input(i,k)=1;
        end
        k=k+1;
    end
    k=1;
i=i+1;
end

Return=Input;
