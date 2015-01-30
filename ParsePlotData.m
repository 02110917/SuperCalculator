//
//  ParsePlotData.m
//  SuperCalculator
//
//  Created by zhangmin on 15/1/27.
//  Copyright (c) 2015年 zhangmin. All rights reserved.
//
#import <Foundation/Foundation.h>
#include "ParsePlotData.h"
#import "RegexKitLite.h"//i 3.0 3.0*i 3.0+1.0*i
//#import "mgl2/mgl.h"
//static NSString*complexRegex=@"(\\-{0,1}\\d+\\.\\d+(e(\\+|\\-)\\d+){0,1}){0,1}((\\-|\\+){0,1}\\d+\\.\\d+(e(\\+|\\-)\\d+){0,1}){0,1}";
////group\\[(\\-{0,1}(\\d+\\.\\d+){0,1}(e(\\+|\\-)\\d+){0,1}(\\-|\\+){0,1}(\\d+\\.\\d+(e(\\+|\\-)\\d+){0,1}\\*){0,1}i(,){0,1})+\\]
//static NSString* regex2D=@"group\\[([\\+\\-\\d\\w\\*\\.\\,]+)+\\]";
//void parsePlotData(NSString *data){
////    NSLog(@"data-->%@",str);
//    NSArray*arr=[data componentsMatchedByRegex:regex2D];
//    for(NSString*s in arr){
//        NSLog(@"s-->%@",s);
//    }
//}
