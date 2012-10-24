//
//  CAAnimation+SpecialAnimations.h
//  ClearPath
//
//  Created by Lawrence Tran on 9/7/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (SpecialAnimations)

+ (CAAnimation *)popInAnimationWithDuration:(CFTimeInterval)duration;
+ (CAAnimation *)rubberBandAnimationFromPosition:(CGPoint)fromPosition toPosition:(CGPoint)toPosition duration:(CFTimeInterval)duration;
+ (CAAnimation *)wobbleAnimationFromPosition:(CGPoint)fromPosition toPosition:(CGPoint)toPosition duration:(CFTimeInterval)duration;
+ (CAAnimation *)rotationAnimationWithDuration:(NSTimeInterval)duration;

@end
