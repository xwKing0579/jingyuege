//
//  DBAllBooksItemView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBAllBooksItemView : UIView
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *scoreLabel;
@property (nonatomic, strong) DBBaseLabel *authorLabel;
@end

NS_ASSUME_NONNULL_END
