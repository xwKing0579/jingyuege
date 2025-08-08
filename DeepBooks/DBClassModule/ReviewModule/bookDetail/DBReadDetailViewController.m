//
//  DBReadDetailViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/22.
//

#import "DBReadDetailViewController.h"
#import "DBBookDetailModel.h"
#import "DBReadDetailTableViewCell.h"
#import "DBRecommendBooksTableViewCell.h"
#import "DBBookSocreTableViewCell.h"

#import "DBBookCommentModel.h"
#import "DBCommentPanView.h"
#import "DBConventionView.h"

#import "DBBookCatalogModel.h"
#import "DBBookSourceModel.h"
#import "DBBookChapterModel.h"
@interface DBReadDetailViewController ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSArray *commentList;

@property (nonatomic, assign) NSInteger totalComment;

@property (nonatomic, strong) DBBookSourceModel *sourceModel;
@property (nonatomic, strong) DBBookModel *book;

@property (nonatomic, strong) UIButton *bookselfButton;
@property (nonatomic, strong) UIButton *readButton;
@end

@implementation DBReadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];

}

- (void)userLoginSuccess{
    [self getDataSource];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.listRollingView,self.bottomView,self.topView]];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(54+UIScreen.tabbarSafeHeight);
        make.top.mas_equalTo(self.listRollingView.mas_bottom);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(UIScreen.navbarHeight);
    }];
}

- (void)getDataSource{
    [DBAFNetWorking getServiceRequestType:DBLinkBookDetailData combine:self.bookId parameInterface:nil modelClass:DBBookDetailModel.class serviceData:^(BOOL successfulRequest, DBBookDetailModel *result, NSString * _Nullable message) {
        if (successfulRequest){
            if (DBCommonConfig.appConfig.force.shield_switch &&
                ([result.shield_data containsObject:@"2"] || [result.shield_data containsObject:@2])){
                [DBRouter closePage];
                [UIScreen.appWindow showAlertText:DBConstantString.ks_unavailable];
                return;
            }
            
            self.navLabel.text = result.name;
            
            NSMutableArray *dataList = [NSMutableArray array];
            [dataList addObject:result];
            
            if (result.relevant_book.count) {
                DBBookDetailCustomModel *model = DBBookDetailCustomModel.new;
                model.name = DBConstantString.ks_topReads;
                model.bookList = result.relevant_book;
                [dataList addObject:model];
            }
            self.dataList = dataList;
            [self.listRollingView reloadData];
            [self getBookChapter];
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (void)getBookChapter{
    [DBAFNetWorking getServiceRequestType:DBLinkBookSummary combine:self.bookId parameInterface:nil modelClass:DBBookSourceModel.class serviceData:^(BOOL successfulRequest, NSArray <DBBookSourceModel *> *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            if (result.count) self.sourceModel = result.firstObject;
        }
    }];
}

- (void)clickReadAction{
    DBBookModel *book = [DBBookModel getReadingBookWithId:self.bookId];
    if (book.site_path){
        [DBRouter openPageUrl:DBReadBookPage params:@{@"book":book}];
    }else{
        DBBookDetailModel *bookModel = self.dataList.firstObject;
        if (bookModel) [DBRouter openPageUrl:DBBookSource params:@{@"book":bookModel,kDBRouterDrawerSideslip:@1}];
    }
}

- (void)canCollectBookSelf{
    if (self.bookselfButton.selected){
        [self removeBook];
    }else{
        [self collectBook];
    }
}

- (void)collectBook{
    DBBookDetailModel *bookModel = self.dataList.firstObject;
    
    bookModel.collectDate = NSDate.currentInterval;
    bookModel.updateTime = NSDate.currentInterval;
    BOOL successfulRequest = [bookModel insertCollectBook];
    
    if (successfulRequest){
        [self.view showAlertText:DBConstantString.ks_addedToShelf];
        self.bookselfButton.selected = YES;
    }else{
        [self.view showAlertText:DBConstantString.ks_addToShelfFailed];
    }
}

- (void)removeBook{
    DBBookDetailModel *bookModel = self.dataList.firstObject;
    BOOL successfulRequest = [bookModel removeCollectBook];
    if (successfulRequest){
        [self.view showAlertText:DBConstantString.ks_removedFromShelf];
        self.bookselfButton.selected = NO;
    }else{
        [self.view showAlertText:DBConstantString.ks_removeFailed];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row){
        DBRecommendBooksTableViewCell *cell = [DBRecommendBooksTableViewCell initWithTableView:tableView];
        cell.model = self.dataList[indexPath.row];
        return cell;
    }else{
        DBReadDetailTableViewCell *cell = [DBReadDetailTableViewCell initWithTableView:tableView];
        cell.model = self.dataList[indexPath.row];
        DBWeakSelf
        cell.remarkBlock = ^{
            DBStrongSelfElseReturn
            [tableView reloadData];
        };
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat alpha = MIN(1, scrollView.contentOffset.y/120);
    if (DBColorExtension.userInterfaceStyle) {
        self.topView.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    }else{
        self.topView.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    }
   
    self.navLabel.alpha = alpha;
}

- (UIView *)topView{
    if (!_topView){
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        
        [_topView addSubview:self.navLabel];
        self.navLabel.alpha = 0;
        [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(UIScreen.navbarSafeHeight);
            make.height.mas_equalTo(UIScreen.navbarNetHeight);
        }];
    }
    return _topView;
}

- (UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc] init];
        NSArray *bottomButtons = @[self.bookselfButton,self.readButton];
        [_bottomView addSubviews:bottomButtons];
        [bottomButtons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:16 leadSpacing:16 tailSpacing:16];
        [bottomButtons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(44);
        }];
    }
    return _bottomView;
}

- (UIButton *)bookselfButton{
    if (!_bookselfButton){
        _bookselfButton = [[UIButton alloc] init];
        _bookselfButton.titleLabel.font = DBFontExtension.titleSmallFont;
        _bookselfButton.backgroundColor = DBColorExtension.whiteColor;
        _bookselfButton.layer.cornerRadius = 10;
        _bookselfButton.layer.masksToBounds = YES;
        [_bookselfButton setTitle:DBConstantString.ks_addToShelf forState:UIControlStateNormal];
        [_bookselfButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_bookselfButton setTitle:DBConstantString.ks_removeFromShelf forState:UIControlStateSelected];
        [_bookselfButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateSelected];
        
        [_bookselfButton addTarget:self action:@selector(canCollectBookSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bookselfButton;
}

- (UIButton *)readButton{
    if (!_readButton){
        _readButton = [[UIButton alloc] init];
      
        _readButton.titleLabel.font = DBFontExtension.titleSmallFont;
        _readButton.backgroundColor = DBColorExtension.sunsetOrangeColor;
        _readButton.layer.cornerRadius = 10;
        _readButton.layer.masksToBounds = YES;
        [_readButton setTitle:DBConstantString.ks_read forState:UIControlStateNormal];
        [_readButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_readButton addTarget:self action:@selector(clickReadAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readButton;
}
@end
