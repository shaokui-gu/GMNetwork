//
//  KKNetworkTask.swift
//  kroknow-ios
//  网络请求任务
//  Created by Mac on 2021/5/8.
//  Copyright © 2021 com.kroknow. All rights reserved.
//

import Foundation
import Alamofire

public class GMNetworkTask {

    /// AF请求
    private var request:DataRequest?
    init(request:DataRequest) {
        self.request = request
    }
    
    /// 取消请求
    public func cancel() {
        request?.cancel()
    }

    /// 发送请求
    public func resume(){
        request?.resume()
    }

}
