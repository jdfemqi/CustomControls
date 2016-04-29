//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

#define HeightForRow        40

/*为了捕捉touches消息，touches消息只会向被点击的view的父视图传递*/
@interface NIDropDownOverlay : UIView
@end

@implementation NIDropDownOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touched = [[touches anyObject] view];
    if (touched == self) {
        
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[NIDropDown class]]
                && [v respondsToSelector:@selector(hideDropDown:)]) {
                
                NIDropDown* dropDown = (NIDropDown*)v;
                [v performSelector:@selector(hideDropDown:) withObject:dropDown.btnSender];
            }
        }
    }
}

@end

@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;


@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSArray *imageList;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;

// 最佳高度
-(CGFloat)optimumHeight:(CGFloat)height : (NSInteger)nCount
{
    CGFloat optimumHeight = height;
    
    if (optimumHeight > nCount * HeightForRow) {
        optimumHeight = nCount * HeightForRow;
        
        // 禁止滚动
        table.scrollEnabled = NO;
    }
    else
    {
        table.scrollEnabled = YES;
    }
    
    return  optimumHeight;
}

- (id)showDropDown:(UIView *)b :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction :(UIView*)overlaySuper {
    [self setUserInteractionEnabled:YES];
    
    CGFloat optimumHeight = [self optimumHeight:*height :arr.count];
    
    btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        // 窗口相对屏幕的位置
        CGRect frSuper = [btnSender convertRect:btnSender.bounds toView:nil];
        CGRect btn = frSuper;
        self.list = [NSArray arrayWithArray:arr];
        self.imageList = [NSArray arrayWithArray:imgArr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            //self.layer.shadowOffset = CGSizeMake(-5, -5);
       }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
       }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        //self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        CGRect rcTable = CGRectMake(0, 0, self.frame.size.width, optimumHeight);
        table = [[UITableView alloc] initWithFrame:rcTable];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor grayColor];
        
        // 网格线左对齐
        [table setSeparatorInset:UIEdgeInsetsZero];
        [table setLayoutMargins:UIEdgeInsetsZero];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-optimumHeight, btn.size.width, optimumHeight);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, optimumHeight);
        }
        
        [UIView commitAnimations];
        
        NIDropDownOverlay *overlay = [[NIDropDownOverlay alloc] initWithFrame:overlaySuper.frame];
        [overlay addSubview:self];
        [overlaySuper addSubview:overlay];
        
        //[b.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown:(UIView *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
    
    if ([self.superview isKindOfClass:[NIDropDownOverlay class]])
    {
        [self myDelegate];
        [self.superview removeFromSuperview];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HeightForRow;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //cell.textLabel.textAlignment = UITextAlignmentCenter; // 文本局中
    }
    if ([self.imageList count] == [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        cell.imageView.image = [imageList objectAtIndex:indexPath.row];
    } else if ([self.imageList count] > [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    } else if ([self.imageList count] < [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    // 网格线左对齐
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    
    self.selCell = [tableView cellForRowAtIndexPath:indexPath];
    
    for (UIView *subview in btnSender.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    imgView.image = self.selCell.imageView.image;
    imgView = [[UIImageView alloc] initWithImage:self.selCell.imageView.image];
    imgView.frame = CGRectMake(5, 5, 25, 25);
    [btnSender addSubview:imgView];
    [self myDelegate];
}

- (void) myDelegate {
    [self.delegate niDropDownDelegateMethod:self];
}

@end
