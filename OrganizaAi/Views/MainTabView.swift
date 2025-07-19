//
//  MainTabView.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 17/07/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            DashboardView(viewModel: DashboardViewModel())
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            ExpensesView()
                .tabItem {
                    Label("Despesas", systemImage: "minus.circle.fill")
                }
            
            IncomesView()
                .tabItem {
                    Label("Ganhos", systemImage: "plus.circle.fill")
                }
            
            ProfileView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Config", systemImage: "gear")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
