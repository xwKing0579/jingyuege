//
//  DBClearBooksCacheViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBClearBooksCacheViewController.h"
#import "DBClearBooksCacheTableViewCell.h"
#import "DBClearBookModel.h"
#import "DBBookChapterModel.h"
@interface DBClearBooksCacheViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation DBClearBooksCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.navLabel.text = @"书籍缓存管理";
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
    [self reloadData];
}

- (void)reloadData{
    NSMutableArray *dataList = [NSMutableArray array];
    for (DBBookModel *book in DBBookModel.getAllReadingBooks) {
        NSUInteger size = [DBBookChapterModel getBookChapterMemory:book.chapterForm];
        if (size < 50*1024) continue;
        
        DBClearBookModel *clearBookModel = [[DBClearBookModel alloc] init];
        clearBookModel.book_id = book.book_id;
        clearBookModel.image = book.image;
        clearBookModel.name = book.name;
        clearBookModel.author = book.author;
        clearBookModel.chapterForm = book.chapterForm;
        clearBookModel.cacheSize = [DBBookChapterModel getDataFileMemory:size];
        [dataList addObject:clearBookModel];
    }
    self.dataList = dataList;
    [self.listRollingView reloadData];
}

- (void)clickClearAction{
    DBWeakSelf
    LEEAlert.alert.config.LeeTitle(@"确定清除缓存").LeeContent(@"清除缓存操作会清除该书籍已经缓存的所有章节数据,是否清除?").
    LeeAction(@"移除", ^{
        DBStrongSelfElseReturn
        [DBBookChapterModel removeAllBooksChapterMemory];
        
        self.dataList = @[];
        [self.listRollingView reloadData];
    }).LeeCancelAction(@"取消", ^{
        
    }).LeeShow();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBClearBooksCacheTableViewCell *cell = [DBClearBooksCacheTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (UIButton *)clearButton{
    if (!_clearButton){
        _clearButton = [[UIButton alloc] init];
        _clearButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_clearButton setTitle:@"清除" forState:UIControlStateNormal];
        [_clearButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clickClearAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"empty_icon"];
    emptyView.content = @"暂无书籍缓存";
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    return emptyView;
}

@end
