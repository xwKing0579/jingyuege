//
//  UITextView+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (DBKit)
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSAttributedString *attriPlaceHolder;
@end

NS_ASSUME_NONNULL_END
