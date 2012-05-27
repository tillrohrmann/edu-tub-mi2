function output = Fi(x,mu,b)

if (x <= mu)
    output = mu + b*log(abs(2*x));
    
else
    output = mu - b*log(abs(2*(1-x)));
    
end;