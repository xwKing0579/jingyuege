//
//  DBCollectBooksCollectionViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/3.
//

#import "DBCollectBooksCollectionViewCell.h"
#import "DBBookMenuPanView.h"
#import "DBReadBookCatalogsViewController.h"
#import "DBReaderManagerViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "DBBookCatalogModel.h"

@interface DBCollectBooksCollectionViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) DBBookMenuPanView *panView;
@property (nonatomic, strong) DBBaseLabel *scoreLabel;
@end

@implementation DBCollectBooksCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.backgroundColor = DBColorExtension.noColor;
        self.contentView.backgroundColor = DBColorExtension.noColor;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.topImageView]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(self.pictureImageView.mas_width).multipliedBy(5.0/4.0);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.pictureImageView);
        make.top.mas_equalTo(self.pictureImageView.mas_bottom).offset(4);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.pictureImageView);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(2);
    }];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPressGesture];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (self.model.isLocal) return;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        DBBookMenuPanView *panView = [[DBBookMenuPanView alloc] init];
        panView.model = self.model;
        [panView presentInView:UIScreen.appWindow];
        self.panView = panView;
        
        DBWeakSelf
        panView.clickCatalogsIndex = ^{
            DBStrongSelfElseReturn
            [self clickCatalogsMenu];
        };
    }
}

- (void)clickCatalogsMenu{
    if (self.model.site_path){
        NSArray <DBBookCatalogModel *>*chapterList = [DBBookCatalogModel getBookCatalogs:self.model.catalogForm];
        if (chapterList.count) {
            DBReadBookCatalogsViewController *catalogsVc = (DBReadBookCatalogsViewController *)[DBRouter openPageUrl:DBReadBookCatalogs params:@{@"book":self.model,@"dataList":chapterList,kDBRouterDrawerSideslip:@1}];
            DBWeakSelf
            catalogsVc.clickChapterIndex = ^(NSInteger chapterIndex) {
                DBStrongSelfElseReturn
                DBBookModel *bookModel = self.model;
                if (bookModel.chapter_index != chapterIndex){
                    bookModel.chapter_index = chapterIndex;
                    bookModel.page_index = 0;
                    [bookModel updateCollectBook];
                    [bookModel updateReadingBook];
                }
                DBReaderManagerViewController *readingVc = [[DBReaderManagerViewController alloc] init];
                readingVc.book = bookModel;
                readingVc.hidesBottomBarWhenPushed = YES;
                [UIScreen.currentViewController cw_pushViewController:readingVc];
            };
        }else{
            [DBRouter openPageUrl:DBBookSource params:@{@"book":self.model,kDBRouterDrawerSideslip:@1}];
        }
    }else{
        [DBRouter openPageUrl:DBBookSource params:@{@"book":self.model,kDBRouterDrawerSideslip:@1}];
    }
}
                                                                     
- (void)setModel:(DBBookModel *)model{
    _model = model;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.contentTextLabel.text = model.author;
    self.topImageView.hidden = !model.is_top;
//    self.scoreLabel.text = [NSString stringWithFormat:@"%@分",model.score];
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.layer.cornerRadius = 6;
        _pictureImageView.layer.masksToBounds = YES;
    }
    return _pictureImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySmallFont;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.inkWashColor;
        _contentTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentTextLabel;
}

- (UIImageView *)topImageView{
    if (!_topImageView){
        _topImageView = [[UIImageView alloc] init];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.image = [UIImage imageNamed:@"jjApexInsignia"];
    }
    return _topImageView;
}

- (DBBaseLabel *)scoreLabel{
    if (!_scoreLabel){
        _scoreLabel = [[DBBaseLabel alloc] init];
        _scoreLabel.font = DBFontExtension.microFont;
        _scoreLabel.textColor = DBColorExtension.whiteColor;
        _scoreLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.size = CGSizeMake(35, 20);
        [_scoreLabel addRoudCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    }
    return _scoreLabel;
}
@end
