//
//  DBBookselfViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/10.
//

#import "DBBookselfViewController.h"
#import "DBCollectBooksCollectionViewCell.h"

static NSString *identifierCollectCell = @"DBCollectBooksCollectionViewCell";
@interface DBBookselfViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *myBookCollectionView;
@property (nonatomic, strong) UIButton *managerButton;
@end

@implementation DBBookselfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataList = DBBookModel.getAllCollectBooks;
    [self.myBookCollectionView reloadData];
}

- (void)setUpSubViews{
    self.title = @"书架收藏";
    [self.view addSubviews:@[self.navLabel,self.myBookCollectionView,self.managerButton]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.myBookCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarHeight);
    }];
    [self.managerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.height.mas_equalTo(34);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight+5);
    }];
    self.myBookCollectionView.emptyDataSetSource = self;
    self.myBookCollectionView.emptyDataSetDelegate = self;
}

- (void)openManagerBooksPage{
    [DBRouter openPageUrl:@"DBMyBooksManagerViewController"];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBCollectBooksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCollectCell forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DBBookModel *model = self.dataList[indexPath.row];
    if (model.site_path){
        if ([model.site_path isEqualToString:DBMyCultivateBooks]){
            [DBRouter openPageUrl:DBMyCultivateBooks];
        }else{
            [DBRouter openPageUrl:DBReadBookPage params:@{@"book":model}];
        }
    }else{
        model.updateTime = NSDate.currentInterval;
        [model updateCollectBook];
        [DBRouter openPageUrl:DBBookSource params:@{@"bookId":model.book_id,kDBRouterDrawerSideslip:@1}];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (UIScreen.screenWidth-60)/4;
    CGFloat height = width*5.0/4.0+50;
    return CGSizeMake(width, height);
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"jjNullCanvas"];
    emptyView.content = @"暂无书籍数据";
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    return emptyView;
}

- (UICollectionView *)myBookCollectionView{
    if (!_myBookCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
        _myBookCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _myBookCollectionView.delegate = self;
        _myBookCollectionView.dataSource = self;
        _myBookCollectionView.showsVerticalScrollIndicator = NO;
        _myBookCollectionView.showsHorizontalScrollIndicator = NO;
        _myBookCollectionView.backgroundColor = DBColorExtension.whiteColor;
        [_myBookCollectionView registerClass:NSClassFromString(identifierCollectCell) forCellWithReuseIdentifier:identifierCollectCell];
    }
    return _myBookCollectionView;
}

- (UIButton *)managerButton{
    if (!_managerButton){
        _managerButton = [[UIButton alloc] init];
        [_managerButton setImage:[UIImage imageNamed:@"jjVaultSeven"] forState:UIControlStateNormal];
        [_managerButton addTarget:self action:@selector(openManagerBooksPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _managerButton;
}
@end
