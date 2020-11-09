%Uniform [0, 1]

%Produces a probability of the given x based on an [0,1] uniform pdf
function f = unf1(x)
    %just call function with correct arguments
    f=unifpdf(x,0,1);
end