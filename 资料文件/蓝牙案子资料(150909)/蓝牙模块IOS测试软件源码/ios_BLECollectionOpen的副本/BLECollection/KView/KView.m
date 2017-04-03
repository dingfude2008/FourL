//
//  KView.m
//  BLECollection
//
//  Created by rfstar on 13-12-24.
//  Copyright (c) 2013年 rfstar. All rights reserved.
//

#import "KView.h"
#import "Tools.h"
@implementation KView

{
    UIImage * normalImage ,*pressedImage;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (void) initView :(BarItem *) item
{
    
    normalImage =[UIImage imageNamed: item.imageNormal];
    pressedImage = [UIImage imageNamed: item.imagePressed];
    
      float instance = 10;
      _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(instance, instance/2, HEIGHT-instance, HEIGHT-instance*2)];

    [_imageview setContentMode:UIViewContentModeScaleAspectFit];
    if(item.imageNormal != NULL)
        [_imageview setImage:normalImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(instance,3+_imageview.frame.origin.y+_imageview.frame.size.height, _imageview.frame.size.width,instance)];
    [self.nameLabel setBackgroundColor:[UIColor clearColor]];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    if([[[UIDevice currentDevice]systemVersion]intValue] > 6)
    {
        [_nameLabel setTextColor:[UIColor blueColor]];
    }
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.nameLabel setFont:[UIFont systemFontOfSize:10]];
    if(item.name != NULL)
        [self.nameLabel setText:item.name];

    [self addSubview:_imageview];
    [self addSubview:self.nameLabel];
    
    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchDown:(id)sender  //按下时的事件
{
    [_imageview setImage:pressedImage];
    [_nameLabel setTextColor:[UIColor cyanColor]];
    if([[[UIDevice currentDevice]systemVersion]intValue] > 6)
    {
        [_nameLabel setTextColor:[Tools colorWithHexString:@"#B0E2FF"]];
    }
    [_imageview setNeedsDisplay];
    [_nameLabel setNeedsDisplay];

}
-(void)touchUp:(id)sender   //放开后的事件
{
    [_imageview setImage:normalImage];
    [self.delegate kViewOnClick:self Position:self.position];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    if([[[UIDevice currentDevice]systemVersion]intValue] > 6)
    {
        [_nameLabel setTextColor:[UIColor blueColor]];
    }
    [_imageview setNeedsDisplay];
    [_nameLabel setNeedsDisplay];
    
    NSLog(@"touchup");
}


@end
