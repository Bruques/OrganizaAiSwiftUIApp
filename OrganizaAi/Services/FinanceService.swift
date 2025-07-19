//
//  FinanceService.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 18/07/25.
//

import Foundation
import Alamofire

class FinanceService {
    private let network: NetworkManager
    private let baseURL = "http://localhost:8080/api/v1"
    
    init(network: NetworkManager = NetworkManager()) {
        self.network = network
    }
    
    func fetchDashboard(month: Int, year: Int) async throws -> DashboardModel {
        let dashboardUrl = "\(baseURL)/dashboard"
        let params: Parameters = [
            "mes": month,
            "ano": year
        ]
        
        return try await network.request(method: .get,
                                         url: dashboardUrl,
                                         params: params,
                                         of: DashboardModel.self)
    }
}
