function RotateIm = rotateimage(Im, theta, intpol)

T = [cos(theta) sin(theta); -sin(theta) cos(theta)];

[rows, cols] = size(Im);	
RotateIm = zeros(rows, cols);
for xg = 1:cols	
  for yg = 1:rows
    xyff = inv(T)*([xg; yg]-[cols/2; rows/2])+[cols/2; rows/2];
    xff  = xyff(1);
    yff  = xyff(2);
    
    % ....
    switch intpol
       case 'nearest'
        % rotation code with nearest neighbor interpolation
        if (xff<=cols && yff<=rows && xff>=1 && yff>=1)
            xf = round(xff);
            yf = round(yff);
            RotateIm(yg,xg) = Im(yf,xf);
        end
       case 'bilinear'
        % rotation code with bilinear interpolation
        if (xff<=cols && yff<=rows && xff>=1 && yff>=1)
            xf = floor(xff);
            yf = floor(yff);
            xe = xff-xf;
            ye = yff-yf;
            RotateIm(yg,xg) = Im(yf,xf)*(1-xe)*(1-ye) + ...
                              Im(yf,xf+1)*xe*(1-ye) + ...
                              Im(yf+1,xf)*(1-xe)*ye + ...
                              Im(yf+1,xf+1)*xe*ye;
        end
       case 'bicubic'
        % rotation code with bicubic interpolation
        if (xff<cols && yff<rows && xff>1 && yff>1)
            xf = floor(xff);
            yf = floor(yff);
            xe = xff-xf;
            ye = yff-yf;
            RotateIm(yg,xg) = Im(yf,xf)*bicubic4(xe)*bicubic4(ye) + ...
                              Im(yf,xf+1)*bicubic4(1-xe)*bicubic4(ye) + ...
                              Im(yf+1,xf)*bicubic4(xe)*bicubic4(1-ye) + ...
                              Im(yf+1,xf+1)*bicubic4(1-xe)*bicubic4(1-ye);
        end
       case 'bicubic16'
        % rotation code with bicubic16 interpolation
        if (xff<cols-1 & yff<rows-1 & xff>2 & yff>2)
          yf=floor(yff);
          xf=floor(xff);

          dxf=xff-xf;
          dxff=dxf+1;
          dxc=1-dxf;
          dxcc=1+dxc;

          dyf=yff-yf;
          dyff=dyf+1;                    
          dyc=1-dyf;                    
          dycc=dyc+1;

          firstRow =  h(dxff)*h(dyff)*Im(yf-1,xf-1)+...
          h(dxff)*h(dyf)* Im(yf,xf-1)+...
          h(dxff)*h(dyc)* Im(yf+1,xf-1)+...
          h(dxff)*h(dycc)*Im(yf+2,xf-1);

          secondRow = h(dxf)*h(dyff)* Im(yf-1,xf)+...
          h(dxf)*h(dyf)*  Im(yf,xf)+...
          h(dxf)*h(dyc)*  Im(yf+1,xf)+...
          h(dxf)*h(dycc)* Im(yf+2,xf);

          thirdRow =  h(dxc)*h(dyff)* Im(yf-1,xf+1)+...
          h(dxc)*h(dyf)*  Im(yf,xf+1)+...
          h(dxc)*h(dyc)*  Im(yf+1,xf+1)+...
          h(dxc)*h(dycc)* Im(yf+2,xf+1);

          fourthRow = h(dxcc)*h(dyff)*Im(yf-1,xf+2)+...
          h(dxcc)*h(dyf)* Im(yf,xf+2)+...
          h(dxcc)*h(dyc)* Im(yf+1,xf+2)+...
          h(dxcc)*h(dycc)*Im(yf+2,xf+2);

          RotateIm(yg,xg) = firstRow+secondRow+thirdRow+fourthRow;

        elseif (xff<cols & yff<rows & xff>1 & yff>1)
                    xf = floor(xff);
            yf = floor(yff);
            xe = xff-xf;
            ye = yff-yf;
            RotateIm(yg,xg) = Im(yf,xf)*bicubic4(xe)*bicubic4(ye) + ...
                              Im(yf,xf+1)*bicubic4(1-xe)*bicubic4(ye) + ...
                              Im(yf+1,xf)*bicubic4(xe)*bicubic4(1-ye) + ...
                              Im(yf+1,xf+1)*bicubic4(1-xe)*bicubic4(1-ye);

        end
       otherwise
        error('Unknown interpolation method');
    end
  end
end
