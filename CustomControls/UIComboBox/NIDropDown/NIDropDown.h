//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
@end

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}


@property(nonatomic, strong) UITableViewCell *selCell;
@property(nonatomic, strong) UIView *btnSender;
@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
-(void)hideDropDown:(UIView *)b;
- (id)showDropDown:(UIView *)b :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction :(UIView*)overlay;
@end
