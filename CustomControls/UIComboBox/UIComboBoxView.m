//
//  UIComboBoxView.m
//  UIComboBox
//
//  Created by qiujian on 16/4/12.
//  Copyright © 2016年 jdfemqi. All rights reserved.
//

#import "UIComboBoxView.h"
#import "NIDropDown.h"

@interface UIComboBoxView ()
{
    NIDropDown *dropDown;
    UITextField *tfText;   // 显示文本
    
    NSMutableArray * arr;          // 存储文本
    NSMutableArray * arrImage;     // 条目图标
}

@property(nonatomic, weak) UIButton *btnDropDown;
@property(nonatomic, weak) UIView* viewSuper; // 点击可隐藏下拉列表的窗口
@end

@implementation UIComboBoxView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // 创建单元
        CGRect rc = CGRectMake(0, 0, frame.size.width, frame.size.height);
        CGRect rcTF = CGRectMake(0, 0, rc.size.width - 50, rc.size.height);
        //CGRect rcBtn = CGRectMake(rc.size.width - 50, 0, 50, rc.size.height);
        CGRect rcBtn = CGRectMake(0, 0, 100, 30);
        
        tfText = [[UITextField alloc]initWithFrame:rcTF];
        tfText.text = @"123";

        // 直接赋值给self.btnDropDown，不成功
        UIButton* btnTemp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        if (btnTemp != nil) {
            NSLog(@"btnTemp创建成功");
        }
        self.btnDropDown = btnTemp;
        self.btnDropDown.frame = rcBtn;
        [self.btnDropDown setTitle:@"btn" forState:UIControlStateNormal];
        self.btnDropDown.backgroundColor = [UIColor redColor];
        self.btnDropDown.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        self.btnDropDown.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self.btnDropDown addTarget:self action:@selector(btnPress:)forControlEvents:UIControlEventTouchUpInside];
        
        //[self addSubview:tfText];
        [self addSubview:self.btnDropDown];
    }
    
    self.backgroundColor = [UIColor greenColor];
    
    NSLog(@"UIComboBox创建成功");
    
    dropDown = nil;
    arr = [[NSMutableArray alloc] init];
    arrImage = [[NSMutableArray alloc] init];
    return self;
}

// 点击隐藏窗口
-(void)configClickHiddenView:(UIView*)viewSuper
{
    self.viewSuper = viewSuper;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect rc = CGRectMake(0, 0, frame.size.width, frame.size.height);
    //CGRect rcTF = CGRectMake(0, 0, rc.size.width - 50, rc.size.height);
    //CGRect rcBtn = CGRectMake(rc.size.width - 50, 0, 50, rc.size.height);
    
    //tfText.frame = rcTF;
    self.btnDropDown.frame = rc;
}

// 添加条目
-(void)addItem:(NSString*)strTitle :(UIImage*)image
{
    [arr addObject:strTitle];
    if (image != nil) {
        [arrImage addObject:image];
    }
}

-(void)btnPress:(id)sender
{
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:self:&f :arr :arrImage :@"down" :self.viewSuper];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
    // 条目点击事件
    if (sender.selCell != nil) {
        [self.btnDropDown setTitle:sender.selCell.textLabel.text forState:UIControlStateNormal];
        
        
        UITableView *table = (UITableView *)sender.selCell.superview.superview;
        
        int numOfSelectedCell = [table indexPathForCell:sender.selCell].row;
        
        [self.delegate selChange:numOfSelectedCell];
    }
    
    [self rel];
}

-(void)rel{
    
    dropDown = nil;
}

@end
