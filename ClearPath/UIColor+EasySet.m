//
//  UIColor+EasySet.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/23/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "UIColor+EasySet.h"

@implementation UIColor (EasySet)

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;
{
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

@end
