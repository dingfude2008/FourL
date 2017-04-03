   
void Plice_Data( char ColorD[]) //还原显示数据
{  
  int i, j,CS=0;
  char n = 0;
  char im1[12][12];//代表一个像素为12x12的图片
  CS=0;
  char Longs;
  Longs=12;//控制列的,如果为中文这个值=12，英文则=6
  for(i=0;i<Longs;i+=2)//控制列的
  {
    n = ColorD[CS];
    for(j=0;j<4;j++)//0到3行
    {
      if(n&0x80)
      {
        im1[i,j]=1;
      }
      else
      {
        im1[i,j]=0;
      }
      n <<=1;
      
      if(n&0x80)
      {
        im1[i+1,j]=1;
      }
      else
      {
        im1[i+1,j]=0;
      }
      n <<=1;
    }
    
    n = ColorD[CS+1];
    for(j=4;j<8;j++)//4到7行
    {
      if(n&0x80)
      {
        im1[i,j]=1;
      }
      else
      {
        im1[i,j]=0;
      }
      n <<=1;
      
      if(n&0x80)
      {
        im1[i+1,j]=1;
      }
      else
      {
        im1[i+1,j]=0;
      }
      n <<=1;
    }
    
    n = ColorD[CS+2];
    for(j=8;j<12;j++)//8到11行
    {
      if(n&0x80)
      {
        im1[i,j]=1;
      }
      else
      {
        im1[i,j]=0;
      }
      n <<=1;
      
      if(n&0x80)
      {
        im1[i+1,j]=1;
      }
      else
      {
        im1[i+1,j]=0;
      }
      n <<=1;
    }
    CS+=3; 
}