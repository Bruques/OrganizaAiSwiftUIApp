//
//  AuthViewModel.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 17/07/25.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    func login() async {
        let loginRequestModel = LoginRequestModel(email: email,
                                                  password: password)
        do {
            let response = try await AuthService.shared.login(body: loginRequestModel)
            TokenManager.shared.saveToken(response.token)
            isAuthenticated = true
        } catch {
            errorMessage = "Login falhou. Verifique suas credenciais."
        }
    }
    
    func logout() {
        TokenManager.shared.clearToken()
        isAuthenticated = false
    }
    
    func checkAuthentication() {
        if let _ = TokenManager.shared.getToken() {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
}
