import UIKit

let patientId = "ef43d846-5721-48e0-a86d-ac6924a3575d"

struct WebService {
    
    private let baseURL = "http://localhost:3000"
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(from imageURL: String) async throws -> UIImage? {
        guard let url = URL(string: imageURL) else {
            print("Erro na URL")
            return nil
        }
        
        if let cachedImage = imageCache.object(forKey: imageURL as NSString) {
            return cachedImage
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else { return nil }
        imageCache.setObject(image, forKey: imageURL as NSString)
        
        return image
    }
    
    func getAllSpecialists() async throws -> [Specialist]? {
        let endpoint = baseURL + "/especialista"
        guard let url = URL(string: endpoint) else {
            print("Erro na URL")
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let specialists = try JSONDecoder().decode([Specialist].self, from: data)
        return specialists
    }
    
    func scheduleAppointment(
        specialistID: String,
        patientID: String,
        date: String
    ) async throws -> ScheduleAppointmentResponse? {
        let endpoint = baseURL + "/consulta"
        guard let url = URL(string: endpoint) else { return nil}
        
        let appointment = ScheduleAppointmentRequest(specialist: specialistID, patient: patientID, date: date)
        let jsonData = try JSONEncoder().encode(appointment)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
        return appointmentResponse
    }
}
