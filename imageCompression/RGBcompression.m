%�Բ�ɫͼ��ѹ��
%PS:matlab��ȡ����һ��ͼ���ͼ����ѹ����Ч��
RGB=imread('C:\Users\liu-z\Desktop\background.jpg');
subplot(2,2,1);imshow(RGB),title('ԭʼͼ��');

%RGB->YUV
YUV=rgb2ycbcr(RGB);
subplot(2,2,2);imshow(uint8(YUV));title('YUVͼ��');

T=dctmtx(8);

%DCT�任
BY=blkproc(Y,[8 8],'P1*x*P2',T,T');
BU=blkproc(U,[8 8],'P1*x*P2',T,T');
BV=blkproc(V,[8 8],'P1*x*P2',T,T');
%������
a=[16 11 10 16 24 40 51 61;  
      12 12 14 19 26 58 60 55;  
      14 13 16 24 40 57 69 55;  
      14 17 22 29 51 87 80 62;  
      18 22 37 56 68 109 103 77;  
      24 35 55 64 81 104 113 92;  
      49 64 78 87 103 121 120 101;  
      72 92 95 98 112 100 103 99;];  %��Ƶ
    
  b=[17 18 24 47 99 99 99 99;  
      18 21 26 66 99 99 99 99;  
      24 26 56 99 99 99 99 99;  
      47 66 99 99 99 99 99 99;  
      99 99 99 99 99 99 99 99;  
      99 99 99 99 99 99 99 99;  
       99 99 99 99 99 99 99 99;  
       99 99 99 99 99 99 99 99;]; %��Ƶ
%������
  BY=blkproc(BY,[8 8],'x./P1',a);
  BU=blkproc(BU,[8 8],'x./P1',b);
  BV=blkproc(BV,[8 8],'x./P1',b);
  BY=int8(BY);
  BU=int8(BU);
  BV=int8(BV);
  
  %��������
  BY=blkproc(BY,[8 8],'x.*P1',a);
  BU=blkproc(BU,[8 8],'x.*P1',b);
  BV=blkproc(BV,[8 8],'x.*P1',b);
  
  mask=[    %����������ϵ��
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;];  
     %BY BU BV��double����  
     BY=blkproc(BY,[8 8],'P1.*x',mask);  
     BU=blkproc(BU,[8 8],'P1.*x',mask);  
     BV=blkproc(BV,[8 8],'P1.*x',mask);  
          
     %YI UI VI��double����  %DCT���任
     YI=blkproc(double(BY),[8 8],'P1*x*P2',T',T);  
     UI=blkproc(double(BU),[8 8],'P1*x*P2',T',T);  
     VI=blkproc(double(BV),[8 8],'P1*x*P2',T',T);
     
     IYUV=cat(3,YI,UI,VI);%ѹ�����ͼ��IYUV
     IYUV=uint8(IYUV);
     subplot(2,2,3);imshow(IYUV),title('ѹ�����YUVͼ��');
     
    %YUV->RGB
    RI=YI-0.001*UI+1.402*VI;
    GI=YI-0.344*UI-0.714*VI;
    BI=YI+1.772*UI+0001*VI;
    IRGB=cat(3,RI,GI,BI);
    IRGB=uint8(IRGB);
   subplot(2,2,4);imshow(IRGB),title('ѹ�����ͼ��RGBͼ��');
   figure,imshow(RGB-IRGB),title('ѹ�����ͼ��RGBͼ��');
     disp('ѹ����ͼ��IRGB��С');whos('IRGB');
     disp('ѹ��ǰͼ��YUV��С');whos('YUV');
     disp('ѹ��ǰͼ��RGB��С');whos('RGB');
     
     
  