//
//  BundleTools.m
//  CustomControls
//
//  Created by qiujian on 16/4/29.
//  Copyright © 2016年 jdfemqi. All rights reserved.
//

#import "BundleTools.h"

@implementation BundleTools

+ (NSBundle *)getBundle{
    
    return [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: BUNDLE_NAME ofType: @"bundle"]];
}

+ (NSString *)getBundlePath: (NSString *) assetName{
    
    NSBundle *myBundle = [BundleTools getBundle];
    
    if (myBundle && assetName) {
        
        return [[myBundle resourcePath] stringByAppendingPathComponent: assetName];
    }
    
    return nil;
}

@end
