//
//  AuthService.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 17/07/25.
//

import Foundation
import Alamofire

class AuthService {
    static let shared = AuthService()
    let network: NetworkManager
    let baseURL = "http://localhost:8080/api/auth"
    private init(network: NetworkManager = NetworkManager()) {
        self.network = network
    }
    
    public func login(body: LoginRequestModel) async throws -> LoginResponseModel {
        let loginUrl = "\(baseURL)/login"
        // TODO: - Testar para ver se preciso manter o header ou não
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        
        let response = try await network.request(method: .post,
                                                 url: loginUrl,
                                                 headers: headers,
                                                 params: [:],
                                                 body: body,
                                                 of: LoginResponseModel.self)
        return response
    }
    
    public func register(body: RegisterRequestModel) async throws -> LoginResponseModel {
        let registerUrl = "\(baseURL)/register"
        // TODO: - Testar para ver se preciso manter o header ou não
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        
        let response = try await network.request(method: .post,
                                                 url: registerUrl,
                                                 headers: headers,
                                                 params: [:],
                                                 body: body,
                                                 of: LoginResponseModel.self)
        return response
    }
}

class NetworkManager {
    func request<T: Decodable>(
        method: HTTPMethod,
        url: String,
        headers: [String: String]? = nil,
        params: Parameters? = nil,
        body: Encodable? = nil,
        of type: T.Type
    ) async throws -> T {
        
        var parameterEncoding: ParameterEncoding = URLEncoding.default
        var requestParameters: Parameters? = params
        
        if let encodableBody = body {
            do {
                let jsonData = try JSONEncoder().encode(encodableBody)
                requestParameters = try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed) as? Parameters
                parameterEncoding = JSONEncoding.default
            } catch {
                throw error
            }
        } else {
            switch method {
            case .post, .put, .patch:
                parameterEncoding = JSONEncoding.default
            default:
                parameterEncoding = URLEncoding.default
            }
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: requestParameters,
                encoding: parameterEncoding,
                headers: HTTPHeaders(headers ?? [:])
            )
            .responseDecodable(of: type) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
