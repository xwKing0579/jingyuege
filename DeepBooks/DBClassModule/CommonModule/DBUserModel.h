//
//  DBUserModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DBUserDataModel,DBUserInfoModel,DBUserAdModel,DBUserInviteCodeModel;
@interface DBUserModel : NSObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *is_login_first;
@property (nonatomic, copy) NSString *reg_day;
@property (nonatomic, copy) NSString *ad_style;
@property (nonatomic, copy) NSString *ad_end_datetime;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *ad_state;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *ad_tips;
@property (nonatomic, copy) NSString *serv_datetime;
@property (nonatomic, strong) DBUserDataModel *data;

+ (void)loginWithParameters:(NSDictionary *)parameInterface completion:(void (^ __nullable)(BOOL success))completion;

+ (void)getUserCenterCompletion:(void (^ __nullable)(BOOL success))completion;
+ (void)getUserInviteCompletion:(void (^ __nullable)(BOOL successfulRequest, DBUserInviteCodeModel *model))completion;
@end

@interface DBUserDataModel : NSObject
@property (nonatomic,copy) NSString *ad_token;
@end


@interface DBUserInfoModel : NSObject
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *is_red_packet;
@property (nonatomic, copy) NSString *user_phone;
@property (nonatomic, copy) NSString *invitation_count;
@property (nonatomic, copy) NSString *user_login;
@property (nonatomic, copy) NSString *gold;
@property (nonatomic, copy) NSString *user_nickname;
@property (nonatomic, strong) DBUserAdModel *ad;
@property (nonatomic, copy) NSString *today_read;
@property (nonatomic, copy) NSString *invitation_code;
@property (nonatomic, copy) NSString *master_user_id;

@property (nonatomic, assign) NSInteger asking_book_number;
@property (nonatomic, assign) NSInteger service_appeal_number;
@property (nonatomic, assign) NSInteger comment_number;


@end

@interface DBUserAdModel : NSObject

@end

@interface DBUserInviteCodeModel : NSObject
@property (nonatomic, copy) NSString *bind_count;
@property (nonatomic, copy) NSString *invite_code;
@property (nonatomic, copy) NSString *inviter;
@property (nonatomic, copy) NSString *invite_id;
@property (nonatomic, copy) NSString *share_link;
@end
NS_ASSUME_NONNULL_END
