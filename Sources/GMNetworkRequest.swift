//
//  KKNetworkRequest.swift
//  kroknow-ios
//  网络请求体
//  Created by Mac on 2021/5/8.
//  Copyright © 2021 com.kroknow. All rights reserved.
//

import Foundation
import Alamofire

/// Encode
public struct EncodableValue: Encodable {
    let value: Encodable
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

/// Parameters
public struct Parameters: Encodable {
    public var dict: [String: Encodable] = [:]
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for (key, value) in dict {
            guard let codingKey = CodingKeys(stringValue: key) else {
                continue
            }
            let enc = EncodableValue.init(value: value)
            try container.encode(enc, forKey: codingKey)
        }
    }

    struct CodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil;
        }
    }
}

public extension HTTPMethod {
    static let upload = HTTPMethod(rawValue: "UPLOAD")
}

/// Formdata parameter
open class GMNetworkFormData {
    public let fileKey:String
    public let fileName:String?
    public let mineType:String?
    public let fileURL:URL?
    public let data:Data?
    
    public init( data:Data? = nil, fileURL:URL? = nil, fileKey:String = "file", fileName:String = (UUID().uuidString + ".jpg"), mineType:String? = nil) {
        self.data = data
        self.fileURL = fileURL
        self.fileKey = fileKey
        self.fileName = fileName
        self.mineType = mineType
    }
}

/// Request
open class GMNetworkRequest {
    public var url = ""
    public var method:HTTPMethod
    public var customArgs:Any?
    public var parameters:Parameters?
    public var headers:Dictionary<String,String>?
    public var timeOut:Int = 3
    public var key:String?
    public var showHUD:Bool = true
    public var delegate:GMNetworkDelegate?
    public var serializer: GMNetworkResponseSerializer?
    public var dataArray:[GMNetworkFormData]
    
    public init(_ url:String, method:HTTPMethod = .get, parameters:Parameters? = nil, dataArray:[GMNetworkFormData] = [], headers:Dictionary<String,String>? = nil, timeOut:Int = 3, key:String? = nil, customArgs:Any? = nil, showHUD:Bool = true, delegate:GMNetworkDelegate? = nil, serializer: GMNetworkResponseSerializer? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.customArgs = customArgs
        self.dataArray = dataArray
        self.headers = headers
        self.timeOut = timeOut
        self.key = key
        self.showHUD = showHUD
        self.delegate = delegate
        self.serializer = serializer
    }
}
