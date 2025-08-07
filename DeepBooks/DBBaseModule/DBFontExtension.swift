//
//  DBFontExtension.swift
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/23.
//

import Foundation


@objcMembers class DBFontExtension: NSObject {
    
    static func captionFont() -> UIFont{
        return UIFont.pingFangRegular08()
    }
    static func microFont() -> UIFont{
        return UIFont.pingFangRegular10()
    }
    static func bodySmallFont() -> UIFont{
        return UIFont.pingFangRegular12()
    }
    static func bodyMediumFont() -> UIFont{
        return UIFont.pingFangRegular14()
    }
    static func bodySixTenFont() -> UIFont{
        return UIFont.pingFangRegular16()
    }
    static func titleSmallFont() -> UIFont{
        return UIFont.pingFangRegular18()
    }
    static func titleBigFont() -> UIFont{
        return UIFont.pingFangRegular20()
    }
    static func titleLargeFont() -> UIFont{
        return UIFont.pingFangRegular30()
    }
    
    
    
    static func pingFangMediumSmall() -> UIFont{
        return UIFont.pingFangMedium12()
    }
    static func pingFangMediumRegular() -> UIFont{
        return UIFont.pingFangMedium14()
    }
    static func pingFangMediumMedium() -> UIFont{
        return UIFont.pingFangMedium15()
    }
    static func pingFangMediumLarge() -> UIFont{
        return UIFont.pingFangMedium16()
    }
    static func pingFangMediumXLarge() -> UIFont{
        return UIFont.pingFangMedium18()
    }
    
    
    static func pingFangSemiboldRegular() -> UIFont{
        return UIFont.pingFangSemibold14()
    }
    static func pingFangSemiboldLarge() -> UIFont{
        return UIFont.pingFangSemibold16()
    }
    static func pingFangSemiboldXLarge() -> UIFont{
        return UIFont.pingFangSemibold18()
    }
    static func pingFangSemiboldXXLarge() -> UIFont{
        return UIFont.pingFangSemibold20()
    }
    static func pingFangSemiboldBigHeader() -> UIFont{
        return UIFont.pingFangSemibold32()
    }
    
}
