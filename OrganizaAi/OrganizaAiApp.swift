//
//  OrganizaAiApp.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 17/07/25.
//

import SwiftUI

@main
struct OrganizaAiApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            AppEntryView()
                .environmentObject(authViewModel)
                .onAppear {
                    authViewModel.checkAuthentication()
                }
        }
    }
}
