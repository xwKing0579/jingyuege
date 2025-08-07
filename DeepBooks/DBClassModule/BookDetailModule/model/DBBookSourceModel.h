//
//  DBBookSourceModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBBookSourceModel : NSObject
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *site_id;
@property (nonatomic, assign) NSInteger crawl_book_id;
@property (nonatomic, copy) NSString *site_path;
@property (nonatomic, copy) NSString *last_chapter_name;
@property (nonatomic, copy) NSString *site_path_reload;
@property (nonatomic, copy) NSString *choose;
@property (nonatomic, copy) NSString *site_name;


+ (NSArray *)getBookSources:(NSString *)sourceForm;
+ (BOOL)updateBookSources:(NSArray <DBBookSourceModel *>*)bookSource sourceForm:(NSString *)sourceForm;

@end

NS_ASSUME_NONNULL_END
