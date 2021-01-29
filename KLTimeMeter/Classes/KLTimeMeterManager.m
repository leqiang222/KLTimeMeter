//
//  KLTimeMeterManager.m
//  Pods
//
//  Created by jinglian on 2021/1/29.
//  
//
//  Description: <#文件描述#>
//  History:
//    1. 2021/1/29 [jinglian]: 创建文件;
//

#import "KLTimeMeterManager.h"
#import "KLTimeMeterInterval.h"

@interface KLTimeMeterManager ()
/* 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/* 时间差字典(单位:秒)(使用字典来存放, 支持多列表或多页面使用) */
@property (nonatomic, strong) NSMutableDictionary<NSString *, KLTimeMeterInterval *> *timeIntervalDict;
/* 后台模式使用, 记录进入后台的绝对时间 */
@property (nonatomic, assign) BOOL backgroudRecord;
@property (nonatomic, assign) CFAbsoluteTime lastTime;
@end

@implementation KLTimeMeterManager

+ (instancetype)manager {
    static KLTimeMeterManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KLTimeMeterManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // 监听进入前台与进入后台的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)start {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)invalidate {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)addSourceWithIdentifier:(NSString *)identifier {
    KLTimeMeterInterval *timeInterval = self.timeIntervalDict[identifier];
    if (timeInterval) {
       timeInterval.timeInterval = 0;
    }else {
       [self.timeIntervalDict setObject:[KLTimeMeterInterval timeInterval:0] forKey:identifier];
    }
}

- (NSInteger)timeIntervalWithIdentifier:(NSString *)identifier {
   return self.timeIntervalDict[identifier].timeInterval;
}

- (void)reloadSourceWithIdentifier:(NSString *)identifier {
   self.timeIntervalDict[identifier].timeInterval = 0;
}

- (void)reloadAllSource {
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, KLTimeMeterInterval * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval = 0;
    }];
}

- (void)removeSourceWithIdentifier:(NSString *)identifier {
   [self.timeIntervalDict removeObjectForKey:identifier];
}

- (void)removeAllSource {
   [self.timeIntervalDict removeAllObjects];
}

#pragma mark - Action
- (void)timerAction {
    [self timerActionWithTimeInterval:1];
}

- (void)timerActionWithTimeInterval:(NSInteger)timeInterval {
    // 时间差+
//    self.timeInterval += timeInterval;
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, KLTimeMeterInterval * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval += timeInterval;
    }];
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kTimeMeterUpdateNotification object:nil userInfo:nil];
}

#pragma mark - Noti
// 进入后台
- (void)applicationDidEnterBackgroundNotification {
   self.backgroudRecord = (_timer != nil);
   if (self.backgroudRecord) {
       self.lastTime = CFAbsoluteTimeGetCurrent();
       [self invalidate];
   }
}

// 进入前台
- (void)applicationWillEnterForegroundNotification {
    if (self.backgroudRecord) {
        CFAbsoluteTime timeInterval = CFAbsoluteTimeGetCurrent() - self.lastTime;
        // 取整
        [self timerActionWithTimeInterval:(NSInteger)timeInterval];
        [self start];
    }
}
 
#pragma mark - Lazy
- (NSMutableDictionary *)timeIntervalDict {
    if (!_timeIntervalDict) {
        _timeIntervalDict = [NSMutableDictionary dictionary];
    }
    return _timeIntervalDict;
}


@end
