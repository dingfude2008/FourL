//正常的字库转换为竖立显示的字库，转换之后不管是中文还是英文都变成了12x12点
//Data:原始字库数据，DataNEW：转换为竖立显示之后的数据，Longs数据长度，中文Longs=18,英文Longs=9
void N_S(unsigned char Data[],unsigned char DataNEW[],char Longs)
{
  int i,j,CS=0;
  unsigned char LS1,LS2,LS;
  
  unsigned char DataLS[20];
  if(Longs==9)
  {
    //1.填充开头的2列
    DataLS[0]=0;
    DataLS[1]=0;
    DataLS[2]=0;
    //2.中间部分的数据
    for(i=0;i<9;i++)
    {
      DataLS[i+3]=Data[i];
    }
    //3.填充尾部的4列
    DataLS[12]=0;
    DataLS[13]=0;
    DataLS[14]=0;
    
    DataLS[15]=0;
    DataLS[16]=0;
    DataLS[17]=0;
  }
  else
  {
    for(i=0;i<Longs;i++)
    {
      DataLS[i]=Data[i];
    }
  }
  
  for(i=0;i<3;i++)
  {
    for(j=15+i;j>0;j-=6)
    {
      LS=(DataLS[j]<<1)&0x80;//6移到7位置
      LS1=(DataLS[j]<<2)&0x40;//4移到6位置
      LS|=LS1;
      LS1=(DataLS[j]>>2)&0x20;//7移到5位置
      LS|=LS1;
      LS1=(DataLS[j]>>1)&0x10;//5移到4位置
      LS|=LS1;
      
      LS=(DataLS[j-3]>>3)&0x08;//6移到3位置
      LS1=(DataLS[j-3]>>2)&0x04;//4移到2位置
      LS|=LS1;
      LS1=(DataLS[j-3]>>6)&0x02;//7移到1位置
      LS|=LS1;
      LS1=(DataLS[j-3]>>5)&0x01;//5移到0位置
      LS|=LS1;
      DataNEW[CS]=LS;
      
      LS=(DataLS[j]<<5)&0x80;//2移到7位置
      LS1=(DataLS[j]<<6)&0x40;//0移到6位置
      LS|=LS1;
      LS1=(DataLS[j]<<2)&0x20;//3移到5位置
      LS|=LS1;
      LS1=(DataLS[j]<<3)&0x10;//1移到4位置
      LS|=LS1;
      
      LS=(DataLS[j-3]<<1)&0x08;//2移到3位置
      LS1=(DataLS[j-3]<<2)&0x04;//0移到2位置
      LS|=LS1;
      LS1=(DataLS[j-3]>>2)&0x02;//3移到1位置
      LS|=LS1;
      LS1=(DataLS[j-3]>>1)&0x01;//1移到0位置
      LS|=LS1;
      DataNEW[CS+3]=LS;
      CS++;
    }
    CS+=3;
  } 
}