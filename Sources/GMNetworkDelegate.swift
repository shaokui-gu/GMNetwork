//
//  KKNetworkDelegate.swift
//  kroknow-ios
//  网络请求工具回调代理
//  Created by Mac on 2021/5/8.
//  Copyright © 2021 com.kroknow. All rights reserved.
//

public protocol GMNetworkDelegate {
    
    /// 即将发送请求
    /// - Parameter request: 请求体
    func willSendRequest(request:GMNetworkRequest)
    
    /// 更新请求进度
    /// - Parameters:
    ///   - uploadProgress: 上传进度0-100
    ///   - downloadProgress: 下载进度0-100
    func updateRequestProgress(request:GMNetworkRequest, uploadProgress:Int, downloadProgress:Int)
    
    /// 成功发送请求
    /// - Parameter request: 请求体
    func didSendRequest(request:GMNetworkRequest)
    
    /// 成功收到响应体
    /// - Parameters:
    ///   - request: 请求体
    ///   - response: 响应体
    func onResonse(request:GMNetworkRequest,response:GMNetworkResponse)
    
    /// 请求/处理响应过程中发生异常
    /// - Parameter exception: 异常
    func onException(request: GMNetworkRequest, exception:GMNetworkException?)
}
