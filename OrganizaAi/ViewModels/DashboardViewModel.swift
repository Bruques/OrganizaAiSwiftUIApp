//
//  DashboardViewModel.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 18/07/25.
//

import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var dashboard: DashboardModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedMonth: Int
    @Published var selectedYear: Int

    private let financeService: FinanceService

    init(financeService: FinanceService = FinanceService()) {
        self.financeService = financeService
        let currentDate = Date()
        let calendar = Calendar.current
        self.selectedMonth = calendar.component(.month, from: currentDate)
        self.selectedYear = calendar.component(.year, from: currentDate)
        
        Task {
            await loadDashboard()
        }
    }

    func loadDashboard() async {
        isLoading = true
        errorMessage = nil

        do {
            let data = try await financeService.fetchDashboard(month: selectedMonth,
                                                               year: selectedYear)
            self.dashboard = data
        } catch {
            self.errorMessage = "Erro ao carregar o resumo: \(error.localizedDescription)"
        }

        isLoading = false
    }
    
    func updateDate(month: Int, year: Int) async {
        selectedMonth = month
        selectedYear = year
        await loadDashboard()
    }
}
