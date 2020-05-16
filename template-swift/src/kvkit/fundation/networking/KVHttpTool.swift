//
//  KVHttpTool.swift
//  template-swift
//
//  Created by kevin on 2020/5/15.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class KVHttpTool: NSObject {
    
    typealias SetterBlock<T> = (T)->KVHttpTool?
    
    struct Info {
        var method: HTTPMethod = .get
        var parameters: Parameters?
        var headers: [String: String]?
    }
    
    // MARK:-
    
    private(set) var url: String? = nil;
    
    private(set) lazy var params: SetterBlock<HTTPMethod> = { [weak self] it in
        self?.sem.wait()
        defer {
            self?.sem.signal()
        }
        self?.info.method  = it
        return self
    }
    
    private(set) lazy var parameters: SetterBlock<Parameters?> = { [weak self] parameters in
        self?.sem.wait()
        defer {
            self?.sem.signal()
        }
        self?.info.parameters = parameters
        return self
    }
    
    private(set) lazy var headers: SetterBlock<[String: String]?> = { [weak self] headers in
        self?.sem.wait()
        defer {
            self?.sem.signal()
        }
        self?.info.headers = headers
        return self
    }
    
    
        
    private(set) lazy var send: ()->Void = { }
    
    private lazy var info = Info()
    
    private let sem = DispatchSemaphore(value: 1)
    
    // MARK:-
    
    static func request(url: String) -> Self {
        return self.init(url: url)
    }
    
    internal required init(url: String) {
        super.init()
        self.url = url;
        self.send = { [weak self] in
            self?.impSend()
        }
    }
    
    /**
     
     _ convertible: URLConvertible,
     method: HTTPMethod = .get,
     parameters: Parameters? = nil,
     encoding: ParameterEncoding = URLEncoding.default,
     headers: HTTPHeaders? = nil,
     interceptor: RequestInterceptor? = nil,
     requestModifier: RequestModifier? = nil
     */
    
    private func impSend() {
        guard let urlString = self.url, let url = URL(string: urlString),
            let paramsData = try? JSONSerialization.data(withJSONObject: info.parameters ?? [:], options: .prettyPrinted) else {
            return;
        }
        
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = info.method.rawValue
        req.allHTTPHeaderFields = info.headers
        req.httpBody = paramsData
    }
        
//        AF.request(url, method: method, parameters: params).response { (res) in
//
//            // 请求出错
//            guard res.error == nil, let data = res.data else {
//                let error = KVError(msg: "网络连接错误", code: 0, description: "")
//                log(url: url, params: params, error: error, data: nil)
//                reject(error)
//                return
//            }
//
//            // 解析
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
//                let dict = json as? [String: Any] else {
//                let error = KVError(msg: "解析数据出错", code: 0, description: "")
//                log(url: url, params: params, error: error, data: nil)
//                reject(error)
//                return
//            }
//
//            // 请求成功并打印
//            log(url: url, params: params, error: nil, data: data)
//
//            // 业务报错
//            let msg = dict["msg"] as? String ?? "服务器返回错误"
//            let code = dict["code"] as? Int ?? -1
//            if code != 0 {
//                if code == 401 {
//                    relogin(msg)
//                }
//                reject(KVError(msg: msg, code: code, description: ""))
//                return
//            }
//
//            // json to model
//            let jsonDecoder = JSONDecoder()
//            if let model: ResT = try? jsonDecoder.decode(ResT.self, from: data) {
//                filfull(model)
//            } else {
//                reject(KVError(msg: "数据转换失败", code: 0, description: ""))
//            }
//        }
//    }
    

}

private struct Api {
//    static func loadData<ResT: Codable>(_ url: String, method: HTTPMethod = .get, params paramsDict : [String : Any]? = nil, insertToken: Bool = false) {
//
//        // 插入token
//        var params: [String : Any] = paramsDict ?? [:]
//        if insertToken == true, let token = UserInfoManager.sharedInstance.data?.accessToken {
//            params["access_token"] = token
//        }
//
//        AF.request(url, method: method, parameters: params).response { (res) in
//
//            // 请求出错
//            guard res.error == nil, let data = res.data else {
//                let error = KVError(msg: "网络连接错误", code: 0, description: "")
//                log(url: url, params: params, error: error, data: nil)
//                return
//            }
//
//            // 解析
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
//                let dict = json as? [String: Any] else {
//                let error = KVError(msg: "解析数据出错", code: 0, description: "")
//                log(url: url, params: params, error: error, data: nil)
//                reject(error)
//                return
//            }
//
//            // 请求成功并打印
//            log(url: url, params: params, error: nil, data: data)
//
//            // 业务报错
//            let msg = dict["msg"] as? String ?? "服务器返回错误"
//            let code = dict["code"] as? Int ?? -1
//            if code != 0 {
//                if code == 401 {
//                    relogin(msg)
//                }
//                let error = KVError(msg: msg, code: code, description: "")
//                return
//            }
//
//            // json to model
//            let jsonDecoder = JSONDecoder()
//            if let model: ResT = try? jsonDecoder.decode(ResT.self, from: data) {
//
//            } else {
//                let error = KVError(msg: "数据转换失败", code: 0, description: "")
//            }
//        }
//
//    }
//
//    static func log(url: String, params: [String : Any]? = nil, error: KVError? = nil, data: Data? = nil) {
//        #if DEBUG
//
//        KLog("--- api res log ---")
//        KLog("url: \(url)")
//        if let paramsData = try? JSONSerialization.data(withJSONObject: params ?? [:], options: []) {
//            if let log = String(data: paramsData, encoding: .utf8) {
//                KLog("params: \n \(log)")
//            }
//        }
//
//        if error != nil {
//            KLog("\(error?.msg ?? "错误")\n")
//        } else {
//            KLog("请求成功\n")
//            if let data = data {
//                if let log = String(data: data, encoding: .utf8) {
//                    KLog("res data: \n \(log)")
//                }
//            }
//        }
//
//        KLog("--- api res log ---")
//
//        #endif
//    }
//
//    static func relogin(_ resoan: String) {
//        UserInfoManager.sharedInstance.relogin(reason: resoan)
//    }
}



