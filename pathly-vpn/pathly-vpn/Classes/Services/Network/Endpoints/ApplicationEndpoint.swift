//
//  ApplicationEndpoint.swift
//  odola-app
//
//  Created by Александр on 12.10.2024.
//

import Foundation
import Alamofire
import Combine

struct ServerResponse: Codable {
    var servers: [Server]
}

protocol ApplicationNetworkServiceInterface: AnyObject {
    func servers(apiKey: String) -> AnyPublisher<[Server], ErrorResponse>
}

final class ApplicationNetworkService: ApplicationNetworkServiceInterface {
      
    func servers(apiKey: String) -> AnyPublisher<[Server], ErrorResponse> {
        return NetworkService.request(ApplicationEndpoint.servers(apiKey: apiKey))
    }
    
}

enum ApplicationEndpoint: URLRequestConvertible {

    static let route: String = "servers.php"
    
    case servers(apiKey: String)
    
    func asURLRequest() throws -> URLRequest {
        let url = try EnvironmentConfiguration.current.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(ApplicationEndpoint.route + path))
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    private var method: HTTPMethod {
        switch self {
        case .servers:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .servers:
            return ""
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .servers(let apiKey):
            var params = [String: String]()
            params["api_key"] = apiKey
            return params
        }
    }
    
}
