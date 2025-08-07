//
//  DBFontMenuPanView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/14.
//

#import "DBFontMenuPanView.h"
#import "DBFontMenuTableViewCell.h"
#import "DBFontModel.h"
#import <Reachability.h>
@interface DBFontMenuPanView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) UIView *partingLineView;
@property (nonatomic, strong) UITableView *listRollingView;
@property (nonatomic, strong) NSArray *dataList;
@end

@implementation DBFontMenuPanView

- (instancetype)init{
    if (self = [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = DBColorExtension.whiteColor;
    
    self.listRollingView.rowHeight = 50;
    [self addSubviews:@[self.titlePageLabel,self.partingLineView,self.listRollingView]];
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(16);
        make.height.mas_equalTo(20);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titlePageLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(1);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.partingLineView.mas_bottom);
    }];
    
    self.dataList = DBFontModel.fontDataList;
    [self.listRollingView reloadData];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBFontMenuTableViewCell *cell = [DBFontMenuTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBFontModel *model = self.dataList[indexPath.row];
    if (model.isUsing) return;
    
    if (model.isDowload){
        for (DBFontModel *item in self.dataList) {
            BOOL isDowload = [item.name isEqualToString:model.name];
            item.isUsing = isDowload;
        }
        [DBFontModel saveFontDataList:self.dataList];
        
        [self dismissAnimated:YES completion:^{
            
        }];
        if (self.fontSwitchBlock) self.fontSwitchBlock(model);
    }else{
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status != ReachableViaWiFi){
            DBWeakSelf
            LEEAlert.alert.config.LeeTitle(@"当前是蜂窝数据环境，是否继续下载").
            LeeCancelAction(@"取消", ^{
                
            }).LeeAction(@"继续", ^{
                DBStrongSelfElseReturn
                [self dowloadFontName:model];
            }).LeeShow();
        }else{
            [self dowloadFontName:model];
        }
    }
}

- (void)dowloadFontName:(DBFontModel *)model{
    [self showHudLoading];
    [DBFontModel.manger downloadFontWithName:model completion:^(BOOL success, NSString *registeredFontName, NSString *message) {
        [self removeHudLoading];
        if (success){
            for (DBFontModel *item in self.dataList) {
                if ([item isEqual:model]){
                    item.isUsing = YES;
                    item.isDowload = YES;
                    item.fontName = registeredFontName;
                }else{
                    item.isUsing = NO;
                }
            }
            [DBFontModel saveFontDataList:self.dataList];
            [self dismissAnimated:YES completion:^{
                
            }];
            if (self.fontSwitchBlock) self.fontSwitchBlock(model);
        }else{
            [self showAlertText:message];
        }
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return UIView.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.text = @"字体";
        _titlePageLabel.font = DBFontExtension.pingFangMediumXLarge;
        _titlePageLabel.textColor = DBColorExtension.blackAltColor;
        _titlePageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlePageLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayAltColor;
    }
    return _partingLineView;
}

- (UITableView *)listRollingView{
    if (!_listRollingView){
        _listRollingView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _listRollingView.estimatedSectionHeaderHeight = 0;
        _listRollingView.estimatedSectionFooterHeight = 0;
        _listRollingView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listRollingView.rowHeight = UITableViewAutomaticDimension;
        _listRollingView.showsVerticalScrollIndicator = NO;
        _listRollingView.showsHorizontalScrollIndicator = NO;
        _listRollingView.delegate = self;
        _listRollingView.dataSource = self;
        _listRollingView.backgroundColor = self.backgroundColor;
        
        _listRollingView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (@available(iOS 15.0, *)) {
            _listRollingView.sectionHeaderTopPadding = 0;
        }
    }
    return _listRollingView;
}

- (void)panModalDidDismissed{
    [DBFontModel.manger cancelDownloadTask];
}

- (PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent, MIN(UIScreen.screenHeight*0.7, UIScreen.tabbarSafeHeight+32+50*9));
}

- (CGFloat)cornerRadius{
    return 24;
}

- (HWBackgroundConfig *)backgroundConfig{
    HWBackgroundConfig *config = [HWBackgroundConfig new];
    config.backgroundAlpha = 0.5;
    config.blurTintColor = DBColorExtension.blackColor;
    return config;
}

- (BOOL)showDragIndicator{
    return NO;
}

- (BOOL)allowsDragToDismiss{
    return YES;
}

- (BOOL)allowsPullDownWhenShortState{
    return NO;
}

- (BOOL)allowScreenEdgeInteractive{
    return NO;
}

- (BOOL)allowsTouchEventsPassingThroughTransitionView{
    return NO;
}

@end
