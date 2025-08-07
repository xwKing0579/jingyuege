//
//  DBAllBooksModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import <Foundation/Foundation.h>
#import "DBBooksDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@class DBDataModel;
@class DBBannerModel;
@class DBIconModel;
@class DBBooksDataModel;

@interface DBAllBooksModel : NSObject
@property (nonatomic, strong) NSArray <DBDataModel *> *data;
@property (nonatomic, strong) NSArray <DBBannerModel *> *banner;
@property (nonatomic, strong) NSArray <DBIconModel *> *icon;
@end


@interface DBDataModel : NSObject
@property (nonatomic, copy) NSString *category;
@property (nonatomic, assign) NSInteger more;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger style;
@property (nonatomic, strong) NSArray <DBBooksDataModel *> *data;
@property (nonatomic, copy) NSString *sub_name;
@end

@interface DBBannerModel : NSObject
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) DBBooksDataModel *data;
@property (nonatomic, copy) NSString *image;
@end

@interface DBIconModel : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type_id;
@property (nonatomic, assign) NSInteger data_id;
@end


NS_ASSUME_NONNULL_END
