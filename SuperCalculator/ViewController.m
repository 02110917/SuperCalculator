//
//  ViewController.m
//  Giac
//
//  Created by zhangmin on 15/1/23.
//  Copyright (c) 2015年 zhangmin. All rights reserved.
//

#import "ViewController.h"
#include "giac_test.h"
#include "mgl_test.h"
#include "mgl_bigmap.h"
#import "ImageHelper.h"
@interface ViewController ()<UITextViewDelegate>
@property(strong,nonatomic) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    init();
    self.tvInput.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    destory();
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.tvInput resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        NSString*inputStr=[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            char*error=alloca(sizeof(char)*256);
            UIImage *image=doCalculate(inputStr,error);
            if(image){
                
            }else{
                NSLog(@"error:%s",error);
            }
//            free(error);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                if(_imageView){
                    [_imageView removeFromSuperview];
                }
                _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 100, image.size.width, image.size.height)];
                _imageView.image=image;
                [self.scrollView addSubview:_imageView];
                
            });
        });
        return NO;
    }
    return YES;
}
@end
