//
//  DBSearchTagModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBSearchTagModel : NSObject
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat thicken;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderRadius;
@property (nonatomic, assign) CGFloat borderWidth;

+ (NSArray *)tagsList;
@end

NS_ASSUME_NONNULL_END
