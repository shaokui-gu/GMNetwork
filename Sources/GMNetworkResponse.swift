//
//  KKNetworkResponse.swift
//  kroknow-ios
//  网络响应体
//  Created by Mac on 2021/5/8.
//  Copyright © 2021 com.kroknow. All rights reserved.
//

import Foundation

/// 序列化
public typealias GMNetworkResponseSerializer = (Data?) throws -> AnyObject?

/// 请求结果
open class GMNetworkResponse {
    public var data:Any?
    public init(data:Any?) {
        self.data = data
    }
}
