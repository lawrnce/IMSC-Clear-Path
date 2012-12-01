//
//  UIImage+Loading.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/30/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "UIImage+Loading.h"

@implementation UIImage (Loading)

+ (UIImage *)uncachedImageNamed:(NSString *)name;
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]];
    return [[UIImage alloc] initWithContentsOfFile:path];
}

@end
