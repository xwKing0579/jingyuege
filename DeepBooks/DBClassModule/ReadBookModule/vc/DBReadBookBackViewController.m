//
//  DBReadBookBackViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/16.
//

#import "DBReadBookBackViewController.h"

@interface DBReadBookBackViewController ()
@property (nonatomic, strong) UIImageView *backImageView;
@end

@implementation DBReadBookBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setBackImage:(UIImage *)backImage{
    _backImage = backImage;
    self.backImageView.image = backImage;
}

- (UIImageView *)backImageView{
    if (!_backImageView){
        _backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_backImageView];
    }
    return _backImageView;
}

@end
