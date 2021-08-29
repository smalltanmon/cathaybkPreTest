//
//  Plant.swift
//  cathaybkPreTest
//
//  Created by Eric Chen on 2021/8/28.
//

import Foundation

struct PlantResponse: Codable {
    let response: Response
    
    struct Response: Codable {
        let limit: Int
        let offset: Int
        let count: Int
        let plants: [Plant]
        
        enum CodingKeys: String, CodingKey{
            case limit = "limit"
            case offset = "offset"
            case count = "count"
            case plants = "results"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case response = "result"
    }
}

struct Plant: Codable {
    let name: String
    let location: String
    let description: String
    let imageURLString: String
    
    enum CodingKeys: String, CodingKey {
        case name = "F_Name_Ch"
        case location = "F_Location"
        case description = "F_Feature"
        case imageURLString = "F_Pic01_URL"
    }
}
