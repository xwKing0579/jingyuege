//
//  DBBookMenuItemModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import "DBBookMenuItemModel.h"

@implementation DBBookMenuItemModel

+ (NSArray *)dataSourceList{
    NSArray *dateList = @[@{@"isSwitch":@1,@"name":@"置顶书本",@"mid":@0},
                          @{@"isSwitch":@1,@"name":@"更新提醒",@"mid":@1},
                          @{@"icon":@"jjLexiconGlyph",@"name":@"目录列表",@"mid":@2},
                          @{@"icon":@"jjResonanceCapsule",@"name":@"查看书评",@"mid":@3},
                          @{@"icon":@"jjFlourishCycle",@"name":@"养肥本书",@"mid":@4},
                          @{@"icon":@"jjAnnihilationSigil",@"name":@"删除书籍",@"mid":@5},
                          @{@"icon":@"jjEradicationSigil",@"name":@"清除缓存",@"mid":@6},
                          @{@"icon":@"jjDiffusionNode",@"name":@"分享好友",@"mid":@7},
    ];
    if (DBCommonConfig.switchAudit){
        dateList = @[@{@"isSwitch":@1,@"name":@"置顶书本",@"mid":@0},
                              @{@"isSwitch":@1,@"name":@"更新提醒",@"mid":@1},
                              @{@"icon":@"jjLexiconGlyph",@"name":@"目录列表",@"mid":@2},
                              @{@"icon":@"jjAnnihilationSigil",@"name":@"删除书籍",@"mid":@5},
                              @{@"icon":@"jjEradicationSigil",@"name":@"清除缓存",@"mid":@6},
        ];
    }
    return [NSArray yy_modelArrayWithClass:self.class json:dateList];
}

@end
