//
//  giac_test.cpp
//  Giac
//
//  Created by zhangmin on 15/1/23.
//  Copyright (c) 2015年 zhangmin. All rights reserved.
//

#include "giac/giac.h"
#import <Foundation/Foundation.h>
#import "RegexKitLite.h"
#import <UIKit/UIKit.h>
#include "latex_result.h"
#include "mgl_test.h"
#include "mgl_bigmap.h"
#import "ImageHelper.h"
using namespace std;
using namespace giac;
extern "C" struct result*	CreateGifFromEq ( const char *expression);
extern "C" NSString* doClaculate(NSString*str);
extern "C" void init();
extern "C" void destory();
extern "C" struct calResule cal_result;
context *ct;
extern "C" void destory(){
    delete ct;
}
extern "C" void init(){
    ct=new context;
    
}
extern "C" NSString* doClaculate(NSString* str){
    gen e([str UTF8String],ct);
    std::ostringstream stream;
    ct->globalptr->_logptr_=&stream;
    gen result=_eval(e, ct);
    //    cout<<_factor(result, &ct)<<":"<< result<<endl;
    //    return replaceAll((char*)(gen2tex(result, &ct).c_str()), "\\", "\\\\");
    //    replace((gen2tex(result, &ct).c_str()),"","");
    cout<<stream.str()<<endl;
    cout<<gen2string(result)<<endl;
    return [[NSString alloc]initWithUTF8String:gen2string(result).c_str()];
    //    return gen2tex(result, ct).c_str();
    
}
extern "C" UIImage* doCalculate(NSString*input,char*error);

extern "C" UIImage* doCalculate(NSString*input,char*error){
    
    std::ostringstream stream;
    ct->globalptr->_logptr_=&stream;
    try{
        gen e([input UTF8String],ct);
        gen result=_eval(e, ct);
        NSString*str=[[NSString alloc]initWithUTF8String:gen2string(result).c_str()];
        if([str rangeOfRegex:@"curve|hypersurface"].length>0){ //绘图
            mgl_bigmap *bitmap=(struct mgl_bigmap*) malloc(sizeof(struct mgl_bigmap));
            int result=parsePlotData(str,bitmap);
            UIImage*image=[ImageHelper convertBitmapRGBA8ToUIImage:bitmap->data withWidth:bitmap->width withHeight:bitmap->height];
            return image;
        }else{
            struct result* res=CreateGifFromEq(gen2tex(result, ct).c_str());
            NSData *imageData = [NSData dataWithBytes:res->c length:res->size];
            UIImage *aimage = [UIImage imageWithData: imageData];
            NSLog(@"w=%f,h=%f",aimage.size.width,aimage.size.height);
            free(res);
            return aimage;
        }
    }catch(...){
        cout<<stream.str()<<endl;
        memcpy(&error, stream.str().c_str(), strlen(stream.str().c_str()));
        return nil;
    }
}