//
//  BaseRequest.swift
//  WFInputDemo_Example
//
//  Created by benny wang on 2021/1/7.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import HandyJSON

// MARK: - 响应结构体
public struct ELResponseModel: HandyJSON {
    var errcode: Int?
    var errmsg: String?
    var data: Any?
    public init() {
        
    }
}

open class BaseRequest: NSObject {
    
    public static let share: BaseRequest = BaseRequest()
    
    static let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Session(configuration: configuration)
    }()
    
    public static let failResponse: ELResponseModel = ELResponseModel.deserialize(from: ["errcode": 16384, "errmsg": "请求失败"])!
    
    /// 配置Host
    public let BaseURL = ""
    
    public func request(
        _ pathname: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        isNeedToken: Bool = true,
        host: String = "\(BaseRequest.share.BaseURL)",
        successCallback :  @escaping (_ response: ELResponseModel) -> Void,
        errorCallback: @escaping (_ error: ELResponseModel) -> Void) {
        let urlStr = "\(host)\(pathname)"

        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let request = BaseRequest.session.request(urlStr, method: method, parameters: parameters ?? nil, encoding: JSONEncoding.default, headers: headers)
        request.responseJSON { (response) in
            let res = self.getResponseModel(response)
            switch response.result {
                case .success:
                    if let code = res.errcode {
                        if code == 0 {
                            successCallback(res)
                        } else {
                            errorCallback(res)
                        }
                    } else {
                        errorCallback(res)
                    }
                case .failure(let error):
                    let errorRes = ELResponseModel.deserialize(from: ["errmsg": error.localizedDescription, "errcode": error._code])!
                    errorCallback(errorRes)
            }
        }
    }
    
    /**
     处理响应数据
     */
    public func getResponseModel (_ response: AFDataResponse<Any>) -> ELResponseModel {
        switch response.result {
        case .success(let value):
            if let dic = value as? NSDictionary {
                return ELResponseModel.deserialize(from: dic) ?? BaseRequest.failResponse
            } else {
                return BaseRequest.failResponse
            }
        case .failure:
            return BaseRequest.failResponse
        }
    }
}
