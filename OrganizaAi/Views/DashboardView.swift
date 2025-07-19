//
//  DashboardView.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 18/07/25.
//

//
//  DashboardView.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 18/07/25.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject private var viewModel: DashboardViewModel

    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                // Exemplo simples de seleção de mês e ano
                HStack {
                    Picker("Mês", selection: $viewModel.selectedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text("\(month)").tag(month)
                        }
                    }
                    Picker("Ano", selection: $viewModel.selectedYear) {
                        ForEach(2020...Calendar.current.component(.year, from: Date()), id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
                .onChange(of: viewModel.selectedMonth) { newMonth in
                    Task {
                        await viewModel.updateDate(month: newMonth, year: viewModel.selectedYear)
                    }
                }
                .onChange(of: viewModel.selectedYear) { newYear in
                    Task {
                        await viewModel.updateDate(month: viewModel.selectedMonth, year: newYear)
                    }
                }

                content
                    .padding()
            }
            .navigationTitle("Resumo")
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Carregando...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
        } else if let summary = viewModel.dashboard {
            ScrollView {
                VStack(spacing: 16) {
                    summarySection(summary)
                }
                .padding()
            }
        } else {
            Text("Nenhum dado disponível.")
                .foregroundColor(.secondary)
                .padding()
        }
    }

    private func summarySection(_ summary: DashboardModel) -> some View {
        VStack(spacing: 16) {
            valueCard(title: "Receita Total", value: summary.totalIncome, color: .green)
            valueCard(title: "Despesas Totais", value: summary.totalExpenses, color: .red)
            valueCard(title: "Saldo", value: summary.balance, color: .blue)
            valueCard(title: "Imposto Estimado", value: summary.estimatedTax, color: .orange)

            if !summary.incomingByCategory.isEmpty {
                categorySection(title: "Entradas por Categoria", data: summary.incomingByCategory, color: .green)
            }

            if !summary.expensesByCategory.isEmpty {
                categorySection(title: "Despesas por Categoria", data: summary.expensesByCategory, color: .red)
            }
        }
    }

    private func valueCard(title: String, value: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
            Text("R$ \(value, specifier: "%.2f")")
                .font(.title2)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private func categorySection(title: String, data: [String: Double], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)

            ForEach(data.sorted(by: { $0.key < $1.key }), id: \.key) { category, value in
                HStack {
                    Text(category)
                    Spacer()
                    Text("R$ \(value, specifier: "%.2f")")
                        .foregroundColor(color)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(12)
    }
}


// MARK: - Preview

#Preview {
    DashboardView(viewModel: DashboardViewModel(financeService: FinanceService(network: NetworkManager())))
}
