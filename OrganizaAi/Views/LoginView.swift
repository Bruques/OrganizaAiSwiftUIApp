//
//  LoginView.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 17/07/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showErrorAlert: Bool = false
    
    @State private var navigateToRegister = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Entrar")
                    .font(.largeTitle)
                    .bold()

                VStack(alignment: .leading, spacing: 15) {
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    SecureField("Senha", text: $viewModel.password)
                        .textContentType(.password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top)
                } else {
                    Button(action: {
                        Task {
                            await viewModel.login()
                        }
                    }) {
                        Text("Entrar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    // TODO: - criar método na viewModel para fazer essa validação
                    .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
//                    .background(email.isEmpty || password.isEmpty ? .opacity(0.5) : .opacity(1))
                    .opacity(viewModel.email.isEmpty || viewModel.password.isEmpty ? 0.5 : 1)
                }
                Spacer()
                NavigationLink(destination: RegisterView(viewModel: self.viewModel.makeRegisterViewModel()),
                               isActive: $navigateToRegister) {
                    Button {
                        navigateToRegister = true
                    } label: {
                        Text("Não tem uma conta? Registre-se")
                            .bold()
                    }

                }
            }
            .padding()
            .alert(isPresented: $viewModel.showError) {
                Alert(title: Text("Erro"),
                      message: Text(viewModel.errorMessage ?? ""),
                      dismissButton: .default(Text("OK")))
            }
            
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
