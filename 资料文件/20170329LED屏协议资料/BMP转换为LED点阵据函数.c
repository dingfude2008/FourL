   ��������Ǹ���VB.net�ĸ������ģ������ο�
 //ͼƬ�������ݵ����ɺϳ�
    void Plice_Data(ByVal im1 As Bitmap) //ͼƬ���ݵ�����
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
            colo = im1.GetPixel(i, j);//���ͼƬĳ����ɫֵ
            n = n << 1;
            
            if ((colo.R <= 256)&&(colo.R >= 158)) //��ɫ
                n = n | 1;
            
            colo = im1.GetPixel(i+1, j);//���ͼƬĳ����ɫֵ
            n = n << 1;
            
            if((colo.R <= 256)&&(colo.R >= 158)&&(colo.G < 60)) //��ɫ
              n = n | 1;
            
             if((j + 1)%4==0)
             {
               ColorD[CS]=n;
               CS++;
               n=0;
             }
          }  
        }
        PingShu += 1 //������Ŀ���������ļ���ֵ
    }