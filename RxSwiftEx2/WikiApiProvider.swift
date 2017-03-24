//
//  WikiApiProvider.swift
//  RxSwiftEx2
//
//  Created by Waratnan Suriyasorn on 3/24/2560 BE.
//  Copyright © 2560 Waratnan Suriyasorn. All rights reserved.
//

import Foundation
import RxSwift
import Moya

let baseApiURL = "https://en.wikipedia.org/api/rest_v1"

//MARK: - Api Provider
let ApiProvider = RxMoyaProvider<Wiki>(plugins: [NetworkLoggerPlugin(verbose: true)])

public enum Wiki {
    case feed(date: String, month: String, year: String)
    case randomArticle
    case relate(title: String)
}

extension Wiki: TargetType {
    public var baseURL: URL {
        return URL(string: baseApiURL)!
    }
    
    public var path: String {
        switch self {
        case .feed(let date, let month, let year): return "/feed/featured/\(year)/\(month)/\(date)"
        case .randomArticle: return "/page/random/related"
        case .relate(let title): return "/page/related/\(title)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    public var parameters: [String : Any]? {
        return nil
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        return .request
    }
}
