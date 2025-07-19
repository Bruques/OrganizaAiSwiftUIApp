//
//  NetworkManager.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 18/07/25.
//

import Foundation
import Alamofire

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
