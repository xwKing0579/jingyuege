//
//  DBBookSourceViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBBookSourceViewController.h"
#import "DBBookSourceTableViewCell.h"
#import "DBBookSourceModel.h"
#import "DBReaderManagerViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "DBReadBookSetting.h"
#import "DBReaderSetting.h"

@interface DBBookSourceViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation DBBookSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
    [self getDataSource];
}

- (void)setUpSubViews{
    self.title = DBConstantString.ks_selectSource;
    [self.view addSubviews:@[self.navLabel,self.listRollingView]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom);
    }];
    
    if (!self.book){
        if (self.bookId) self.book = [DBBookModel getReadingBookWithId:self.bookId];
    }
}

- (void)getDataSource{
    NSArray *cacheList = [DBBookSourceModel getBookSources:self.book.sourceForm];
    if (cacheList.count){
        self.dataList = cacheList;
        [self.listRollingView reloadData];
    }
    
    if (!self.dataList.count) [self.listRollingView showHudLoading];
    [DBAFNetWorking getServiceRequestType:DBLinkBookSummary combine:self.book.book_id parameInterface:nil modelClass:DBBookSourceModel.class serviceData:^(BOOL successfulRequest, NSArray <DBBookSourceModel *> *result, NSString * _Nullable message) {
        [self.listRollingView removeHudLoading];
        if (successfulRequest){
            if ([cacheList.yy_modelToJSONString isEqualToString:result.yy_modelToJSONString]) return;
            self.dataList = result;
    
            [DBBookSourceModel updateBookSources:result sourceForm:self.book.sourceForm];
        }else{
            [UIScreen.appWindow showAlertText:message];
        }
        self.listRollingView.emptyDataSetSource = self;
        self.listRollingView.emptyDataSetDelegate = self;
        [self.listRollingView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBookSourceTableViewCell *cell = [DBBookSourceTableViewCell initWithTableView:tableView];
    DBBookSourceModel *model = self.dataList[indexPath.row];

    cell.isSelected = [model.site_path isEqualToString:self.book.site_path];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBookSourceModel *model = self.dataList[indexPath.row];
    self.book.site_path = model.site_path;
    self.book.site_path_reload = model.site_path_reload;
    [self.book updateReadingBook];
    
    DBBookModel *collectBook = [DBBookModel getCollectBookWithId:self.book.book_id];
    if (collectBook){
        [self.book updateCollectBook];
    }
    
    DBReaderManagerViewController *readBook = [[DBReaderManagerViewController alloc] init];
    readBook.book = self.book;
    readBook.hidesBottomBarWhenPushed = YES;
    [self cw_pushViewController:readBook];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"jjNullCanvas"];
    emptyView.content = DBConstantString.ks_noContents;
    emptyView.dataList = self.dataList;
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    
    DBWeakSelf
    emptyView.reloadBlock = ^{
        DBStrongSelfElseReturn
        [self.listRollingView showHudLoading];
        [self getDataSource];
    };
    return emptyView;
}




@end
