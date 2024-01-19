//
//  CancelAppointmentView.swift
//  Vollmed
//
//  Created by Pedro Henrique on 16/01/24.
//

import SwiftUI

struct CancelAppointmentView: View {
    var appointmentID: String
    private let service = WebService()
    
    @State private var showAlert = false
    @State private var isAppointmentCancelled = false
    @Environment(\.presentationMode) var presentationMode
    @State private var reasonToCancel = ""
    @State private var showTextValidationMessage = false
    
    func cancelAppointment() async {
        do {
            let isAppointmentCancelled = try await service.cancelAppointment(
                appointmentID: appointmentID, reasonToCancell: reasonToCancel
            )
            showAlert = true
            
            if isAppointmentCancelled  {
                self.isAppointmentCancelled = true
                return
            }
            self.isAppointmentCancelled = false
        } catch {
            showAlert = true
            self.isAppointmentCancelled = false
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Conte-nos o motivo do cancelamento da sua consulta")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .padding(.top)
                .multilineTextAlignment(.center)
            
            TextEditor(text: $reasonToCancel)
                .padding()
                .font(.title3)
                .foregroundStyle(.accent)
                .scrollContentBackground(.hidden)
                .background(.lightBlue)
                .cornerRadius(16)
                .frame(maxHeight: 300)
            
            if showTextValidationMessage {
                Text("Por favor informe o motivo do cancelamento.")
                    .foregroundStyle(.cancel)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if !reasonToCancel.isEmpty {
                    showTextValidationMessage = false
                    Task {
                        await cancelAppointment()
                    }
                }
                
                if reasonToCancel.isEmpty {
                    showTextValidationMessage = true
                }
            }, label: {
                ButtonView(text: "Cancelar consulta", buttonType: .cancel)
            })
        }
        .padding()
        .navigationTitle("Cancelar consulta")
        .alert(
            isAppointmentCancelled ? "Sucesso" : "Ops, algo deu errado",
            isPresented: $showAlert,
            presenting: isAppointmentCancelled,
            actions: { _ in
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: { Text("Ok") }
                )
            },
            message: { isCancelled in
                if isCancelled {
                    Text("A consulta foi cancelada com sucesso!")
                }
                
                if !isCancelled {
                    Text(
                        "Houve um erro ao cancelar sua consulta. Por favor tente novamente ou entre em contato via telefone"
                    )
                }
            }
        )
    }
}

#Preview {
    CancelAppointmentView(appointmentID: "123")
}
