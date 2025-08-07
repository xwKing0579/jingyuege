//
//  DBMySettingModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import <Foundation/Foundation.h>
@class DBMySettingListModel;
NS_ASSUME_NONNULL_BEGIN

@interface DBMySettingModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *vc;
@property (nonatomic, assign) BOOL isArrow;
@property (nonatomic, assign) BOOL isSwitch;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) BOOL needLogin;
@property (nonatomic, assign) NSInteger target;
@end

@interface DBMySettingListModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray <DBMySettingModel *>*data;


+ (NSArray *)dataSourceList;
+ (NSArray *)dataSourceList2;
@end
NS_ASSUME_NONNULL_END
