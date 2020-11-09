%RGB image Dequantizer

%Uses mydequant to dequantize the RGB image x.
%Quantize level width for each colour (r, g, b) are w1, w2, w3.
function x = imagedequant(q, w1, w2, w3)
    %call dequantizer for each colour
    x(:,:,1) = mydequant(q(:,:,1),w1);  %R
    x(:,:,2) = mydequant(q(:,:,2),w2);  %G
    x(:,:,3) = mydequant(q(:,:,3),w3);  %B
end