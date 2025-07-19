//
//  AppEntryView.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 17/07/25.
//

import SwiftUI

struct AppEntryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    AppEntryView()
        .environmentObject(AuthViewModel())
}
