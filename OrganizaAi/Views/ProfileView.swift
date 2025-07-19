//
//  ProfileView.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 18/07/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(role: .destructive) {
                        authViewModel.logout()
                    } label: {
                        Label("Sair da conta", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Configurações")
        }
    }
}

#Preview {
    ProfileView()
}
