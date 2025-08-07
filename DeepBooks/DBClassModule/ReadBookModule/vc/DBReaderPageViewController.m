//
//  DBReaderPageViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/5.
//

#import "DBReaderPageViewController.h"
#import "DBReadBookView.h"
#import "DBReadBookSetting.h"

@interface DBReaderPageViewController ()
@property (nonatomic, strong) DBReadBookView *readBookView;
@property (nonatomic, strong) UIButton *reloadButton;
@end

@implementation DBReaderPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    UIColor *backgroundColor = setting.backgroundColor;
    UIImage *backgroundImage = backgroundColor.toImage;
    if ([backgroundColor isEqual:DBColorExtension.sandColor]){
        backgroundImage = [UIImage imageNamed:@"art_kraft"];
    }else if ([backgroundColor isEqual:DBColorExtension.wheatColor]){
        backgroundImage = [UIImage imageNamed:@"art_wood"];
    }
    self.view.layer.contents = (id)backgroundImage.CGImage;
    
    [self.view addSubview:self.readBookView];
}

- (void)setModel:(DBReaderModel *)model{
    _model = model;
    
    self.currentPageIndex = model.currentPage;
    self.currentChapterIndex = model.currentChapter;
    self.readBookView.attributeString = model.contentList[model.currentPage];
    
    if (model.content && [model.content isEqualToString:@"获取本章失败"]){
        self.reloadButton.hidden = NO;
    }else{
        _reloadButton.hidden = YES;
    }
}

- (void)setAudioText:(NSAttributedString *)audioText{
    _audioText = audioText;
    self.readBookView.attributeString = audioText;
}

- (void)clickReloadReaderAction{
    [UIScreen.currentViewController dynamicAllusionTomethod:@"getBookContentDataSource"];
}

- (DBReadBookView *)readBookView{
    if (!_readBookView){
        CGSize size = DBReadBookSetting.setting.canvasSize;
        _readBookView = [[DBReadBookView alloc] initWithFrame:CGRectMake((UIScreen.screenWidth-size.width)*0.5, UIScreen.navbarSafeHeight+20, size.width, size.height)];
        _readBookView.backgroundColor = DBColorExtension.noColor;
    }
    return _readBookView;
}

- (UIButton *)reloadButton{
    if (!_reloadButton){
        _reloadButton = [[UIButton alloc] init];
        _reloadButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _reloadButton.layer.cornerRadius = 20;
        _reloadButton.layer.masksToBounds = YES;
        _reloadButton.layer.borderWidth = 3;
        _reloadButton.layer.borderColor = DBColorExtension.pinkColor.CGColor;
        [_reloadButton setTitle:@"重新加载本章节" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:DBColorExtension.pinkColor forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(clickReloadReaderAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_reloadButton];
        [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(160);
            make.height.mas_equalTo(40);
        }];
    }
    return _reloadButton;
}

@end
