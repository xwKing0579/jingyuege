//
//  DBBooksIndexViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBBooksIndexViewController.h"
#import "DBAllBooksModel.h"
#import "DBBooksStyle1TableViewCell.h"
#import "DBBooksStyle8TableViewCell.h"
#import "DBBooksStyle11TableViewCell.h"
#import "DBAdBannerTableViewCell.h"
#import "DBAuthorBooksModel.h"
#import "DBCarouselCycleView.h"

#import "DBReadBookSetting.h"

@interface DBBooksIndexViewController ()
@property (nonatomic, strong) DBCarouselCycleView *cycleScrollView;
@property (nonatomic, strong) DBAllBooksModel *model;

@property (nonatomic, strong) UIView *gridAdView;
@property (nonatomic, strong) UIView *topAdView;
@property (nonatomic, strong) UIView *centerAdView;
@property (nonatomic, strong) UIView *bottomAdView;

@property (nonatomic, strong) UIView *customEmptyView;
@end

@implementation DBBooksIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
    [self getDataSource];
    [self loadingExpressAdView:YES];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.cycleScrollView startBannerScroll];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.cycleScrollView endBannerScroll];
}

- (void)setUpSubViews{
    self.currentPage = 2;
    self.view.backgroundColor = DBColorExtension.noColor;
    self.listRollingView.backgroundColor = DBColorExtension.noColor;
    [self.view addSubviews:@[self.listRollingView]];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];    
    
    DBWeakSelf
    self.listRollingView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        self.currentPage = 2;
        [self getDataSource];
    }];
    
    self.listRollingView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self getBestMoreDataSource];
    }];
    
    id value = [NSUserDefaults takeValueForKey:self.url];
    if (value){
        self.model = [DBAllBooksModel modelWithJSON:value];
        self.dataList = self.model.data;
        self.cycleScrollView.imageModelGroup = self.model.banner;
        [self.listRollingView reloadData];
    }
}

- (void)reloadModelAdData{
    NSMutableArray *data = [NSMutableArray arrayWithArray:self.dataList];
    if (self.centerAdView && self.dataList.count > 2){
        [data insertObject:self.centerAdView atIndex:2];
    }
    if (self.topAdView){
        [data insertObject:self.topAdView atIndex:0];
    }
    if (self.gridAdView){
        [data insertObject:self.gridAdView atIndex:0];
    }
    if (self.bottomAdView && data.count > 1){
        [data insertObject:self.bottomAdView atIndex:data.count-1];
    }
    
    self.model.data = data;
    [self.listRollingView reloadData];
}

- (void)loadingExpressAdView:(BOOL)reload{
    DBAdSpaceType topType = DBAdSpaceBookCitySelectedTop;
    DBAdSpaceType centerType = DBAdSpaceBookCitySelectedMiddle;
    DBAdSpaceType bottomType = DBAdSpaceBookCitySelectedBottom;

    switch (self.index) {
        case 0:
        {
            DBWeakSelf
            [DBUnityAdConfig.manager openGridAdSpaceType:DBAdSpaceBookCitySelectedTopGrid reload:YES completion:^(UIView * _Nonnull adContainerView) {
                DBStrongSelfElseReturn
                if ([self.gridAdView isEqual:adContainerView]){
                    self.gridAdView = nil;
                }else{
                    self.gridAdView = adContainerView;
                }
                [self reloadModelAdData];
                
            }];
        }
            break;
        case 1:
        {
            topType = DBAdSpaceBookCityMaleTop;
            centerType = DBAdSpaceBookCityMaleMiddle;
            bottomType = DBAdSpaceBookCityMaleBottom;
        }
            break;
        case 2:
        {
            topType = DBAdSpaceBookCityFemaleTop;
            centerType = DBAdSpaceBookCityFemaleMiddle;
            bottomType = DBAdSpaceBookCityFemaleBottom;
        }
            break;
        default:
            break;
    }

    DBWeakSelf
    [DBUnityAdConfig.manager openExpressAdsSpaceType:topType showAdController:self reload:reload completion:^(NSArray<UIView *> * _Nonnull adViews) {
        DBStrongSelfElseReturn
        UIView *adContainerView = adViews.firstObject;
        if ([self.topAdView isEqual:adContainerView]){
            self.topAdView = nil;
        }else{
          
            if ([adContainerView isKindOfClass:DBAdBannerView.class])[adContainerView dynamicAllusionTomethod:@"registerAdView:" object:self];
            self.topAdView = adContainerView;
        }
        [self reloadModelAdData];
    }];

    [DBUnityAdConfig.manager openExpressAdsSpaceType:centerType showAdController:self reload:reload completion:^(NSArray<UIView *> * _Nonnull adViews) {
        DBStrongSelfElseReturn
        UIView *adContainerView = adViews.firstObject;
        if ([self.centerAdView isEqual:adContainerView]){
            self.centerAdView = nil;
        }else{
      
            if ([adContainerView isKindOfClass:DBAdBannerView.class])[adContainerView dynamicAllusionTomethod:@"registerAdView:" object:self];
            self.centerAdView = adContainerView;
        }
        [self reloadModelAdData];
    }];
    
    [DBUnityAdConfig.manager openExpressAdsSpaceType:bottomType showAdController:self reload:reload completion:^(NSArray<UIView *> * _Nonnull adViews) {
        DBStrongSelfElseReturn
        UIView *adContainerView = adViews.firstObject;
        if ([self.bottomAdView isEqual:adContainerView]){
            self.bottomAdView = nil;
        }else{
      
            if ([adContainerView isKindOfClass:DBAdBannerView.class])[adContainerView dynamicAllusionTomethod:@"registerAdView:" object:self];
            self.bottomAdView = adContainerView;
        }
        [self reloadModelAdData];
    }];
}

