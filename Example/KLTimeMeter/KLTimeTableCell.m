//
//  KLTimeTableCell.m
//  KLTimeMeter
//
//  Created by jinglian on 2021/1/29.
//  Copyright © 2021 leqiang222@163.com. All rights reserved.
//
//  Description: <#文件描述#>
//  History:
//    1. 2021/1/29 [jinglian]: 创建文件;
//

#import "KLTimeTableCell.h"
#import "KLTimeTableModel.h"
#import "KLTimeMeter.h"

@interface KLTimeTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation KLTimeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kTimeMeterUpdateNotification object:nil];
}

- (void)countDownNotification {
    NSInteger timeInterval = [KLTimeMeterManager.manager timeIntervalWithIdentifier:self.timeTableModel.cellTimeIdentifier];
    NSInteger countDown = self.timeTableModel.countdownCount - timeInterval;
    
    if (countDown <= 0) {
        self.timeLabel.text = @"倒计时结束";
        self.timeLabel.textColor = UIColor.orangeColor;
    }else {
        self.timeLabel.text = [self timeForCount:countDown];
        self.timeLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    }
}

- (NSString *)timeForCount:(NSInteger)count {
    NSInteger hour = count / 3600;
    NSInteger min = (count - hour * 3600) / 60;
    NSInteger second = count - hour * 3600 - min * 60;
    NSString *time = [NSString stringWithFormat:@"倒计时: %02ld:%02ld:%02ld", hour,  min,second]; ;
    
    return time;
}


- (void)setTimeTableModel:(KLTimeTableModel *)timeTableModel {
    _timeTableModel = timeTableModel;
    
    self.title_label.text = timeTableModel.title;
    
    // 手动刷新倒计时
    [self countDownNotification];
}

+ (NSString *)cellId {
    return @"kTimeTableCellId";;
}

+ (CGFloat)cellH {
    return 54.f;
}

@end
