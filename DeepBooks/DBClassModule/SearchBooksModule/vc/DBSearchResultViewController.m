//
//  DBSearchResultViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import "DBSearchResultViewController.h"
#import "DBSearchBooksModel.h"
#import "DBSearchBookTableViewCell.h"
@interface DBSearchResultViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;

@end

@implementation DBSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
    [self loadingTopAdView:YES];
}

- (void)setUpSubViews{
    self.view.backgroundColor = DBColorExtension.noColor;
    [self.view addSubviews:@[self.titleTextLabel,self.listRollingView]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(10);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(5);
    }];
}

- (void)getDataSource{
    NSDictionary *parameInterface = @{@"keyword":DBSafeString(self.searchWords),@"form":self.form?:@"1",@"package":UIApplication.appBundle};
    [self.view showHudLoading];
    [DBAFNetWorking getServiceRequestType:DBLinkBookSearchResult combine:nil parameInterface:parameInterface modelClass:DBSearchBookDateModel.class serviceData:^(BOOL successfulRequest, DBSearchBookDateModel *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            self.dataList = result.book;
        }else{
            [self.view showAlertText:message];
        }
        self.listRollingView.emptyDataSetSource = self;
        self.listRollingView.emptyDataSetDelegate = self;
        [self.listRollingView reloadData];
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
                make.top.mas_equalTo(self.titleTextLabel.mas_bottom);
            }];
            
            self.adContainerView = nil;
        }else{
            if (self.adContainerView) [self.adContainerView removeFromSuperview];
            
            [self.view addSubview:adContainerView];
            [adContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.size.mas_equalTo(adContainerView.size);
                make.top.mas_equalTo(self.titleTextLabel.mas_bottom);
            }];
            
            [self.listRollingView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(adContainerView.size.height);
            }];
            
            self.adContainerView = adContainerView;
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBSearchBookTableViewCell *cell = [DBSearchBookTableViewCell initWithTableView:tableView];
    cell.searchWords = self.searchWords;
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBSearchBooksModel *model = self.dataList[indexPath.row];
    [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(model.book_id)}];
    
    [DBAFNetWorking postServiceRequestType:DBLinkSearchClickReport combine:nil parameInterface:@{@"form":@"1",@"keyword":DBSafeString(self.searchWords),@"book_id":DBSafeString(model.book_id)} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
    
    }];
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.pingFangMediumXLarge;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
        _titleTextLabel.text = @"搜索结果";
    }
    return _titleTextLabel;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"empty_icon"];
    emptyView.content = @"";
    emptyView.dataList = self.dataList;
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    
    UIButton *seekBookButton = [[UIButton alloc] init];
    seekBookButton.titleLabel.font = DBFontExtension.bodyMediumFont;
    seekBookButton.backgroundColor = DBColorExtension.cloudGrayColor;
    seekBookButton.layer.cornerRadius = 20;
    seekBookButton.layer.masksToBounds = YES;
    [seekBookButton setTitle:@"没搜到?告诉我们你想找的书吧" forState:UIControlStateNormal];
    [seekBookButton setTitleColor:DBColorExtension.gunmetalColor forState:UIControlStateNormal];
    [emptyView addSubview:seekBookButton];
    [seekBookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(emptyView.reloadButton.mas_bottom);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(40);
    }];
    
    DBWeakSelf
    [seekBookButton addTagetHandler:^(id  _Nonnull sender) {
        DBStrongSelfElseReturn
        if (!DBCommonConfig.isLogin) {
            [DBCommonConfig toLogin];
            return;
        }
        
        [DBRouter openPageUrl:DBWantBooks];
    } controlEvents:UIControlEventTouchUpInside];
    return emptyView;
}


- (BOOL)hiddenLeft{
    return YES;
}

- (DBAdSpaceType)adSpaceType{
    return DBAdSpaceSearchPageTop;
}

@end
