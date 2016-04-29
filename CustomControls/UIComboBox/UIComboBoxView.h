//
//  UIComboBoxView.h
//  UIComboBox
//
//  Created by qiujian on 16/4/12.
//  Copyright © 2016年 jdfemqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIComboBoxViewDelegate
- (void) selChange: (NSInteger) nItem;
@end

@interface UIComboBoxView : UIView

@property (nonatomic, strong) id <UIComboBoxViewDelegate> delegate;

// 点击隐藏窗口
-(void)configClickHiddenView:(UIView*)viewSuper;

// 控件显示区域
-(void)setFrame:(CGRect)frame;

// 添加条目
-(void)addItem:(NSString*)strTitle :(UIImage*)image;
@end
