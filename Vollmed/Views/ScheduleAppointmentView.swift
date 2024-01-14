//
//  ScheduleAppointmentView.swift
//  Vollmed
//
//  Created by Pedro Henrique on 12/01/24.
//

import SwiftUI

struct ScheduleAppointmentView: View {
    @State private var selectedDate = Date()
    private let dateRange = Date()...(Calendar.current.date(byAdding: .month, value: 1, to: .now))!
    private let service = WebService()
    var specialistID: String
    
    func scheduleAppointment() async {
        do {
            if let appointment = try await service.scheduleAppointment(
                specialistID: specialistID,
                patientID: patientId,
                date: selectedDate.convertToString()
            ) {
                print(appointment)
            }
        } catch {
            print("Ocorreu um erro ao agendar a consulta: \(error)")
        }
    }
    
    var body: some View {
        VStack {
            Text("Selecione a data e o horário da consulta")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            DatePicker("Escolha a data da consulta", selection: $selectedDate, in: dateRange)
                .datePickerStyle(.graphical)
                .onAppear(perform: {
                    UIDatePicker.appearance().minuteInterval = 15
                })
            
            
            Button(action: {
                Task {
                    await scheduleAppointment()
                }
            }, label: {
                ButtonView(text: "Agendar consulta")
            })
            
        }
        .padding()
        .navigationTitle("Agendar consulta")
    }
}

#Preview {
    ScheduleAppointmentView(specialistID: "")
}
