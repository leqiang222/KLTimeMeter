//
//  KLTimeMeterInterval.m
//  Pods
//
//  Created by jinglian on 2021/1/29.
//  
//
//  Description: <#文件描述#>
//  History:
//    1. 2021/1/29 [jinglian]: 创建文件;
//

#import "KLTimeMeterInterval.h"

@implementation KLTimeMeterInterval

+ (instancetype)timeInterval:(NSInteger)timeInterval {
    KLTimeMeterInterval *object = [KLTimeMeterInterval new];
    object.timeInterval = timeInterval;
    return object;
}

@end
