//
//  NetworkReachability.swift
//  Polytime
//  网络状态监听
//  Created by gavin on 2021/10/26.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation
import Reachability

/// 观察者
public protocol GMReachabilityListener {
    var identifire:String { get }
    func onReachable(_ reachability:Reachability)
    func onUnReachable(_ reachability:Reachability)
}

/// 监听器
open class GMNetworkReachability {
    public static let instance = GMNetworkReachability()
    private let reachability = try! Reachability()
    private var listeners:[GMReachabilityListener] = []
    
    private init() {
        reachability.whenReachable = { reachability in
            self.listeners.forEach { listener in
                listener.onReachable(reachability)
            }
        }
        reachability.whenUnreachable = { reachability in
            self.listeners.forEach { listener in
                listener.onUnReachable(reachability)
            }
        }
    }
    
    /// 开始监听
    public func startNotifier() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    /// 添加观察者
    public func addListener<T:GMReachabilityListener>(_ listener:T) {
        let contain = listeners.contains(where: { item in
            return item.identifire == listener.identifire
        })
        if !contain {
            listeners.append(listener)
        }
    }
    
    /// 移除观察者
    public func removeListener<T:GMReachabilityListener>(_ listener:T) {
        listeners.removeAll { item in
            return item.identifire == listener.identifire
        }
    }
}
