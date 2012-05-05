function k_value = rbf_kernel(x1,x2,sigma)

k_value = exp( - (norm(x1-x2)^2)/(2*sigma^2));