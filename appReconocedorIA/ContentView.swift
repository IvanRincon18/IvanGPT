//
//  ContentView.swift
//  appReconocedorIA
//
//  Created by Ivan Jhair Gomez Rincon on 12/06/24.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    @State var userPrompt = ""
    @State var response: LocalizedStringKey = "¿Cómo te puedo ayudar hoy?"
    @State var isLoading = false
    
    var body: some View {
        VStack {
            Text("Bienvenido a IvanGPT")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.blue)
                .padding(.top, 40)
            
            ZStack {
                ScrollView {
                    Text(response)
                        .font(.title)
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
                        .scaleEffect(4)
                }
            }
            
            TextField("Di lo que quieras...", text: $userPrompt, axis: .vertical)
                .lineLimit(5)
                .font(.title)
                .padding()
                .background(Color.yellow.opacity(0.3), in: Capsule())
                .disableAutocorrection(true)
                .onSubmit {
                    generateResponse()
                }
        }
        .padding()
        .background(Color.clear) // Fondo transparente para detectar toques
        .contentShape(Rectangle()) // Permite que el fondo sea "clicable"
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func generateResponse() {
        isLoading = true
        response = ""
        
        Task {
            do {
                let result = try await model.generateContent(userPrompt)
                isLoading = false
                response = LocalizedStringKey(result.text ?? "No encontré respuesta")
            } catch {
                response = "Algo salió mal\n \(error.localizedDescription)"
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
