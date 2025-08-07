//
//  DBChapterModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBChapterModel : NSObject

@property (nonatomic, copy) NSAttributedString *content;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
