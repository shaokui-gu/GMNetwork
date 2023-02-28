//
//  KK_NetUtil.swift
//  kroknow-ios
//  网络请求工具类
//  Created by Mac on 2021/5/8.
//  Copyright © 2021 com.kroknow. All rights reserved.
//

import Foundation
import Alamofire


/// 请求结果回调
public typealias GMResponseHandler = (GMNetworkRequest, AFDataResponse<Data>) -> Void

/// 拦截器
open class GMNetworkIntercepter : Interceptor {
    public let responseHandler: GMResponseHandler
    public init(adaptHandler: @escaping AdaptHandler, responseHandler:@escaping GMResponseHandler, retryHandler: @escaping RetryHandler) {
        self.responseHandler = responseHandler
        super.init(adaptHandler: adaptHandler, retryHandler: retryHandler)
    }
}

open class GMNetworkUtil {
    
    /// 单例
    public static let shareInstance = GMNetworkUtil()
        
    /// 拦截器
    public var intercapter:GMNetworkIntercepter?
    
    public init(){}
        
    /// 异步请求
    /// - Parameter request: 请求体
    /// - Returns: 请求任务
    @discardableResult
    public func request(request:GMNetworkRequest) -> GMNetworkTask {
        let url = request.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var dataRequest:DataRequest?
        var headers:[String : String] = [:]
        if let requestHeaders = request.headers {
            headers.merge(requestHeaders) { new, old in
                return new
            }
        }
        if request.dataArray.count == 0 {
            dataRequest = AF.request(url, method: request.method, parameters: request.parameters, encoder: JSONParameterEncoder.default, headers: HTTPHeaders(headers), interceptor: self.intercapter)
        } else {
            dataRequest = AF.upload(multipartFormData: { formData in
                for dataItem in request.dataArray {
                    if let url = dataItem.fileURL {
                        formData.append(url, withName: dataItem.fileKey)
                    } else if let data = dataItem.data {
                        formData.append(data, withName: dataItem.fileKey, fileName: dataItem.fileName, mimeType: dataItem.mineType)
                    }
                }
                if let params = request.parameters {
                    for (key, value) in params.dict {
                        let str:String = value as! String
                        let _datas:Data = str.data(using: String.Encoding.utf8)!
                        formData.append(_datas, withName: key)
                    }
                }
            }, to: url, method: request.method, headers: HTTPHeaders(headers), interceptor: self.intercapter)
        }
        dataRequest!.uploadProgress { (progress:Progress) in
            request.delegate?.updateRequestProgress(request:request, uploadProgress: Int(progress.completedUnitCount*100/progress.totalUnitCount), downloadProgress: 0)
        }
        dataRequest!.downloadProgress { (progress:Progress) in
            request.delegate?.updateRequestProgress(request:request, uploadProgress: 1, downloadProgress: Int(progress.completedUnitCount*100/progress.totalUnitCount))
        }
        dataRequest!.responseData { [weak self] (response) in
            self?.intercapter?.responseHandler(request, response)
        }
        request.delegate?.willSendRequest(request: request)
        let task = GMNetworkTask.init(request:dataRequest!)
        task.resume()
        return task
    }
    
    /// GET 请求
    /// - Parameters:
    ///   - path: url 路径
    ///   - delegate: 代理
    @discardableResult
    public func GET(_ url:String, headers:Dictionary<String,String>? = nil, delegate:GMNetworkDelegate? = nil, key:String? = nil, customArgs:Any? = nil, showHUD:Bool = false, _ serializer:GMNetworkResponseSerializer? = nil) -> GMNetworkTask {
        return self.request(request:GMNetworkRequest(url, method: .get, headers: headers, key: key, customArgs:customArgs, showHUD: showHUD, delegate:delegate, serializer:serializer))
    }
    
    /// POST 请求
    /// - Parameters:
    ///   - path: url 路径
    ///   - parameters: 参数
    ///   - delegate: 代理
    @discardableResult
    public func POST(_ url:String, parameters:Dictionary<String, Encodable>? = nil, headers:Dictionary<String,String>? = nil, delegate:GMNetworkDelegate?, key:String?, customArgs:Any? = nil, showHUD:Bool = false,_ serializer:GMNetworkResponseSerializer? = nil) -> GMNetworkTask {
        return self.request(request:GMNetworkRequest(url, method: .post, parameters: parameters == nil ? nil : Parameters.init(dict: parameters!), headers: headers, key: key, customArgs:customArgs, showHUD: showHUD, delegate:delegate, serializer:serializer))
    }
    
    /// PUT 请求
    /// - Parameters:
    ///   - path: url 路径
    ///   - parameters: 参数
    ///   - delegate: 代理
    @discardableResult
    public func PUT(_ url:String, parameters:Dictionary<String, Encodable>? = nil, headers:Dictionary<String,String>? = nil, delegate:GMNetworkDelegate?, key:String?, customArgs:Any?  = nil, showHUD:Bool = false,_ serializer:GMNetworkResponseSerializer? = nil) -> GMNetworkTask {
        return self.request(request:GMNetworkRequest(url, method: .put, parameters: parameters == nil ? nil : Parameters.init(dict: parameters!), headers: headers, key: key, customArgs:customArgs, showHUD: showHUD, delegate:delegate, serializer:serializer))
    }
    
    /// DELETE 请求
    /// - Parameters:
    ///   - path: url 路径
    ///   - delegate: 代理
    @discardableResult
    public func DELETE(_ url:String, parameters:Dictionary<String, Encodable>? = nil, headers:Dictionary<String,String>? = nil, delegate:GMNetworkDelegate?, key:String?, customArgs:Any? = nil, showHUD:Bool = false,_ serializer:GMNetworkResponseSerializer? = nil) -> GMNetworkTask {
        return self.request(request:GMNetworkRequest(url, method: .delete, parameters:parameters == nil ? nil : Parameters.init(dict: parameters!), headers: headers, key: key, customArgs:customArgs, showHUD: showHUD, delegate:delegate, serializer:serializer))
    }
    
    /// UPLOAD 请求
    /// - Parameters:
    ///   - path: url 路径
    ///   - delegate: 代理
    @discardableResult
    public func FORMDATA_REQUEST(_ url:String, dataArray:[GMNetworkFormData], parameters:Dictionary<String, Encodable>? = nil, headers:Dictionary<String,String>? = nil, customArgs:Any? = nil, method:HTTPMethod = .upload, delegate:GMNetworkDelegate?, key:String? , showHUD:Bool = false,_ serializer:GMNetworkResponseSerializer? = nil) -> GMNetworkTask {
        return self.request(request: GMNetworkRequest(url, method: method, parameters:parameters == nil ? nil : Parameters.init(dict: parameters!) ,dataArray: dataArray, headers: headers, key:key, customArgs:customArgs, showHUD: showHUD, delegate: delegate, serializer: serializer))
    }
}
