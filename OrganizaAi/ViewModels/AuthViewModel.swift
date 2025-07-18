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
    @Published var isLoading = false
    @Published var showError = false
    
    func login() async {
        isLoading = true
        errorMessage = nil
        showError = false
        
        let loginRequestModel = LoginRequestModel(email: email,
                                                  password: password)
        do {
            let response = try await AuthService.shared.login(body: loginRequestModel)
            TokenManager.shared.saveToken(response.token)
            isAuthenticated = true
        } catch {
            errorMessage = "Login falhou. Verifique suas credenciais."
            showError = true
        }
        
        isLoading = false
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
