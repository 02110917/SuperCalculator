//
//  giac_test.h
//  Giac
//
//  Created by zhangmin on 15/1/23.
//  Copyright (c) 2015年 zhangmin. All rights reserved.
//

#ifndef __Giac__giac_test__
#define __Giac__giac_test__

#include <stdio.h>
#import <Foundation/Foundation.h>
NSString* doClaculate(NSString *str);
UIImage*doCalculate(NSString*input,char*error);
void init();
void destory();
struct calResule
{
    const char* result;
    const char *error;
    const bool is_error;
};
#endif /* defined(__Giac__giac_test__) */
