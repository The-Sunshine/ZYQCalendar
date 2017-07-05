//
//  ViewController.m
//  日历
//
//  Created by zyq on 2017/5/16.
//  Copyright © 2017年 zyq. All rights reserved.
//

#import "ViewController.h"
#import "ZYQCalenderView.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    ZYQCalenderView * calender = [[ZYQCalenderView alloc]init];
    calender.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 250);
    [self.view addSubview:calender];
}

@end
