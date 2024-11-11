//
//  ContentView.swift
//  NetworkingDemo
//
//  Created by Sahas Punchihewa on 2024-10-18.
//

import SwiftUI

import Foundation

struct UserResponse: Codable, Hashable {
    let users: [User]
}

struct User: Codable, Hashable {
    let id: Int
    let firstName, lastName, maidenName: String
    let age: Int
    let gender, email, phone, username: String
    let password, birthDate: String
    let image: String
    let bloodGroup: String
    let height, weight: Double
    let eyeColor: String
    let hair: Hair
    let ip: String
    let address: Address
    let macAddress, university: String
    let bank: Bank
    let company: Company
    let ein, ssn, userAgent: String
    let crypto: Crypto
    let role: String
}

struct Address: Codable, Hashable {
    let address, city, state, stateCode: String
    let postalCode: String
    let coordinates: Coordinates
    let country: String
}

struct Coordinates: Codable, Hashable {
    let lat, lng: Double
}

struct Bank: Codable, Hashable {
    let cardExpire, cardNumber, cardType, currency: String
    let iban: String
}

struct Company: Codable, Hashable {
    let department, name, title: String
    let address: Address
}

struct Crypto: Codable, Hashable {
    let coin, wallet, network: String
}

struct Hair: Codable, Hashable {
    let color, type: String
}

class PostViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading: Bool = false
    
    func fetchPost() async {
        isLoading = true
        let url = URL(string: "https://dummyjson.com/users")
        
        guard let unwrappedURL = url else {
            print("Invalid URL")
            return
        }
        
        do {
            let (fetchData, response) = try await URLSession.shared.data(from: unwrappedURL)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid Response")
                return
            }
            
            switch httpResponse.statusCode {
            case 200...300:
                print(fetchData)
                let decodedData = try JSONDecoder().decode(UserResponse.self, from: fetchData)
                
                print(decodedData)
                
                users = decodedData.users
                
                isLoading = false
                
            case 400...500:
                print("Server is not responding")
            default:
                print("Something went wrong")
            }
        } catch {
            print("Something went wrong: \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = PostViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(2.0)
            } else {
                List(viewModel.users, id: \.id) { user in
                    VStack(alignment: .leading) {
                        Text("\(user.firstName) \(user.lastName)")
                            .padding(.bottom)
                            .padding(.top)
                        Text("Age: \(user.age)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Gender: \(user.gender)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Email: \(user.email)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Phone: \(user.phone)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Role: \(user.role)")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchPost()
            }
        }
    }
}

#Preview {
    ContentView()
}
