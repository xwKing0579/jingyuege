//
//  DBSearchTagModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import "DBSearchTagModel.h"

@implementation DBSearchTagModel

- (instancetype)init{
    if (self == [super init]){
        self.font = DBFontExtension.bodyMediumFont;
        self.margin = 16;
        self.spacing = 20;
        self.thicken = 24;
        self.textColor = DBColorExtension.charcoalColor;
        self.borderColor = DBColorExtension.paleGrayColor;
        self.borderRadius = 17;
        self.borderWidth = 1;
        
    }
    return self;
}

+ (NSArray *)tagsList{
    return DBAppSetting.setting.tagList ?: @[@"豪婿", @"医妃倾天下", @"我不想继承万亿家产", @"生而为王", @"斗破苍穹", @"斗罗大陆", @"上门兵王", @"全职高手",
             @"重生", @"超级女婿", @"系统", @"上门女婿", @"火影", @"最佳女婿", @"超级人生", @"长生十万年", @"斗罗大陆IV终极斗罗", @"魔道祖师",
             @"最强高手在花都", @"唐家三少", @"逆天邪神", @"我吃西红柿", @"快穿", @"华丽逆袭", @"重生医妃", @"元尊",
             @"都市之最强狂兵", @"顶级神豪", @"都市极品医神", @"漫威", @"洪荒", @"天蚕土豆", @"末世", @"第一赘婿", @"神医凰后", @"三国",
             @"变身", @"仙尊归来", @"穿越", @"萧阳", @"狂婿", @"无限", @"我在万界送外卖", @"斗罗", @"伏天氏", @"医妃权倾天下",
             @"神奇宝贝", @"大主宰", @"首席继承人", @"最强狂兵"];
}

@end
