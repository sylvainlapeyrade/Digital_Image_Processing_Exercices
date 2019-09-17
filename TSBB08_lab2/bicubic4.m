  
function h = bicubic4(distance)

if(abs(distance) <= 1)
    h = 2*abs(distance)^3-3*distance^2+1;
else
    h = 0;
end
end