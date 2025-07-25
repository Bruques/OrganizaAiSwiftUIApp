//
//  ContentView.swift
//  OrganizaAi
//
//  Created by Bruno Nascimento Marques on 17/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button {
                Task {
                    do {
                        let response = try await AuthService
                            .shared
                            .login(body: LoginRequestModel(email: "brunonmarques98@gmail.com",
                                                           password: "12345678"))
                    } catch {
                        print("Deu erro no login")
                    }
                    
                }
            } label: {
                Text("Fazer login")
            }

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
