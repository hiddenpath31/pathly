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
    func sendEvent(requestData: EventRequest)
}

final class ApplicationNetworkService: ApplicationNetworkServiceInterface {
      
    private var cancellables = Set<AnyCancellable>()
    
    func servers(apiKey: String) -> AnyPublisher<[Server], ErrorResponse> {
        return NetworkService.request(ApplicationEndpoint.servers(apiKey: apiKey))
    }
    
    private func sendEvent(requestData: EventRequest) -> AnyPublisher<String, ErrorResponse> {
        return NetworkService.request(ApplicationEndpoint.events(requestData: requestData))
    }
    
    func sendEvent(requestData: EventRequest) {
        self.sendEvent(requestData: requestData).sink { completionHandler in
            switch completionHandler {
                case .failure(let error):
                    print(error)
                default:
                    break
            }
        } receiveValue: { response in
            print(response)
        }.store(in: &cancellables)
    }
    
}

enum ApplicationEndpoint: URLRequestConvertible {

//    static let route: String = "servers.php"
    
    case servers(apiKey: String)
    case events(requestData: EventRequest)
    
    func asURLRequest() throws -> URLRequest {
        let url = try EnvironmentConfiguration.current.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
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
        case .events:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .servers:
            return "servers.php"
        case .events:
            return "events.php"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .servers(let apiKey):
            var params = [String: String]()
            params["api_key"] = apiKey
            return params
        case .events(let requestData):
            return requestData.doDict()
        }
    }
    
}
