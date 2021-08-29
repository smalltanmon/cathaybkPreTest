//
//  PlantsRequest.swift
//  cathaybkPreTest
//
//  Created by Eric Chen on 2021/8/28.
//

import Foundation

struct PlantsRequest {
    var parameters: [String: String]
    private init(parameters: [String: String]) {
        self.parameters = parameters
    }
}

extension PlantsRequest{
    static func search(limit: String) -> PlantsRequest {
        PlantsRequest(parameters: ["scope": "resourceAquire", "limit": limit, "rid": "f18de02f-b6c9-47c0-8cda-50efad621c14"])
    }
}
