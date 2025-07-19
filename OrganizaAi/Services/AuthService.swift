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

