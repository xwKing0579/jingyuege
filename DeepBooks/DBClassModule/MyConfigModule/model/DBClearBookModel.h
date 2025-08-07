//
//  DBClearBookModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBClearBookModel : NSObject
@property (nonatomic, copy) NSString *book_id;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *cacheSize;
@property (nonatomic, copy) NSString *chapterForm;
@end

NS_ASSUME_NONNULL_END
