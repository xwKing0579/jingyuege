//
//  DBBooksMenuView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/4.
//

#import "DBBooksMenuView.h"

@interface DBBooksMenuView ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@end

@implementation DBBooksMenuView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.frame = UIScreen.mainScreen.bounds;
   
  
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    [self addSubview:self.pictureImageView];

    
    NSArray *titles = @[];
//    if (DBCommonConfig.switchAudit){
//        titles = @[@"书架排序",@"阅读记录",@"书籍管理"];
//    }else{
//        BOOL isExpand = [NSUserDefaults boolValueForKey:DBBooksExpandValue];
//        titles = @[isExpand?@"封面模式":@"列表模式",@"书架排序",@"阅读记录",@"书籍管理"];
//    }
    BOOL isExpand = [NSUserDefaults boolValueForKey:DBBooksExpandValue];
    titles = @[isExpand?@"封面模式":@"列表模式",@"书架排序",@"阅读记录",@"书籍管理"];
    
    for (NSInteger index = 0;index < titles.count; index++) {
        NSString *name = titles[index];
        UIButton *menuButton = [[UIButton alloc] init];
        menuButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [menuButton setTitle:name forState:UIControlStateNormal];
        [menuButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [self.pictureImageView addSubview:menuButton];
        
        [menuButton addTarget:self action:@selector(clickMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-23);
        make.top.mas_equalTo(UIScreen.navbarHeight-8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(titles.count*40+20);
    }];
    
    [self.pictureImageView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:14 tailSpacing:6];
    [self.pictureImageView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
    }];
}

- (void)clickMenuAction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"封面模式"]){
        [NSUserDefaults saveValue:@0 forKey:DBBooksExpandValue];
        if (self.menuBlock) self.menuBlock(0);
    }else if ([sender.titleLabel.text isEqualToString:@"列表模式"]){
        [NSUserDefaults saveValue:@1 forKey:DBBooksExpandValue];
        if (self.menuBlock) self.menuBlock(0);
    }else if ([sender.titleLabel.text isEqualToString:@"书架排序"]){
        if (self.menuBlock) self.menuBlock(1);
    }else if ([sender.titleLabel.text isEqualToString:@"阅读记录"]){
        if (self.menuBlock) self.menuBlock(2);
    }else{
        if (self.menuBlock) self.menuBlock(3);
    }
    
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self]) {
        [self removeFromSuperview];
    }
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        if (DBColorExtension.userInterfaceStyle) {
            _pictureImageView.image = [[UIImage imageNamed:@"menuIcon"].stretchable imageWithTintColor:DBColorExtension.blackColor];
        }else{
            _pictureImageView.image = [UIImage imageNamed:@"menuIcon"].stretchable;
        }
      
        _pictureImageView.userInteractionEnabled = YES;
        
    }
    return _pictureImageView;
}
@end
