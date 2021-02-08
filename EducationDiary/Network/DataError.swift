//
//  DataError.swift
//  EducationDiary
//
//  Created by Eugene St on 02.02.2021.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidData
    case decodingError
    case serverError
    case invalidURL
    case noNetwork
}

