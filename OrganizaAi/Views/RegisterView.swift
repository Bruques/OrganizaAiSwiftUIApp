//
//  RegisterView.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 18/07/25.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject private var viewModel: RegisterViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Criar Conta")
                .font(.largeTitle.bold())
            
            TextField("Nome", text: $viewModel.name)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            SecureField("Senha", text: $viewModel.password)
                .textContentType(.newPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            SecureField("Confirmar senha", text: $viewModel.confirmPassword)
                .textContentType(.oneTimeCode)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top)
            } else {
                Button(action: {
                    Task {
                        await viewModel.register()
                    }
                }) {
                    Text("Criar conta")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!viewModel.isRegisterButtonEnabled)
                .opacity(viewModel.isRegisterButtonEnabled ? 1 : 0.5)
            }
            
            Button("Já tem uma conta? Entrar") {
                dismiss()
            }
        }
        .padding()
        .alert("Registrado com sucesso", isPresented: $viewModel.registrationSuccess) {
            Button("OK") {
                dismiss()
            }
        }
    }
}

#Preview {
    RegisterView(viewModel: RegisterViewModel())
}
