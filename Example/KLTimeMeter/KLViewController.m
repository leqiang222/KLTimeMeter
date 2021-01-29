//
//  KLViewController.m
//  KLTimeMeter
//
//  Created by leqiang222@163.com on 01/29/2021.
//  Copyright (c) 2021 leqiang222@163.com. All rights reserved.
//

#import "KLViewController.h"
#import "KLTimeTableController.h"

@interface KLViewController ()

@end

@implementation KLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"首页";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    KLTimeTableController *vc = [[KLTimeTableController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
     
    
    double a = CFAbsoluteTimeGetCurrent();
    double b = [[NSDate date] timeIntervalSince1970];

    NSLog(@"a: %f, %@", a, [self time:a]);
    NSLog(@"b: %f, %@", b, [self time:b]);
}

- (NSString *)time:(double)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
       
   NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
   dateFromatter.dateFormat = @"YYYY-MM-dd HH:mm";
    
    return [dateFromatter stringFromDate:date];
}
 
@end
