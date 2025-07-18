//
//  RegisterRequestModel.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 18/07/25.
//

import Foundation

struct RegisterRequestModel: Codable {
    let name: String
    let email: String
    let password: String
}
