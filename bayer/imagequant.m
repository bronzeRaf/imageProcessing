%RGB image Quantizer

%Uses myquant to quantize the RGB image x.
%Quantize level width for each colour (r, g, b) are w1, w2, w3.
function q = imagequant(x, w1, w2, w3)
    %call quantizer for each colour
    q(:,:,1) = myquant(x(:,:,1),w1);    %R
    q(:,:,2) = myquant(x(:,:,2),w2);    %G
    q(:,:,3) = myquant(x(:,:,3),w3);    %B
end