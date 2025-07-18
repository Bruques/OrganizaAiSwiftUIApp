//
//  LoginView.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 17/07/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showErrorAlert: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Entrar")
                    .font(.largeTitle)
                    .bold()

                VStack(alignment: .leading, spacing: 15) {
                    TextField("Email", text: $authViewModel.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    SecureField("Senha", text: $authViewModel.password)
                        .textContentType(.password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top)
                } else {
                    Button(action: {
                        Task {
                            await authViewModel.login()
                        }
                    }) {
                        Text("Entrar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
//                    .disabled(email.isEmpty || password.isEmpty)
                }

                Spacer()
            }
            .padding()
            .alert(isPresented: $authViewModel.showError) {
                Alert(title: Text("Erro"),
                      message: Text(authViewModel.errorMessage ?? ""),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
