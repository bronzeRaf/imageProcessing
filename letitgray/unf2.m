%Uniform [0, 2]

%Produces a probability of the given x based on an [0,2] uniform pdf
function f = unf2(x)
    %just call function with correct arguments
    f=unifpdf(x,0,2);
end