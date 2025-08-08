//
//  DBReadRecordViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBReadRecordViewController.h"
#import "DBReadRecordTableViewCell.h"
#import "DBReadRecordModel.h"
@interface DBReadRecordViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation DBReadRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
}

- (void)setUpSubViews{
    self.title = @"阅读历史";
    [self.view addSubviews:@[self.navLabel,self.listRollingView,self.clearButton]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.navLabel);
        make.width.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    
    self.listRollingView.emptyDataSetSource = self;
    self.listRollingView.emptyDataSetDelegate = self;
}

- (void)getDataSource{
    self.dataList = DBBookModel.getAllReadingBooks;
    [self.listRollingView reloadData];
    
//    if (DBCommonConfig.isLogin){
//        [DBAFNetWorking getServiceRequestType:DBLinkBookReadingHistoryList combine:nil parameInterface:@{@"page":@"1",@"form":@"1"} modelClass:nil serviceData:^(BOOL successfulRequest, id result, NSString * _Nullable message) {
//        }];
//    }
}

- (void)clickClearAction{
    if (self.dataList.count == 0){
        [self.view showAlertText:@"目前没有需要清除的阅读记录"];
        return;
    }
    
    DBWeakSelf
    LEEAlert.alert.config.LeeTitle(@"用户需知").
    LeeContent(@"清空阅读记录会清除您之前所有的阅读记录,而且清除之后不能恢复,是否确定清空?").
    LeeAction(@"确定", ^{
        DBStrongSelfElseReturn
        if (DBCommonConfig.isLogin){
            [DBAFNetWorking getServiceRequestType:DBLinkBookReadingCleanUp combine:nil parameInterface:@{@"form":@"1"} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
                if (successfulRequest){
                    [self clearRecordList];
                }else{
                    [self.view showAlertText:message];
                }
            }];
        }else{
            [self clearRecordList];
        }
    }).LeeCancelAction(@"再想想", ^{
        
    }).LeeShow();
}

- (void)clearRecordList{
    if ([DBBookModel removeAllReadingBooks]){
        self.dataList = @[];
        [self.listRollingView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBReadRecordTableViewCell *cell = [DBReadRecordTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBookModel *model = self.dataList[indexPath.row];
    [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(model.book_id)}];
}

- (UIButton *)clearButton{
    if (!_clearButton){
        _clearButton = [[UIButton alloc] init];
        _clearButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        [_clearButton setTitle:@"清除" forState:UIControlStateNormal];
        [_clearButton setTitleColor:DBColorExtension.mediumGrayColor forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clickClearAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"jjNullCanvas"];
    emptyView.content = @"暂无阅读记录";
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    return emptyView;
}

@end
