//
//  RegisterViewModel.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 18/07/25.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var registrationSuccess = false
    
    var isEmailValid: Bool {
        return email.contains("@") && email.contains(".") && email.count >= 5
    }
    
    var isPasswordValid: Bool {
        return password.count >= 6
    }
    
    var passwordsMatch: Bool {
        return password == confirmPassword && !password.isEmpty
    }
    
    var isRegisterButtonEnabled: Bool {
        return isEmailValid && isPasswordValid
    }
    
    func register() async {
        guard isPasswordValid && passwordsMatch else {
            errorMessage = "As senhas devem ser iguais e maiores que 6 caracteres"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let registerModel = RegisterRequestModel(name: name,
                                                 email: email,
                                                 password: password)
        do {
            let _ = try await AuthService.shared.register(body: registerModel)
            await MainActor.run {
                registrationSuccess = true
            }
        } catch {
            await MainActor.run {
                errorMessage = "Falha ao registrar: \(error.localizedDescription)"
            }
        }
        await MainActor.run {
            isLoading = false
        }
    }
}
