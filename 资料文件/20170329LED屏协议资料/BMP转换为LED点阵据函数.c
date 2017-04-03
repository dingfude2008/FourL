   这个函数是根据VB.net的更改来的，仅供参考
 //图片点阵数据的生成合成
    void Plice_Data(ByVal im1 As Bitmap) //图片数据的生成
    {  
        int ColorD[100];
        int colo;
        int i, j,CS=0;
        char n = 0;
        Dim n1 As String;
        for(i=0;i<48;i+=2)
        {
          n = 0;
          for(j=0;j<12;j++)
          {
            colo = im1.GetPixel(i, j);//获得图片某点颜色值
            n = n << 1;
            
            if ((colo.R <= 256)&&(colo.R >= 158)) //红色
                n = n | 1;
            
            colo = im1.GetPixel(i+1, j);//获得图片某点颜色值
            n = n << 1;
            
            if((colo.R <= 256)&&(colo.R >= 158)&&(colo.G < 60)) //红色
              n = n | 1;
            
             if((j + 1)%4==0)
             {
               ColorD[CS]=n;
               CS++;
               n=0;
             }
          }  
        }
        PingShu += 1 //单条节目的总屏数的计算值
    }