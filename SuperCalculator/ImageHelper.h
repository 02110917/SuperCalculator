//
//  ImageHelper.h
//  MathGL
//
//  Created by administrator on 15/1/27.
//  Copyright (c) 2015年 zhangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ImageHelper : NSObject
+ (UIImage *) convertBitmapRGBA8ToUIImage:(const unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height;
@end