- (NSString *)url{
    NSString *sex = [DBCommonConfig bookGenderType:self.index];
    NSDictionary *combine = @{@"sex":sex,@"data_conf":@"2",@"rand":@"1"};
    NSString *url = [DBLinkManager combineLinkWithType:DBLinkBookQualityChoice combine:combine];
    return url;
}

- (void)getDataSource{
    NSString *sex = [DBCommonConfig bookGenderType:self.index];
    NSDictionary *combine = @{@"sex":sex,@"data_conf":@"2",@"rand":@"1"};
    if (self.dataList.count == 0) [self.view showHudLoading];
    self.customEmptyView.hidden = YES;
    [DBAFNetWorking getServiceRequestType:DBLinkBookQualityChoice combine:combine parameInterface:nil modelClass:DBAllBooksModel.class serviceData:^(BOOL successfulRequest, DBAllBooksModel *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        [self.listRollingView.mj_header endRefreshing];
        if (successfulRequest){
            self.cycleScrollView.imageModelGroup = result.banner;
            self.model = result;
            self.dataList = self.model.data;
            [NSUserDefaults saveValue:result.modelToJSONString forKey:self.url];
        }else{
            [self.view showAlertText:message];
        }
        self.customEmptyView.hidden = self.dataList.count > 0;
        [self reloadModelAdData];
    }];
}

