//
//  DBDefaultSwift.swift
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/7.
//

import Foundation
import Alamofire
import IQKeyboardManagerSwift
import CryptoKit

class DBVideoDownload: NSObject{

    @objc static func videoDownload(url: String, completion: @escaping (Bool) -> Void) {
        if self.videoCachePath(url: url) != nil {
            completion(true)
            return
        }

        guard let URL = URL(string: url) else {
            completion(false)
            return
        }
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(url.md532BitLower()+URL.lastPathComponent)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(url ,requestModifier: {$0.timeoutInterval = 30}, to: destination).downloadProgress { progress in
            
        }.response { response in
            if response.error != nil {
               completion(false)
            } else if response.fileURL != nil {
                completion(true)
            }
        }
    }
    
    @objc static func videoCachePath(url: String) -> URL?{
        guard let URL = URL(string: url) else {
            return nil
        }
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = directory.appendingPathComponent(url.md532BitLower()+URL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        } else {
            return nil
        }
    }
}




@objcMembers class DBDefaultSwift : NSObject {
    @MainActor static func enableKeyboard() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    @MainActor static func disableKeyboard() {
        IQKeyboardManager.shared.isEnabled = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
}

extension String {
    func md5() -> String {
        let data = Data(self.utf8)
        let digest = Insecure.MD5.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
