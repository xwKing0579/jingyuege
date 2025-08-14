//
//  DBLinkManager.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,DBLinkType) {
    
#pragma mark - 配置和广告数据 ConfigUrl
    DBLinkAppSwitch,  // 总开关
    DBLinkInviteCode, //邀请码
    DBLinkBaseKeyword, //关键字
    DBLinkUserPlane,  //B面上报
    DBLinkTrackAdData, //广告数据上报
    DBUserClickReport,  //埋点上报
    DBLinkSearchReport, //B面搜索上报
    DBLinkSearchClickReport, //点击搜索列表数据上报
    DBLinkUserVipInfo, //查看vip信息
    DBLinkUserActivities, //查询活动列表
    DBLinkCheckActivity, //查询活动资格
    DBLinkActivityReward, //活动兑换
    DBLinkFreeVipConsume, //消耗时长
    
    
    DBLinkStateConfig, //域名状态
    DBLinkBaseConfig, // 配置信息
    DBLinkBaseAdConfig, // 广告数据
    DBLinkAppVserion,  // 配置版本
    DBLinkIconResUrl,  // 资源图片Url
    DBLinkHeaderAvatarUrl,  // 头像图片Url
    
#pragma mark - 书架/浏览历史/书单
    DBLinkBookSelfRec, // 书架书籍推荐
    DBLinkBookShelfList, // 书架列表
    DBLinkBookShelfBookAdd, // 添加书籍
    DBLinkBookShelfBookDelete, // 删除书籍
    DBLinkBookShelfMultiBookDelete, // 批量删除书籍
    DBLinkBookShelfBookTop, // 书籍置顶
    DBLinkBookShelfBookTopCancel, // 取消置顶
    DBLinkBookShelfBookFeedUp, // 书籍养肥
    DBLinkBookShelfBookFeedUpCancel, // 取消养肥
    
    DBLinkBookReadingHistoryList, // 浏览历史列表
    DBLinkBookReadingCleanUp, // 浏览历史清除
    
    DBLinkBookThemeCollectList, // 收藏书单列表
    DBLinkRBookThemeAdd, // 收藏书单
    DBLinkRBookThemeDelete, // 删除书单
    DBLinkRBookThemeWhetherOrNot, // 是否收藏了书单
    DBLinkBookThemeCollectMore, //书单更多
#pragma mark - 评论 MyUrl
    DBLinkBookDetailCommentList, // 书籍详情评论列表
    DBLinkCommentList,           // 评论列表
    DBLinkCommentSubmit,         // 提交评论
    DBLinkCommentDelete,         // 删除评论  ----mark
    DBLinkCommentLike,           // 点赞评论
    DBLinkCommentReplayList,     // 评论回复列表
    DBLinkCommentReplaySubmit,   // 评论回复提交
    DBLinkCommentReplayDelete,   // 评论回复删除
    DBLinkCommentReplayLike,     // 评论回复点赞
    
#pragma mark - 反馈 MyUrl
    DBLinkFeedBackSubmit,        // 提交反馈
    DBLinkFeedBackList,          // 反馈列表
    DBLinkChapterContentSubmit,  // 章节问题反馈
    
#pragma mark - 用户系统 MyUrl
    DBLinkUserAskBook,           //求书
    DBLinkUserAskBookList,       //求书列表
    DBLinkUserRegiste,           //注册
    DBLinkUserSignIn,            // 用户登录
    DBLinkUserInviteCode,        // 用户邀请码
    DBLinkUserInviteBind,        //绑定邀请码
    DBLinkUserInfoCenter,        // 个人中心
    DBLinkUserNickModify,        // 修改昵称
    DBLinkUserPasswordModify,    // 修改密码
    DBLinkUserPhoneVeriCodeSend, // 发送手机验证码
    DBLinkUserPhoneAreaCode,     // 区号
    DBLinkUserPhoneCancelVeriCodeSend, // 注销发送手机验证码
    DBLinkUserPhoneCancel, //手机号注销
    DBLinkUserPasswordForget,    // 密码找回
    DBLinkUserPhoneNumberModify, // 修改手机号
    DBLinkUserAvatarUpload,      // 上传头像
    
#pragma mark - 书城数据/书单/分类/完结/热评/榜单/书籍详情/换源 BookUrl
    DBLinkBookQualityChoice,      // 书城精选
    DBLinkBookQualityChoiceMore, // 书城下拉更多
    DBLinkBookQualityModuleMore, //书城查看更多
    DBLinkBookThemeDetailData, // 书单详情
    DBLinkBookClassifyCatalog, // 分类目录
    DBLinkBookClassifyWhole, // 分类全部
    DBLinkBookStoreRankCatalog, // 榜单目录
    DBLinkBookStoreRankDetailData, // 榜单数据
    DBLinkBookDetailData, // 书籍详情
    DBLinkBookSummary, // 书籍换源
    DBLinkBookCatalog, // 书籍目录 site_path 是加载目录   site_path_reload是判断目录是否更新
    DBLinkBookChapter, // 章节内容
    DBLinkBookAuthorRelate,  // 作者相关书籍
    DBLinkBookHottest,     // 热榜
    DBLinkBookBestseller,  //畅销榜
    
#pragma mark - 搜索 SearchUrl
    DBLinkBookSearchResult, // 搜索结果列表
    DBLinkBookSearchHotWords, // 热门关键词
};

@interface DBLinkManager : NSObject

+ (NSString *)combineLinkWithType:(DBLinkType)type combine:(_Nullable id)combine;

@end

NS_ASSUME_NONNULL_END
