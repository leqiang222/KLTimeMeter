//
//  KLTimeTableModel.h
//  KLTimeMeter
//
//  Created by jinglian on 2021/1/29.
//  Copyright © 2021 leqiang222@163.com. All rights reserved.
//
//  Description: <#文件描述#>
//  History:
//    1. 2021/1/29 [jinglian]: 创建文件;
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLTimeTableModel : NSObject

/**
 *  <#描述#>
 */
@property (nonatomic, copy) NSString *title;

/**
 *  倒计时剩余数（秒）
 */
@property (nonatomic, assign) NSInteger countdownCount;

/**
 *  <#描述#>
 */
@property (nonatomic, copy) NSString *cellTimeIdentifier;
 

@end

NS_ASSUME_NONNULL_END
