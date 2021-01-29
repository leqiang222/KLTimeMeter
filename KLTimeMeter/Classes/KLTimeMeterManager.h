//
//  KLTimeMeterManager.h
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


static NSString *const kTimeMeterUpdateNotification = @"kTimeMeterUpdateNotification";

@interface KLTimeMeterManager : NSObject

/**
 *  时间差(单位:秒) 
 */
//@property (nonatomic, assign) NSInteger timeInterval;

/**
 *  单例
 */
+ (instancetype)manager;

/**
 *  开始倒计时
 */
- (void)start;

/**
 *  停止倒计时，停止后无法继续
 */
//- (void)invalidate;
 
/**
 *  添加倒计时源
 *  该identifier如果之前添加过，则会重置倒计时
 *  @param identifier 建议使用随机生成的UUID
 */
- (void)addSourceWithIdentifier:(NSString *)identifier;

/** 获取时间差 */
- (NSInteger)timeIntervalWithIdentifier:(NSString *)identifier;

/** 刷新倒计时源 */
- (void)reloadSourceWithIdentifier:(NSString *)identifier;

/** 刷新所有倒计时源 */
- (void)reloadAllSource;

/** 清除倒计时源 */
- (void)removeSourceWithIdentifier:(NSString *)identifier;

/** 清除所有倒计时源 */
- (void)removeAllSource;
 
@end

NS_ASSUME_NONNULL_END
