//
//  DBUserActivityModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DBRulesModel,DBReadRulesModel;

@interface DBUserActivityModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, strong) DBRulesModel *rules;
@end

@interface DBRulesModel : NSObject

@property (nonatomic, assign) NSInteger weekly_limit;
@property (nonatomic, assign) NSInteger daily_limit;
@property (nonatomic, assign) NSInteger total_limit;
@property (nonatomic, assign) NSInteger monthly_limit;

@property (nonatomic, strong) DBReadRulesModel *sign_in_rules;
@property (nonatomic, strong) DBReadRulesModel *read_rules;
@property (nonatomic, strong) DBReadRulesModel *first_login_rules;
@property (nonatomic, strong) DBReadRulesModel *continuous_rules;
@property (nonatomic, strong) DBReadRulesModel *watch_ad_rules;
@property (nonatomic, strong) DBReadRulesModel *free_vip_rules;
@property (nonatomic, strong) DBReadRulesModel *share_rules;
@property (nonatomic, strong) DBReadRulesModel *special_rules;
@property (nonatomic, strong) DBReadRulesModel *invite_rules;

@end

@interface DBReadRulesModel : NSObject
@property (nonatomic, assign) NSInteger coins;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) id duration_rules;

@property (nonatomic, assign) NSInteger base_coins;
@property (nonatomic, assign) NSInteger max_continuous_bonus;
@property (nonatomic, assign) NSInteger continuous_bonus;
@property (nonatomic, assign) NSInteger extra_coins;
@property (nonatomic, assign) NSInteger incremental_bonus;
@property (nonatomic, assign) NSInteger max_bonus;
@end

NS_ASSUME_NONNULL_END