- (void)getBestMoreDataSource{
    DBDataModel *item = self.model.data.lastObject;
    if (item.style != 11) {
        [self.listRollingView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    NSString *page = [NSString stringWithFormat:@"%ld",self.currentPage];
    NSString *sex = [DBCommonConfig bookGenderType:self.index];
    NSDictionary *combine = @{@"sex":sex,@"data_conf":@"2",@"category":DBSafeString(item.category),@"page":page};
    [DBAFNetWorking getServiceRequestType:DBLinkBookQualityChoiceMore combine:combine parameInterface:nil modelClass:DBAuthorBooksModel.class serviceData:^(BOOL successfulRequest, NSArray *result, NSString * _Nullable message) {
        [self.listRollingView.mj_footer endRefreshing];
        if (successfulRequest){
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:item.data];
            [dataList addObjectsFromArray:result];
            item.data = dataList;
            
            if (result.count < 20 || DBCommonConfig.switchAudit) {
                [self.listRollingView.mj_footer endRefreshingWithNoMoreData];
            }
            [self reloadModelAdData];
            self.currentPage++;
        }else{
            [self.view showAlertText:message];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DBDataModel *item = self.model.data[section];
    if ([item isKindOfClass:[UIView class]]) return 1;
    return (item.style == 1 || item.style == 11) ? item.data.count : (item.data.count ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBDataModel *item = self.model.data[indexPath.section];
    if ([item isKindOfClass:[UIView class]]){
        DBAdBannerTableViewCell *cell = [DBAdBannerTableViewCell initWithTableView:tableView];
        cell.objView = (UIView *)item;
        return cell;
    }
    
    if (item.style == 1){
        DBBooksStyle1TableViewCell *cell = [DBBooksStyle1TableViewCell initWithTableView:tableView];
        cell.model = item.data[indexPath.row];
        return cell;
    }else if (item.style == 11){
        DBBooksStyle11TableViewCell *cell = [DBBooksStyle11TableViewCell initWithTableView:tableView];
        cell.model = item.data[indexPath.row];
        return cell;
    }else{
        NSInteger style = item.data.count;
        NSString *cellString = [NSString stringWithFormat:@"DBBooksStyle%ldTableViewCell",style];
        if (DBCommonConfig.allFunctionSwitchAudit) {
            cellString = @"DBBooksStyle5TableViewCell";
        }
        UITableViewCell *cell = [NSObject dynamicAllusionTomethod:cellString.classString action:@"initWithTableView:" object:tableView];
        
        if (!cell){
            cell = [DBBooksStyle8TableViewCell initWithTableView:tableView];
        }
        [cell dynamicAllusionTomethod:@"setIndex:" object:@(self.index)];
        [cell dynamicAllusionTomethod:@"setModel:" object:item];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBDataModel *item = self.model.data[indexPath.section];
    if ([item isKindOfClass:[UIView class]]) return;
    if (item.style == 1){
        [DBRouter openPageUrl:DBBooksList params:@{@"list_id":DBSafeString(item.data[indexPath.row].list_id)}];
    }else if (item.style == 11){
        [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(item.data[indexPath.row].book_id)}];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) return self.cycleScrollView;
    DBDataModel *item = self.model.data[section];
    if ([item isKindOfClass:[UIView class]]) return UIView.new;
    
    if (item.style == 1 || item.style == 11){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 46)];
        DBBaseLabel *titleTextLabel = [[DBBaseLabel alloc] init];
        titleTextLabel.font = DBFontExtension.pingFangSemiboldXLarge;
        titleTextLabel.textColor = DBColorExtension.blackAltColor;
        titleTextLabel.text = item.name;
        [view addSubview:titleTextLabel];
        [titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(10);
        }];
        
        if (item.style == 1){
            UIButton *moreButton = [[UIButton alloc] init];
            moreButton.titleLabel.font = DBFontExtension.bodySmallFont;
            moreButton.size = CGSizeMake(38, 18);
            moreButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            [moreButton setTitle:DBConstantString.ks_more forState:UIControlStateNormal];
            [moreButton setImage:[UIImage imageNamed:@"jjPrecisionTrajectory"] forState:UIControlStateNormal];
            [moreButton setTitleColor:DBColorExtension.inkWashColor forState:UIControlStateNormal];
            [moreButton setTitlePosition:TitlePositionLeft spacing:2];
            [view addSubview:moreButton];
            [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.centerY.mas_equalTo(titleTextLabel);
                make.size.mas_equalTo(moreButton.size);
            }];
            
            DBWeakSelf
            [moreButton addTagetHandler:^(id  _Nonnull sender) {
                DBStrongSelfElseReturn
                [DBRouter openPageUrl:DBCollectionList params:@{@"index":@(self.index),@"nameString":DBSafeString(item.name)}];
            } controlEvents:UIControlEventTouchUpInside];
        }
        return view;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, 0.01)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) return self.cycleScrollView.height;
    DBDataModel *item = self.model.data[section];
    if ([item isKindOfClass:[UIView class]]) return 0.01;
    
    if (item.style == 1 || item.style == 11){
        return 46;
    }
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0.01)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)customEmptyView{
    if (!_customEmptyView){
        _customEmptyView = [[UIView alloc] initWithFrame:self.view.bounds];
        _customEmptyView.layer.zPosition = 66;
        [self.listRollingView addSubviews:@[_customEmptyView]];
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        iconImageView.image = [UIImage imageNamed:@"jjNullCanvas"];
        
        UIButton *reloadButton = [[UIButton alloc] init];
        reloadButton.titleLabel.font = DBFontExtension.pingFangSemiboldRegular;
        reloadButton.layer.cornerRadius = 18;
        reloadButton.layer.masksToBounds = YES;
        reloadButton.layer.borderWidth = 1;
        reloadButton.contentEdgeInsets = UIEdgeInsetsMake(8, 15, 8, 15);
        reloadButton.layer.borderColor = DBColorExtension.sunsetOrangeColor.CGColor;
        [reloadButton setTitle:DBConstantString.ks_reload forState:UIControlStateNormal];
        [reloadButton setTitleColor:DBColorExtension.sunsetOrangeColor forState:UIControlStateNormal];
        [_customEmptyView addSubviews:@[iconImageView,reloadButton]];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.cycleScrollView.height-44);
        }];
        [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(iconImageView.mas_bottom).offset(20);
        }];
        
        DBWeakSelf
        [reloadButton addTagetHandler:^(id  _Nonnull sender) {
            DBStrongSelfElseReturn
            self.currentPage = 2;
            [self getDataSource];
        } controlEvents:UIControlEventTouchUpInside];
    }
    return _customEmptyView;
}

- (DBCarouselCycleView *)cycleScrollView{
    if (!_cycleScrollView){
        _cycleScrollView = [[DBCarouselCycleView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, (UIScreen.screenWidth-48)*146.0/325.0+16+20+68+8)];
        _cycleScrollView.userInteractionEnabled = YES;
        _cycleScrollView.backgroundColor = DBColorExtension.noColor;
        _cycleScrollView.tag = self.index;
    }
    return _cycleScrollView;
}

- (UIView *)listView{
    return self.view;
}

- (BOOL)hiddenLeft{
    return YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (DBColorExtension.userInterfaceStyle) {
        self.view.backgroundColor = DBColorExtension.blackAltColor;
    }else{
        self.view.backgroundColor = DBColorExtension.noColor;
    }
}

@end
