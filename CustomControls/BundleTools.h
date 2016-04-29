//
//  BundleTools.h
//  CustomControls
//
//  Created by qiujian on 16/4/29.
//  Copyright © 2016年 jdfemqi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BUNDLE_NAME @"CustomControls"


@interface BundleTools : NSObject

+ (NSString *)getBundlePath: (NSString *) assetName;
+ (NSBundle *)getBundle;

@end
