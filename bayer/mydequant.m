%Dequantizer

%Dequantizer for the input signal x with w level width.
function x = mydequant(q, w)
    %dequantize symbol based on th same formula as in the quantizer
    x = q*w + w/2;
end