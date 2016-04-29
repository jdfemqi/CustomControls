//
//  IAMICObject.h
//  IAMIC
//
//  Created by jdfemqi on 16/2/26.
//  Copyright © 2016年 jdfemqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IAMICObject : NSObject

- (void)setConfigure: (UIView *)superView : (CGRect)showRect;
- (void)setResourcePath: (NSString*)plistPath : (NSString*)resourcePath;

// 自动循环
- (void)shouldAutoShow:(BOOL)shouldStart;

@end
