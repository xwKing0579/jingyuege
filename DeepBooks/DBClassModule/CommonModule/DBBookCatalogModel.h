//
//  DBBookCatalogModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBBookCatalogModel : NSObject
@property (nonatomic, copy) NSString *path; //取章节信息
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL is_content;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title; //解密标题
@property (nonatomic, assign) NSInteger updated_at;
@property (nonatomic, assign) BOOL isCache;

+ (NSArray *)getBookCatalogs:(NSString *)catalogForm;
- (BOOL)updateCatalogsWithCatalogId:(NSString *)catalogForm;
+ (BOOL)updateCatalogs:(NSArray <DBBookCatalogModel *>*)catalogs catalogForm:(NSString *)catalogForm;
+ (BOOL)deleteCatalogsForm:(NSString *)catalogForm;
@end

NS_ASSUME_NONNULL_END
