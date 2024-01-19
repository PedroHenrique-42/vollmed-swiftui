//
//  ScheduleAppointmentView.swift
//  Vollmed
//
//  Created by Pedro Henrique on 12/01/24.
//

import SwiftUI

struct ScheduleAppointmentView: View {
    @State private var selectedDate = Date()
    @State private var showAlert = false
    @State private var isAppointmentScheduled = false
    @Environment(\.presentationMode) var presentationMode
    
    private let dateRange = Date()...(Calendar.current.date(byAdding: .month, value: 1, to: .now))!
    private let service = WebService()
    var specialistID: String
    var appointmentID: String?
    var isRescheduleView: Bool
    
    init(specialistID: String, appointmentID: String? = nil, isRescheduleView: Bool = false) {
        self.specialistID = specialistID
        self.isRescheduleView = isRescheduleView
        self.appointmentID = appointmentID
    }
    
    func rescheduleAppointment() async {
        guard let appointmentID else { return }
        do {
            let appointment = try await service.rescheduleAppointment(
                appointmentID: appointmentID,
                date: selectedDate.convertToString()
            )
            if appointment != nil {
                isAppointmentScheduled = true
            }
            if appointment == nil {
                isAppointmentScheduled = false
            }
        } catch {
            print("Ocorreu um erro ao remarcar consulta")
            isAppointmentScheduled = false
        }
        showAlert = true
    }
    
    func scheduleAppointment() async {
        do {
            if let _ = try await service.scheduleAppointment(
                specialistID: specialistID,
                patientID: patientId,
                date: selectedDate.convertToString()
            ) {
                isAppointmentScheduled = true
            } else {
                isAppointmentScheduled = false
            }
        } catch {
            isAppointmentScheduled = false
            print("Ocorreu um erro ao agendar a consulta: \(error)")
        }
        showAlert = true
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
                    isRescheduleView ? await rescheduleAppointment() : await scheduleAppointment()
                }
            }, label: {
                ButtonView(text: isRescheduleView ? "Reagendar Consulta" : "Agendar consulta")
            })
            
        }
        .padding()
        .navigationTitle(isRescheduleView ? "Reagendar Consulta" : "Agendar consulta")
        .alert(
            isAppointmentScheduled ? "Sucesso" : "Ops, algo deu errado",
            isPresented: $showAlert,
            presenting: isAppointmentScheduled,
            actions: { _ in
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: { Text("Ok") }
                )
            },
            message: { isScheduled in
                if isScheduled {
                    Text("A consulta foi \(isRescheduleView ? "reagendada" : "agendada") com sucesso")
                }
                
                if !isScheduled {
                    Text(
                        "Houve um erro ao \(isRescheduleView ? "reagendar" : "agendar") sua consulta. Por favor tente novamente ou entre em contato via telefone"
                    )
                }
            }
        )
    }
}

#Preview {
    ScheduleAppointmentView(specialistID: "")
}
