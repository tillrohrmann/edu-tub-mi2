function [ result ] = removeOutlier( data )

cont = 1;
while cont == 1
    idx = chauvenet(data);
    if(sum(sum(idx))==0)
       cont = 0; 
    else
       idx = sum(idx,2) > 0;
       data = data(~idx,:);
    end
end

result = data;

end

