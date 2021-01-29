//
//  KLTimeMeterInterval.h
//  Pods
//
//  Created by jinglian on 2021/1/29.
//  
//
//  Description: <#文件描述#>
//  History:
//    1. 2021/1/29 [jinglian]: 创建文件;
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLTimeMeterInterval : NSObject

 
@property (nonatomic, assign) NSInteger timeInterval;

+ (instancetype)timeInterval:(NSInteger)timeInterval;

@end

NS_ASSUME_NONNULL_END
