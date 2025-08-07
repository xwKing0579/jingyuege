//
//  DBCollectBooksExpandCollectionViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/4.
//

#import "DBCollectBooksExpandCollectionViewCell.h"
#import "DBBookMenuPanView.h"
#import "DBReadBookCatalogsViewController.h"
#import "DBReaderManagerViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "DBBookCatalogModel.h"

@interface DBCollectBooksExpandCollectionViewCell ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *descTextLabel;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) DBBookMenuPanView *panView;

@property (nonatomic, strong) DBBaseLabel *lastReadLabel;
@end
@implementation DBCollectBooksExpandCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.backgroundColor = DBColorExtension.noColor;
        self.contentView.backgroundColor = DBColorExtension.noColor;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.descTextLabel,self.topImageView,self.lastReadLabel]];
    CGFloat width = (UIScreen.screenWidth-60)/4;
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width*5.0/4.0);
        make.bottom.mas_equalTo(-10);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pictureImageView);
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.right.mas_equalTo(-60);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.centerY.mas_equalTo(0);
    }];
    [self.descTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleTextLabel);
        make.bottom.mas_equalTo(self.pictureImageView);
    }];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    [self.lastReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.titleTextLabel);
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
            DBReadBookCatalogsViewController *catalogsVc = (DBReadBookCatalogsViewController *)[DBRouter openPageUrl:DBReadBookCatalogs params:@{@"book":self.model,@"dataList":chapterList?:@[],kDBRouterDrawerSideslip:@1}];
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
    self.topImageView.hidden = !model.is_top;
    self.pictureImageView.imageObj = model.image;
    self.titleTextLabel.text = model.name;
    self.contentTextLabel.text = model.last_chapter_name;
    self.lastReadLabel.hidden = !model.isLastRead;
    
    NSString *lastReadTime = @"";
    if (model.lastReadTime > 0) {
        NSInteger timeDiff = NSDate.now.timeStampInterval - model.lastReadTime;
        if (timeDiff < 60) {
            lastReadTime = @"刚刚·";
        }else if (timeDiff < 60*60){
            lastReadTime = [NSString stringWithFormat:@"%ld分钟前·",timeDiff/60];
        }else if (timeDiff < 60*60*24){
            lastReadTime = [NSString stringWithFormat:@"%ld小时前·",timeDiff/(60*60)];
        }else if (timeDiff < 60*60*24*30){
            lastReadTime = [NSString stringWithFormat:@"%ld天前·",timeDiff/(60*60*24)];
        }else if (timeDiff < 60*60*24*365){
            lastReadTime = [NSString stringWithFormat:@"%ld月前·",timeDiff/(60*60*24*30)];
        }else{
            lastReadTime = [NSString stringWithFormat:@"%ld年前·",timeDiff/(60*60*24*365)];
        }
    }

    self.descTextLabel.text = [NSString stringWithFormat:@"%@%@",lastReadTime,[DBCommonConfig bookReadingProgress:model.readChapterName]];
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
        _titleTextLabel.font = DBFontExtension.bodyMediumFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
        _contentTextLabel.numberOfLines = 2;
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)descTextLabel{
    if (!_descTextLabel){
        _descTextLabel = [[DBBaseLabel alloc] init];
        _descTextLabel.font = DBFontExtension.bodySmallFont;
        _descTextLabel.textColor = DBColorExtension.grayColor;
    }
    return _descTextLabel;
}

- (UIImageView *)topImageView{
    if (!_topImageView){
        _topImageView = [[UIImageView alloc] init];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.image = [UIImage imageNamed:@"top_icon"];
    }
    return _topImageView;
}

- (DBBaseLabel *)lastReadLabel{
    if (!_lastReadLabel){
        _lastReadLabel = [[DBBaseLabel alloc] init];
        _lastReadLabel.font = DBFontExtension.bodySmallFont;
        _lastReadLabel.textColor = DBColorExtension.redColor;
        _lastReadLabel.textAlignment = NSTextAlignmentCenter;
        _lastReadLabel.text = @"上次阅读";
    }
    return _lastReadLabel;
}
@end
