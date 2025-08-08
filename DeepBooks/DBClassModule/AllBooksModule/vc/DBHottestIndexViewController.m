//
//  DBHottestIndexViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/13.
//

#import "DBHottestIndexViewController.h"
#import "DBBooksDataModel.h"
#import "DBBooksStyle11TableViewCell.h"
@interface DBHottestIndexViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation DBHottestIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
    [self loadingTopAdView:YES];
}

- (void)setUpSubViews{
    self.view.backgroundColor = DBColorExtension.noColor;
    self.listRollingView.backgroundColor = DBColorExtension.noColor;
    [self.view addSubviews:@[self.listRollingView]];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

}

- (void)loadingTopAdView:(BOOL)reload{
    DBWeakSelf
    [DBUnityAdConfig.manager openBannerAdSpaceType:DBAdSpaceBookCityCategoryTop showAdController:self reload:reload completion:^(UIView * _Nonnull adContainerView) {
        DBStrongSelfElseReturn
        if (!adContainerView) return;
        if ([self.adContainerView isEqual:adContainerView]) {
            [self.adContainerView removeFromSuperview];
            [self.listRollingView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
            }];
            self.adContainerView = nil;
        }else{
            if (self.adContainerView) [self.adContainerView removeFromSuperview];
            
            [self.view addSubview:adContainerView];
            [adContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.size.mas_equalTo(adContainerView.size);
                make.top.mas_equalTo(0);
            }];
            
            [self.listRollingView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(adContainerView.height);
            }];
            
            self.adContainerView = adContainerView;
        }
    }];
}

- (void)getDataSource{
    NSString *combine = [NSString stringWithFormat:@"%ld",self.index+1];
    [self.view showHudLoading];
    [DBAFNetWorking getServiceRequestType:DBLinkBookHottest combine:combine parameInterface:nil modelClass:DBBooksDataModel.class serviceData:^(BOOL successfulRequest, NSArray *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            self.dataList = result;
        }else{
            [self.view showAlertText:message];
        }

        self.listRollingView.emptyDataSetSource = self;
        self.listRollingView.emptyDataSetDelegate = self;
        [self.listRollingView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBooksStyle11TableViewCell *cell = [DBBooksStyle11TableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBooksDataModel *model = self.dataList[indexPath.row];
    [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(model.book_id)}];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"jjNullCanvas"];
    emptyView.content = @"暂无热榜数据";
    emptyView.dataList = self.dataList;
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    
    DBWeakSelf
    emptyView.reloadBlock = ^{
        DBStrongSelfElseReturn
        [self getDataSource];
    };
    return emptyView;
}

- (UIView *)listView{
    return self.view;
}

- (BOOL)hiddenLeft{
    return YES;
}

@end
