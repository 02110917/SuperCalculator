//
//  mgl_test.cpp
//  MathGL
//
//  Created by administrator on 15/1/26.
//  Copyright (c) 2015年 zhangmin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RegexKitLite.h"//i 3.0 3.0*i 3.0+1.0*i
#include "mgl.h"
#include "mgl_bigmap.h"
#include "giac/giac.h"
using namespace giac;
static NSString* regex2D=@"group\\[([\\+\\-\\d\\w\\*\\.\\,]+)+\\]";
static NSString*regex3D=@"group\\[group\\[point[\\[\\]\\+\\-\\d(e)(point)(group)\\*\\.\\,]+\\]\\]\\]";
static NSString*regex3D_Group=@"group\\[[\\[\\]\\+\\-\\d(e)(point)\\*\\.\\,]+\\]\\]";
static NSString*regex3D_Point=@"point\\[[\\+\\-\\d(e)\\*\\.\\,]+\\]";
void parse_and_plod2d(NSString *data,struct mgl_bigmap *bitmap);
void parse_and_plod3d(NSString *data,struct mgl_bigmap *bitmap);
 int parsePlotData(NSString *data,struct mgl_bigmap *bitmap){
    if([data rangeOfString:@"curve"].length>0){
        parse_and_plod2d(data,bitmap);
    }else if([data rangeOfString:@"hypersurface"].length>0){
        parse_and_plod3d(data,bitmap);
    }else{
        return -1;
    }
    return 0;

}
void parse_and_plod2d(NSString *data,struct mgl_bigmap *bitmap){
    NSArray*arr=[data componentsMatchedByRegex:regex2D];
    if(arr&&arr.count>0){
        int count=arr.count;
        int pointCount;
        mglData data;
        NSArray*firstSplitArray=[[[arr objectAtIndex:0] stringByReplacingOccurrencesOfRegex:@"group\\[|\\]" withString:@""] componentsSeparatedByRegex:@"\\,"];
        if(firstSplitArray&&firstSplitArray.count>0){
            pointCount=firstSplitArray.count;
            data.Create(pointCount,count);
        }else{
            return;
        }
        double range_a=0,range_b=0;
        for(int i=0;i<count;i++){
            NSString*s=[arr objectAtIndex:i];
//            NSLog(@"s-->%@",s);
            NSArray  *splitArray   = NULL;
            if(i==0)
                splitArray=firstSplitArray;
            else
                splitArray = [[s stringByReplacingOccurrencesOfRegex:@"group\\[|\\]" withString:@""] componentsSeparatedByRegex:@"\\,"];
            
            if(splitArray&&splitArray.count>0){
                for(int j=0;j<pointCount;j++){ //-4.925-4.925*i
                    NSString*pointStr=[splitArray objectAtIndex:j];
                    //                NSString*reStr=[[NSString alloc] initWithFormat:@"re(%@)",pointStr];
                    //                NSString*reStr=[[NSString alloc] initWithFormat:@"im(%@)",pointStr];
                    context ct;
                    gen e(pointStr.UTF8String,&ct);
                    std::complex<double> complex=gen2complex_d(_eval(e, &ct));
                    if(j==0&&range_a==0)
                        range_a=complex.real();
                    
                    if(j==pointCount-1&range_b==0)
                        range_b=complex.real();
//                    NSLog(@"re=%f im=%f",complex.real(),complex.imag());
                    data.a[j+pointCount*i]=complex.imag();
                }
            }
            mglGraph gr;
            gr.SetOrigin(0, 0);
            gr.Box();
            gr.SetRange('x', range_a, range_b);
            gr.Axis();
            //            gr.Label('x', "X");
            //            gr.Label('y', "Y");
            gr.Plot(data);
            bitmap->width=gr.GetWidth();
            bitmap->height=gr.GetHeight();
            bitmap->data=gr.GetRGBA();
        }
    }
}
void parse_and_plod3d(NSString *data,struct mgl_bigmap *bitmap){
    NSArray*arr=[data componentsMatchedByRegex:regex3D];
    mglData a;
    mglGraph gr;
    gr.Light(true);
    gr.Rotate(50,60);
    gr.Box();
    gr.SetOrigin(0, 0,0);
    gr.Axis();
    int count_z=arr.count;
    NSArray*first_groups=[[arr objectAtIndex:0] componentsMatchedByRegex:regex3D_Group];
    NSArray*first_points=[[first_groups objectAtIndex:0] componentsMatchedByRegex:regex3D_Point];
    int count_y=first_groups.count;
    int count_x=first_points.count;
    a.Create(count_x,count_y);
    for(int i=0;i<count_z;i++){
        NSString*s=[arr objectAtIndex:i];
        NSArray*groups;
        if(i==0)
            groups=first_groups;
        else
            groups=[s componentsMatchedByRegex:regex3D_Group];
        for(int j=0;j<count_y;j++){
            NSString*group=[groups objectAtIndex:j];
            NSArray*points=[group componentsMatchedByRegex:regex3D_Point];
            for(int k=0;k<count_x;k++){
//                NSLog(@"x=%d,y=%d,z=%d i=%d,j=%d,k=%d",count_x,count_y,count_z,i,j,k);
                NSString*point=[points objectAtIndex:k];
//                NSLog(@"point--:%@",point);
                NSString*p=[point stringByReplacingOccurrencesOfRegex:@"point|\\[|\\]" withString:@""];
                NSArray*ps=[p componentsSeparatedByRegex:@"\\,"];
                if(ps&&ps.count==3){
//                    double x=[[ps objectAtIndex:0] doubleValue];
//                    double y=[[ps objectAtIndex:1] doubleValue];
                    double z=[[ps objectAtIndex:2] doubleValue];
                    a.a[j+count_x*k]=z;
                }
            }
        }
        gr.Surf(a);
    }
    NSLog(@"-----");
    bitmap->width=gr.GetWidth();
    bitmap->height=gr.GetHeight();
    bitmap->data=gr.GetRGBA();
}