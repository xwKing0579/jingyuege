//
//  DBReaderEndViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/7.
//

#import "DBReaderEndViewController.h"
#import "DBReadBookSetting.h"
#import "DBBookEndView.h"

@interface DBReaderEndViewController ()

@end

@implementation DBReaderEndViewController

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
        backgroundImage = [UIImage imageNamed:@"jjEtherealBrushwork"];
    }else if ([backgroundColor isEqual:DBColorExtension.wheatColor]){
        backgroundImage = [UIImage imageNamed:@"jjPetrifiedGrain"];
    }
    self.view.layer.contents = (id)backgroundImage.CGImage;
    
    DBBookEndView *endView = [[DBBookEndView alloc] init];
    endView.model = self.model;
    [self.view addSubview:endView];
    [endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end
