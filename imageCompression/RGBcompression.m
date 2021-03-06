%对彩色图像压缩
%PS:matlab读取保存一次图像对图像有压缩的效果
RGB=imread('C:\Users\liu-z\Desktop\background.jpg');
subplot(2,2,1);imshow(RGB),title('原始图像');

%RGB->YUV
YUV=rgb2ycbcr(RGB);
subplot(2,2,2);imshow(uint8(YUV));title('YUV图像');

T=dctmtx(8);

%DCT变换
BY=blkproc(Y,[8 8],'P1*x*P2',T,T');
BU=blkproc(U,[8 8],'P1*x*P2',T,T');
BV=blkproc(V,[8 8],'P1*x*P2',T,T');
%量化表
a=[16 11 10 16 24 40 51 61;  
      12 12 14 19 26 58 60 55;  
      14 13 16 24 40 57 69 55;  
      14 17 22 29 51 87 80 62;  
      18 22 37 56 68 109 103 77;  
      24 35 55 64 81 104 113 92;  
      49 64 78 87 103 121 120 101;  
      72 92 95 98 112 100 103 99;];  %低频
    
  b=[17 18 24 47 99 99 99 99;  
      18 21 26 66 99 99 99 99;  
      24 26 56 99 99 99 99 99;  
      47 66 99 99 99 99 99 99;  
      99 99 99 99 99 99 99 99;  
      99 99 99 99 99 99 99 99;  
       99 99 99 99 99 99 99 99;  
       99 99 99 99 99 99 99 99;]; %高频
%向量化
  BY=blkproc(BY,[8 8],'x./P1',a);
  BU=blkproc(BU,[8 8],'x./P1',b);
  BV=blkproc(BV,[8 8],'x./P1',b);
  BY=int8(BY);
  BU=int8(BU);
  BV=int8(BV);
  
  %反向量化
  BY=blkproc(BY,[8 8],'x.*P1',a);
  BU=blkproc(BU,[8 8],'x.*P1',b);
  BV=blkproc(BV,[8 8],'x.*P1',b);
  
  mask=[    %保留了所有系数
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;];  
     %BY BU BV是double类型  
     BY=blkproc(BY,[8 8],'P1.*x',mask);  
     BU=blkproc(BU,[8 8],'P1.*x',mask);  
     BV=blkproc(BV,[8 8],'P1.*x',mask);  
          
     %YI UI VI是double类型  %DCT反变换
     YI=blkproc(double(BY),[8 8],'P1*x*P2',T',T);  
     UI=blkproc(double(BU),[8 8],'P1*x*P2',T',T);  
     VI=blkproc(double(BV),[8 8],'P1*x*P2',T',T);
     
     IYUV=cat(3,YI,UI,VI);%压缩后的图像IYUV
     IYUV=uint8(IYUV);
     subplot(2,2,3);imshow(IYUV),title('压缩后的YUV图像');
     
    %YUV->RGB
    RI=YI-0.001*UI+1.402*VI;
    GI=YI-0.344*UI-0.714*VI;
    BI=YI+1.772*UI+0001*VI;
    IRGB=cat(3,RI,GI,BI);
    IRGB=uint8(IRGB);
   subplot(2,2,4);imshow(IRGB),title('压缩后的图像RGB图像');
   figure,imshow(RGB-IRGB),title('压缩后的图像RGB图像');
     disp('压缩后图像IRGB大小');whos('IRGB');
     disp('压缩前图像YUV大小');whos('YUV');
     disp('压缩前图像RGB大小');whos('RGB');
     
     
  