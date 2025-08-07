//
//  DBBaseAlamofire.swift
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

import UIKit
import Alamofire


@objcMembers class DBBaseAlamofire: NSObject {
    static var domainString: String = ""
    static var ipAddressMap: [String:[String]] = [:]
    
    typealias responseBlock = (_ success: Bool ,_ serviceData: Any?, _ error: Error?) -> Void
    static func get(path: String, parameInterface: Parameters? = nil, responseBlock: responseBlock? = nil){
        self.request(path: path, method: .get, parameInterface: parameInterface, responseBlock: responseBlock)
    }
    
    static func post(path: String, parameInterface: Parameters? = nil, responseBlock: responseBlock? = nil){
        self.request(path: path, method: .post, parameInterface: parameInterface, responseBlock: responseBlock)
    }
    
    static func request(path: String, method: HTTPMethod, parameInterface: Parameters? = nil, responseBlock: responseBlock? = nil){
        if domainString.count == 0 ||  path.count == 0 {
            responseBlock?(false, nil, nil)
            return
        }
        AF.request(path, method: method, parameters: parameInterface,headers: self.configHeaders()).response(queue: .main) { response in

            if response.response?.statusCode == 404 {
                let matchIpMap = DBBaseAlamofire.ipAddressMap.filter({ path.contains($0.key) })
                if  matchIpMap.values.count > 0 {
                    requestIp(path: path, key: matchIpMap.keys.first, ipList: matchIpMap.values.first, ipIndex: 0, method: method, parameInterface: parameInterface, responseBlock: responseBlock, error: response.error)
                    return
                }
            }
            
            switch response.result {
            case .success(_):
                responseBlock?(true, response.data, nil)
            case .failure(_):
                responseBlock?(false, nil, response.error)
            }
        }
    }
    
    static func requestIp(path: String, key: String?, ipList: Array<String>?,ipIndex: Int, method: HTTPMethod, parameInterface: Parameters? = nil, responseBlock: responseBlock? = nil, error: Error?){
        if let key = key, let ipList = ipList, ipIndex < ipList.count{
            let url = path.replacingOccurrences(of: key, with: ipList[ipIndex])
            if let URL = safeURL(from: url) {
                AF.request(URL, method: method, parameters: parameInterface, headers: self.configHeaders(host: true)).response(queue: .main) { response in
                    switch response.result {
                    case .success(_):
                        responseBlock?(true, response.data, nil)
                    case .failure(_):
                        requestIp(path: path, key: key, ipList: ipList, ipIndex: ipIndex+1, method: method, parameInterface: parameInterface, responseBlock: responseBlock, error: error)
                    }
                }
            }else{
                responseBlock?(false, nil, error)
            }
        }else{
            responseBlock?(false, nil, error)
        }
    }
    
    static func uploadImage(path: String, parameInterface: Parameters? = nil, fileData: Data, responseBlock: responseBlock? = nil){
        if domainString.count == 0 ||  path.count == 0 {
            responseBlock?(false, nil, nil)
            return
        }
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            
            if let parameInterface = parameInterface {
                parameInterface.forEach { (key: String, value: Any) in
                    if let value = value as? String, let data = value.data(using: .utf8){
                        multipartFormData.append(data, withName: key)
                    }
                }
            }
        }, to:  path, method: .post,headers: self.configHeaders(), requestModifier: {$0.timeoutInterval = 120}).response(queue: .main) { response in
            switch response.result {
            case .success(_):
                responseBlock?(true, response.data, nil)
            case .failure(_):
                responseBlock?(false, nil, response.error)
            }
        }
    }
    
    static func download(path: String, fileName: String, responseBlock: @escaping responseBlock){
        let destination: DownloadRequest.Destination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName)
            return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(path, to: destination).response { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(_):
                    if let fileURL = response.fileURL, let data = try? Data(contentsOf: fileURL){
                        responseBlock(true, data, nil)
                    }else{
                        responseBlock(false, nil, nil)
                    }
                case .failure(_):
                    responseBlock(false, nil, response.error)
                }
            }
        }
    }
    
    static func configHeaders(host: Bool = false) -> HTTPHeaders {
        let date = NSDate()
        
        let p = "2"
        let time = String(date.timeStampInterval())
        let sign = date.timeSignString()
        let appBundle = UIApplication.appBundle()
        let version = UIApplication.appVersion()
        let idfv = UIDevice.deviceuuidString()
        let systemVersion = UIDevice.current.systemVersion
        let currentDeviceName = UIDevice.current.name
        let machine = UIDevice.currentDeviceModel()
        let singString = appBundle + version + idfv + systemVersion + currentDeviceName + machine + time
        let appsign = singString.md5()
        let deviceToken = UserDefaults.standard.object(forKey: "kPushDeviceToken")

        var headers: HTTPHeaders = ["package":appBundle,
                                    "version":version,
                                    "user":DBCommonConfig.userId(),
                                    "token":DBCommonConfig.userToken(),
                                    "pt":p,
                                    "time":time,
                                    "sign":sign,
                                    "Content-Type":"application/x-www-form-urlencoded",
                                    "Accept":"*/*",
                                    "Access-Control-Allow-Origin":"*",
                                    "Cache-Control":"no-cache",
                                    "Access-Control-Allow-Headers":"X-Requested-With",
                                    
                                    "idfv":idfv,
                                    "systemVersion":systemVersion,
                                    "deviceName":currentDeviceName,
                                    "machine":machine,
                                    "appsign":appsign,
                                    "Connection": "close" 
                                    ]
        if host == true {
            headers.update(name: "Host", value: "conf."+domainString)
        }
        if let deviceToken = deviceToken as? String{
            headers.update(name: "deviceToken", value: deviceToken)
        }
#if DEBUG
        headers.update(name: "singString", value: singString)
#endif
        return headers
    }
    
    private static func safeURL(from urlString: String) -> URL? {
        let decodedString = urlString.removingPercentEncoding ?? urlString
        
        guard let originalURL = URL(string: decodedString) else {
            return URL(string: urlString)
        }
        
        guard let host = originalURL.host else {
            return originalURL
        }
        
        if isIPv6Host(host) {
            print("Detected IPv6 host: \(host)")
            return formatIPv6URL(from: originalURL)
        }
        
        return originalURL
    }
    

    private static func isIPv6Host(_ host: String) -> Bool {
        let unwrappedHost = host
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
        
        return isPureIPv6(unwrappedHost)
    }
    
    private static func isPureIPv6(_ string: String) -> Bool {
        var ipv6Addr = in6_addr()
        return string.withCString { cString in
            return inet_pton(AF_INET6, cString, &ipv6Addr) == 1
        }
    }
    
    private static func formatIPv6URL(from url: URL) -> URL? {
        guard let host = url.host else {
            return url
        }
        
        var components = URLComponents()
        components.scheme = url.scheme
        components.port = url.port
        
        if !host.hasPrefix("[") {
            components.host = "[\(host)]"
        } else {
            components.host = host
        }
        
        components.path = url.path
        components.query = url.query
        components.fragment = url.fragment
        
        return components.url ?? url
    }
}
