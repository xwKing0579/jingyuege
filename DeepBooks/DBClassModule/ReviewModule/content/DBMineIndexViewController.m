//
//  DBMineIndexViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/10.
//

#import "DBMineIndexViewController.h"
#import "DBMineIndexCollectionViewCell.h"

static NSString *identifierCollectCell = @"DBMineIndexCollectionViewCell";
@interface DBMineIndexViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *myBookCollectionView;
@end

@implementation DBMineIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.myBookCollectionView];
    [self.myBookCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navgationView.backgroundColor = UIColor.clearColor;
    NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.index==0?DBBookModel.getAllCollectBooks:DBBookModel.getAllReadingBooks];
    self.dataList = dataList;
    [self.myBookCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBMineIndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCollectCell forIndexPath:indexPath];
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
        [DBRouter openPageUrl:DBBookSource params:@{@"book":model,kDBRouterDrawerSideslip:@1}];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (UIScreen.screenWidth-60)/3;
    CGFloat height = width*5.0/4.0+52;
    return CGSizeMake(width, height);
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
        _myBookCollectionView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        _myBookCollectionView.showsVerticalScrollIndicator = NO;
        _myBookCollectionView.showsHorizontalScrollIndicator = NO;
        _myBookCollectionView.backgroundColor = DBColorExtension.noColor;
        [_myBookCollectionView registerClass:NSClassFromString(identifierCollectCell) forCellWithReuseIdentifier:identifierCollectCell];

    }
    return _myBookCollectionView;
}

- (UIView *)listView{
    return self.view;
}

@end
