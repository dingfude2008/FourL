//
//  DialogListView.m
//  BLECollection
//
//  Created by rfstar on 14-4-29.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "DialogListView.h"
#import "Tools.h"
@implementation DialogListView
{
    UIView             *parent;
    DialogView         *dialog;
    NSString           *meeageHex;
}
-(id)initNib
{
    return  self;
}
-(void)showView:(UIView *)parentView
{
    dialog = [[DialogView alloc] initNib];
    [dialog setDelegate:self];
    [dialog showDialogView:parentView];
    parent = parentView;
}
-(UIView *)dialogContentView
{
    CGRect    frame;
    float y = 80;
    if([Tools currentResolution] == UIDevice_iPhone4s)
    {
        frame = CGRectMake(10, y,300 , 480-y*2);
    }else if([Tools currentResolution ] == UIDevice_iPhone5){
        frame = CGRectMake(10, y, 300, 568-y*2);
    }
    
     _title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 45)];
    [_title setBackgroundColor:[UIColor clearColor]];
    [_title setFont:[UIFont systemFontOfSize:18]];
    [_title setTextAlignment:NSTextAlignmentCenter];
    [_title setText:@"列表"];
    CGRect listframe  = CGRectMake(0,_title.frame.size.height, frame.size.width, frame.size.height-_title.frame.size.height);
    _listView = [[UITableView alloc]initWithFrame:listframe];
    _listView.layer.cornerRadius = [_title.layer cornerRadius];
    [_listView setDelegate:self];
    [_listView setDataSource:self];
    [parent addSubview:_listView];
    
    UIView  *contentView = [[UIView alloc]initWithFrame:frame];
    [contentView setBackgroundColor:[Tools colorWithHexString:@"#e8e6e3"]];
    [contentView.layer setBorderColor:[Tools colorWithHexString:@"#CD00CD"].CGColor];
    [contentView.layer setBorderWidth:1];
    
    [contentView addSubview:_title];
    [contentView addSubview:_listView];
    return contentView;
}
-(void)dialogShow
{
    
}
-(void)dialogDimissed
{
    
}

-(void)setArray:(NSMutableArray *)arrayTmp
{
    array = arrayTmp;
    [_listView reloadData];
}
#pragma mark- UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell ;
    static  NSString   *identifier = @"listtableIdenti";
    if(cell == nil){
         cell=[tableView dequeueReusableCellWithIdentifier:identifier];
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
         [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    Item *item = array[indexPath.row];
    [cell.textLabel setText:item.text];
    [cell.detailTextLabel setText:item.message];
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(array != nil && array.count > 0)
    {
        Item *item = array[indexPath.row];
        [_delegage dialogListItemViewClick:indexPath.row Parameter:item Type:_type];
        [dialog hideDialogView];
    }
}
@end
