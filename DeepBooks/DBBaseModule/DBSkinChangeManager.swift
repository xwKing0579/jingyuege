//
//  DBSkinChangeManager.swift
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/3.
//

import UIKit

@objcMembers class DBSkinChangeManager: NSObject {
    static func textColorDict() -> Dictionary<UIColor, UIColor>{
        return [
            DBColorExtension.charcoalColor():DBColorExtension.lightGrayColor(),
            DBColorExtension.gunmetalColor():DBColorExtension.standardSliverGray(),
            DBColorExtension.grayColor():DBColorExtension.slateGrayColor(),
            
            DBColorExtension.blackAltColor():DBColorExtension.whiteAltColor(),
        ]
    }
    
    static func textColorInvertedDict() -> Dictionary<UIColor, UIColor>{
        return textColorDict().inverted()
    }
    
    static func backgroundColorDict() -> Dictionary<UIColor, UIColor>{
        return [
            DBColorExtension.whiteColor():DBColorExtension.jetBlackColor(),
            DBColorExtension.charcoalColor():DBColorExtension.lightSlateColor(),
            DBColorExtension.paleGrayColor():DBColorExtension.deepBlackColor(),
            DBColorExtension.cloudGrayColor():DBColorExtension.sanyOneColor(),
            
            DBColorExtension.whiteAltColor():DBColorExtension.blackAltColor(),
            DBColorExtension.diatomColor():DBColorExtension.rwilightPlumColor(),
        ]
    }
    
    static func backgroundColorInvertedDict() -> Dictionary<UIColor, UIColor>{
        return backgroundColorDict().inverted()
    }
}


extension Dictionary where Value: Hashable {
    func inverted() -> [Value: Key] {
        var result = [Value: Key]()
        for (key, value) in self {
            result[value] = key
        }
        return result
    }
}
