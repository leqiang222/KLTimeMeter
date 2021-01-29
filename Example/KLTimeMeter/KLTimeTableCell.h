//
//  KLTimeTableCell.h
//  KLTimeMeter
//
//  Created by jinglian on 2021/1/29.
//  Copyright © 2021 leqiang222@163.com. All rights reserved.
//
//  Description: <#文件描述#>
//  History:
//    1. 2021/1/29 [jinglian]: 创建文件;
//

#import <UIKit/UIKit.h>
@class KLTimeTableModel;

NS_ASSUME_NONNULL_BEGIN

@interface KLTimeTableCell : UITableViewCell

/**
 *  <#描述#>
 */
@property (nonatomic, strong) KLTimeTableModel *timeTableModel;

+ (NSString *)cellId;
+ (CGFloat)cellH;

@end

NS_ASSUME_NONNULL_END
