//
//  AuthInterceptor.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 18/07/25.
//

import Foundation
import Alamofire

class AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {

        var request = urlRequest

        if let token = TokenManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        completion(.success(request))
    }
}
