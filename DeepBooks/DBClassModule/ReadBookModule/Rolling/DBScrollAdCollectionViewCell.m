//
//  DBScrollAdCollectionViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/8.
//

#import "DBScrollAdCollectionViewCell.h"
#import "DBReadBookSetting.h"

@interface DBScrollAdCollectionViewCell ()
//@property (nonatomic, strong) UIImageView *iconImage;
@end

@implementation DBScrollAdCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.backgroundColor = DBColorExtension.noColor;
        self.contentView.backgroundColor = DBColorExtension.noColor;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.clipsToBounds = YES;
//    [self.contentView addSubview:self.iconImage];
//    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
}


//- (UIImageView *)iconImage{
//    if (!_iconImage){
//        _iconImage = [[UIImageView alloc] init];
//        _iconImage.image = [UIImage imageNamed:@"jjTerraForma"];
//        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
//    }
//    return _iconImage;
//}
@end
