//
//  DBBookTypesBookTypesModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import <Foundation/Foundation.h>

@class DBBookTypesGenderModel;
@class DBBookTypesBannerModel;
@class DBBookTypesListModel;
@class DBBookTypesDataModel;
NS_ASSUME_NONNULL_BEGIN

@interface DBBookTypesModel : NSObject
@property (nonatomic, strong) NSArray <DBBookTypesGenderModel *> *comics;
@property (nonatomic, strong) NSArray <DBBookTypesGenderModel *> *female;
@property (nonatomic, strong) NSArray <DBBookTypesGenderModel *> *male;
@property (nonatomic, strong) NSArray <DBBookTypesBannerModel *> *banner;
@end

@interface DBBookTypesGenderModel : NSObject
@property (nonatomic, copy) NSString *ltype_image;
@property (nonatomic, copy) NSString *ltype_desc;
@property (nonatomic, strong) NSArray <DBBookTypesListModel *> *ltype_list;
@property (nonatomic, copy) NSString *ltype_id;
@property (nonatomic, copy) NSString *ltype_name;
@end

@interface DBBookTypesBannerModel : NSObject
@property (nonatomic, strong) DBBookTypesDataModel *data;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;
@end


@interface DBBookTypesListModel : NSObject
@property (nonatomic, copy) NSString *stype_id;
@property (nonatomic, copy) NSString *stype_name;
@end

@interface DBBookTypesDataModel : NSObject
@property (nonatomic, copy) NSString *book_list_path;
@property (nonatomic, copy) NSString *url_path;
@property (nonatomic, assign) NSInteger book_id;
@end
NS_ASSUME_NONNULL_END
