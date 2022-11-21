//
//  PXNet.swift
//  PXKitDemo
//
//  Created by marco on 2019/11/8.
//  Copyright © 2019 flywire. All rights reserved.
//

import Foundation
import Alamofire

public typealias completeHandler = (_ error:Error?,_ result:[String:Any]?)->Void

public class PXNet {

    public static let shared = PXNet()

    public func get(
        _ url: String,
        parameters: [String:Encodable]? = nil,
        complete:completeHandler? = nil)
    {
//        AF.request(url,parameters: parameters).responseDecodable(of: DecodableType.self) { response in
//            debugPrint(response)
//        }
    }

    public func post(
        _ url: String,
        parameters: [String:Encodable]? = nil,
        complete:completeHandler? = nil)
    {
        
    }

    public func request(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: [String:Encodable]? = nil,
        complete:completeHandler? = nil)
    {
        //接口转换
        
        //调用三方

//        Alamofire.request(url, method: method,parameters: parameters,encoding: URLEncoding.default,headers:nil).responseJSON { response
//                           in
//                           switch response.result.isSuccess {
//                           case true:
//                               if let value = response.result.value{
//                                    print("请求到返回的数据\(value)")
//                                    guard let succ = complete else {return }
//                                    succ(nil,[:])
//                               }
//                           case false:
//                                print(response.result.error)
//                                guard let fail = complete else {return }
//                                fail(nil,nil)
//                           }
//                       }
    }
}

