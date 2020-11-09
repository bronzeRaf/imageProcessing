%Uniform [0, 1]

%Produces a probability of the given x based on an Normal pdf with mean 0.5
%and standard deviation 0.1
function f = normf(x)
    %just call function with correct arguments
    f = normpdf(x,0.5,0.1);
end