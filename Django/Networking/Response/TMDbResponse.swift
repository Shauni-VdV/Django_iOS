//
//  TMDbResponse.swift
//  Django
//
//  Created by Shauni Van de Velde on 27/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//

import Foundation
// The response used when adding a movie to favorites
struct TMDbResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension TMDbResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
