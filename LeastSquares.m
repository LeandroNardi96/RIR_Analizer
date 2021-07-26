function [a0,a1] = LeastSquares(x,y)
%Dados los vectores x e y asociados entre si, calcula la recta de regresion
%lineal por cuadrados minimos: y = a1x + a0

    a0 = mean(y) - ((sum(x.*y)-(mean(y)*sum(x)))/(sum(x.^2)-(mean(x)*sum(x))))*mean(x);
    a1 = (sum(x.*y) -(mean(y)*(sum(x))))/(sum(x.^2) - (mean(x)*sum(x)));

end
   
    
    
    