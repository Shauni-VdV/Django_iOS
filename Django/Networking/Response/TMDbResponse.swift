//
//  TMDbResponse.swift
//  Django
//
//  Created by Shauni Van de Velde on 27/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//

import Foundation

struct TMDBResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension TMDBResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
