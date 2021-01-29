//
//  KLTimeTableController.m
//  KLTimeMeter
//
//  Created by jinglian on 2021/1/29.
//  Copyright © 2021 leqiang222@163.com. All rights reserved.
//
//  Description: <#文件描述#>
//  History:
//    1. 2021/1/29 [jinglian]: 创建文件;
//

#import "KLTimeTableController.h"
#import "KLTimeTableModel.h"
#import "KLTimeTableCell.h"
#import "KLTimeMeter.h"
#import <MJRefresh.h>

@interface KLTimeTableController ()<UITableViewDataSource, UITableViewDelegate> {
    NSString *_leftTableViewTimeIdentifier;
    NSString *_rightTableViewTimeIdentifier;
}
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
/* <#description#> */
@property (nonatomic, strong) NSMutableArray *leftDataListM;
/* <#description#> */
@property (nonatomic, strong) NSMutableArray *rightDataListM;

@end

@implementation KLTimeTableController

- (void)dealloc {
    NSLog(@"log， KLTimeTableController dealloc");
    [KLTimeMeterManager.manager removeSourceWithIdentifier:_leftTableViewTimeIdentifier];
    [KLTimeMeterManager.manager removeSourceWithIdentifier:_rightTableViewTimeIdentifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"倒计时列表";
    self.view.backgroundColor = UIColor.systemGreenColor;
     
    //
    _leftTableViewTimeIdentifier = NSUUID.UUID.UUIDString;
    _rightTableViewTimeIdentifier = NSUUID.UUID.UUIDString;
    NSLog(@"UIID: %@--%@", _leftTableViewTimeIdentifier, _rightTableViewTimeIdentifier);
    
    [KLTimeMeterManager.manager start];
    [KLTimeMeterManager.manager addSourceWithIdentifier:_leftTableViewTimeIdentifier];
    [KLTimeMeterManager.manager addSourceWithIdentifier:_rightTableViewTimeIdentifier];
     
    //
    [self setupTableView];
}

- (void)setupTableView {
    [self.leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass(KLTimeTableCell.class) bundle:nil] forCellReuseIdentifier:KLTimeTableCell.cellId];
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(leftTableViewLoadNew)];
    self.leftTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(leftTableViewLoadMore)];
    [self.leftTableView.mj_header beginRefreshing];
    
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass(KLTimeTableCell.class) bundle:nil] forCellReuseIdentifier:KLTimeTableCell.cellId];
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(rightTableViewLoadNew)];
    self.rightTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(rightTableViewLoadMore)];
    [self.rightTableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.leftTableView == tableView) {
        return self.leftDataListM.count;
    }
    
    return self.rightDataListM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KLTimeTableCell *cell = (KLTimeTableCell *)[tableView dequeueReusableCellWithIdentifier:KLTimeTableCell.cellId];
    cell.timeTableModel = self.leftTableView == tableView? self.leftDataListM[indexPath.row]: self.rightDataListM[indexPath.row];
     
    return cell;
    // 传递模型
//    [cell setCountDownZero:^(OYModel *timeOutModel){
//        // 回调
//        if (!timeOutModel.timeOut) {
//            NSLog(@"SingleTableVC--%@--时间到了", timeOutModel.title);
//        }
//        // 标志
//        timeOutModel.timeOut = YES;
//    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KLTimeTableCell.cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KLTimeTableController *vc = [[KLTimeTableController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
 
#pragma mark - Action
- (void)leftTableViewLoadNew {
    // 模拟请求延时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.leftDataListM removeAllObjects];
        NSInteger countdownCount = [self radomCount:self.leftTableView isNew:YES];
        for (int i = 0; i < 10; i++) {
            KLTimeTableModel *model = [[KLTimeTableModel alloc] init];
            model.title = [NSString stringWithFormat:@"left-%d行数据", i + 1];
            model.countdownCount = countdownCount;
            model.cellTimeIdentifier = _leftTableViewTimeIdentifier;
             
            [self.leftDataListM addObject:model];
        }
        
        [self.leftTableView.mj_header endRefreshing];
        [KLTimeMeterManager.manager reloadSourceWithIdentifier:_leftTableViewTimeIdentifier]; // 调用reload, 指定identifier
        [self.leftTableView reloadData];
    });
}

- (void)leftTableViewLoadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger index = self.leftDataListM.count;
        NSInteger countdownCount = [self radomCount:self.leftTableView isNew:NO];
        for (NSInteger i = index; i < index + 10; i++) {
            KLTimeTableModel *model = [[KLTimeTableModel alloc] init];
            model.title = [NSString stringWithFormat:@"left-%ld行数据", i + 1];
            model.countdownCount = countdownCount;
            model.cellTimeIdentifier = _leftTableViewTimeIdentifier;
             
            [self.leftDataListM addObject:model];
        }
        
        [self.leftTableView.mj_footer endRefreshing];
//        [KLTimeMeterManager.manager reloadSourceWithIdentifier:_leftTableViewTimeIdentifier]; // 调用reload, 指定identifier
        [self.leftTableView reloadData];
    });
}

- (void)rightTableViewLoadNew {
    // 模拟请求延时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.rightDataListM removeAllObjects];
        NSInteger countdownCount = [self radomCount:self.leftTableView isNew:YES];
        for (int i = 0; i < 10; i++) {
            KLTimeTableModel *model = [[KLTimeTableModel alloc] init];
            model.title = [NSString stringWithFormat:@"right-%d行数据", i + 1];
            model.countdownCount = countdownCount;
            model.cellTimeIdentifier = _rightTableViewTimeIdentifier;
             
            [self.rightDataListM addObject:model];
        }
        
        [self.rightTableView.mj_header endRefreshing];
        [KLTimeMeterManager.manager reloadSourceWithIdentifier:_rightTableViewTimeIdentifier]; // 调用reload, 指定identifier
        [self.rightTableView reloadData];
    });
}

- (void)rightTableViewLoadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger index = self.rightDataListM.count;
        NSInteger countdownCount = [self radomCount:self.leftTableView isNew:NO];
        for (NSInteger i = index; i < index + 10; i++) {
            KLTimeTableModel *model = [[KLTimeTableModel alloc] init];
            model.title = [NSString stringWithFormat:@"right-%ld行数据", i + 1];
            model.countdownCount = countdownCount;
            model.cellTimeIdentifier = _rightTableViewTimeIdentifier;
             
            [self.rightDataListM addObject:model];
        }
        
        [self.rightTableView.mj_footer endRefreshing];
//        [KLTimeMeterManager.manager reloadSourceWithIdentifier:_rightTableViewTimeIdentifier]; // 调用reload, 指定identifier
        [self.rightTableView reloadData];
    });
}


int i = 0;
int j = 0;
- (NSInteger)radomCount:(UITableView *)tableView isNew:(BOOL)isNew {
//    if (self.leftTableView == tableView) {
//        i = !isNew? i + 1: 0;
//        return 20 + i * 20;
//    }
//
//    j = !isNew? i + 1: 0;
//    return 20 + i * 20;
    return 3600;
     
//    return arc4random_uniform(100) + 20;
}

#pragma mark - Lazy
- (NSMutableArray *)leftDataListM {
    if (!_leftDataListM) {
        _leftDataListM = NSMutableArray.array;
    }
    return _leftDataListM;
}

- (NSMutableArray *)rightDataListM {
    if (!_rightDataListM) {
        _rightDataListM = NSMutableArray.array;
    }
    return _rightDataListM;
}


@end
