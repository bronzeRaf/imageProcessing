%Quantizer

%Uniform quantizer for the input signal x with w level width.
function q = myquant(x, w)
    %needed for the quantizer formula
    no = 1/w;
    %tranform each colour intensity to a quant symbol ()
    q = floor(x*no);
end