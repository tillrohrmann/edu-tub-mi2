function [normalizationValue] = Z(N,W,beta,energy)

normalizationValue = 0;
value = -1*ones(N,1);

for i = 1:2^N
    normalizationValue = normalizationValue + exp(-beta*energy(value,W));
    
    for j = 1:N
        if(value(j) == -1)
            value(j) = 1;
            break;
        else
            value(j) = -1;
        end
    end
end

end