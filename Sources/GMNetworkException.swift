//
//  KKNetworkException.swift
//  kroknow-ios
//  网络异常
//  Created by Mac on 2021/5/8.
//  Copyright © 2021 com.kroknow. All rights reserved.
//

import Foundation

/// 网络请求错误
open class GMNetworkError: Codable {
    public let code:String?
    public let message:String?
    
    public init(code:String?, message:String?) {
        self.code = code
        self.message = message
    }
}
 
/// 网络请求异常
open class GMNetworkException : Codable, Error {
    
    public let error:GMNetworkError?
    public init(error:GMNetworkError?) {
        self.error = error
    }
}

/// 无网络异常
open class GMNotConnectException : GMNetworkException {}

/// 超时异常
open class GMConnectTimeoutException : GMNetworkException {}

/// 取消请求异常
open class GMRequestCanceledException : GMNetworkException {}
