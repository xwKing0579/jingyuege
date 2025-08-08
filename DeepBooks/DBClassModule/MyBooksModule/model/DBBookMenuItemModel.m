//
//  DBBookMenuItemModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import "DBBookMenuItemModel.h"

@implementation DBBookMenuItemModel

+ (NSArray *)dataSourceList{
    NSArray *dateList = @[@{@"isSwitch":@1,@"name":DBConstantString.ks_pinned,@"mid":@0},
                          @{@"isSwitch":@1,@"name":DBConstantString.ks_updateAlerts,@"mid":@1},
                          @{@"icon":@"jjLexiconGlyph",@"name":DBConstantString.ks_chapters,@"mid":@2},
                          @{@"icon":@"jjResonanceCapsule",@"name":DBConstantString.ks_viewReviews,@"mid":@3},
                          @{@"icon":@"jjFlourishCycle",@"name":DBConstantString.ks_saveForLater,@"mid":@4},
                          @{@"icon":@"jjAnnihilationSigil",@"name":DBConstantString.ks_deleteBook,@"mid":@5},
                          @{@"icon":@"jjEradicationSigil",@"name":DBConstantString.ks_clearCache,@"mid":@6},
                          @{@"icon":@"jjDiffusionNode",@"name":DBConstantString.ks_shareWithFriends,@"mid":@7},
    ];
    if (DBCommonConfig.switchAudit){
        dateList = @[@{@"isSwitch":@1,@"name":DBConstantString.ks_pinned,@"mid":@0},
                              @{@"isSwitch":@1,@"name":DBConstantString.ks_updateAlerts,@"mid":@1},
                              @{@"icon":@"jjLexiconGlyph",@"name":DBConstantString.ks_chapters,@"mid":@2},
                              @{@"icon":@"jjAnnihilationSigil",@"name":DBConstantString.ks_deleteBook,@"mid":@5},
                              @{@"icon":@"jjEradicationSigil",@"name":DBConstantString.ks_clearCache,@"mid":@6},
        ];
    }
    return [NSArray yy_modelArrayWithClass:self.class json:dateList];
}

@end
