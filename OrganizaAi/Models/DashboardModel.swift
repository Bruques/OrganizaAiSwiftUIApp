//
//  DashboardModel.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 18/07/25.
//

import Foundation

struct DashboardModel: Codable {
    let totalIncome: Double
    let totalExpenses: Double
    let balance: Double
    let estimatedTax: Double
    let incomingByCategory: [String : Double]
    let expensesByCategory: [String : Double]
}
