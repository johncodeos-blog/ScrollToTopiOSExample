// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let car = try? newJSONDecoder().decode(Car.self, from: jsonData)

import Foundation

// MARK: - CarElement
class CarElement: Codable {
    let carMake: String?
    let carModel: String?
    let carModelYear: Int?
    
    enum CodingKeys: String, CodingKey {
        case carMake = "car_make"
        case carModel = "car_model"
        case carModelYear = "car_model_year"
    }
    
    init(carMake: String?, carModel: String?, carModelYear: Int?) {
        self.carMake = carMake
        self.carModel = carModel
        self.carModelYear = carModelYear
    }
}

typealias Car = [CarElement]
