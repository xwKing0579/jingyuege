//
//  DEBookCommentHeadView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/2.
//

#import "DEBookCommentHeadView.h"

@interface DEBookCommentHeadView ()
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@end

@implementation DEBookCommentHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self addSubview:self.coverView];
    [self.coverView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel]];
    [self addObserver:self
               forKeyPath:@"frame"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect newFrame = [change[NSKeyValueChangeNewKey] CGRectValue];
        self.coverView.frame = CGRectMake(0, newFrame.size.height-100, UIScreen.screenWidth, 100);
    }
}

- (void)setBook:(DBBookModel *)book{
    _book = book;
    
    self.pictureImageView.imageObj = book.image;
    self.titleTextLabel.text = book.name;
    self.contentTextLabel.text = book.author;
}

- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, 100)];
    }
    return _coverView;
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 4, 72, 96)];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.layer.cornerRadius = 6;
        _pictureImageView.layer.masksToBounds = YES;
    }
    return _pictureImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] initWithFrame:CGRectMake(100, 20, UIScreen.screenWidth-115, 20)];
        _titleTextLabel.font = DBFontExtension.bodyMediumFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] initWithFrame:CGRectMake(100, 50, UIScreen.screenWidth-115, 20)];
        _contentTextLabel.font = DBFontExtension.bodySmallFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
    }
    return _contentTextLabel;
}
@end
