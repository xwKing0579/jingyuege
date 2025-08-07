//
//  DBSpeechVoicePanView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/18.
//

#import "DBSpeechVoicePanView.h"
#import "DBSpeechVoiceTableViewCell.h"
@interface DBSpeechVoicePanView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@property (nonatomic, strong) UIView *partingLineView;
@property (nonatomic, strong) UITableView *listRollingView;
@end

@implementation DBSpeechVoicePanView

- (instancetype)init{
    if (self = [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = DBColorExtension.whiteColor;
   
    self.listRollingView.rowHeight = 46;
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
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [self.listRollingView reloadData];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBSpeechVoiceTableViewCell *cell = [DBSpeechVoiceTableViewCell initWithTableView:tableView];
    cell.content = self.dataList[indexPath.row];
    cell.isSelected = indexPath.row == self.selectIndex;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissAnimated:YES completion:^{
    
    }];
    if (self.selectIndex == indexPath.row) return;
    if (self.speechVoiceBlock) self.speechVoiceBlock(indexPath.row, self.dataList[indexPath.row]);
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
        _titlePageLabel.text = @"选择阅读声音";
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

- (PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent, UIScreen.tabbarSafeHeight+560);
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
