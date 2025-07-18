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
}

enum AuthError: Error, LocalizedError {
    case invalidCredentials // Para 401 Unauthorized ou outros erros de credenciais
    case serverError(statusCode: Int, message: String?) // Erros do servidor (5xx, ou 4xx não específicos)
    case decodingError(Error) // Erros ao decodificar a resposta
    case unknownError(Error) // Erros genéricos

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Credenciais inválidas. Verifique seu e-mail e senha."
        case .serverError(let statusCode, let message):
            return "Erro do servidor (\(statusCode)): \(message ?? "Ocorreu um erro inesperado no servidor.")"
        case .decodingError(let error):
            return "Erro de decodificação: \(error.localizedDescription)"
        case .unknownError(let error):
            return "Um erro desconhecido ocorreu: \(error.localizedDescription)"
        }
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
