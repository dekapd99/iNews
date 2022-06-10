//
//  NewsAPIResponse.swift
//  iNews
//
//  Created by Deka Primatio on 01/06/22.
//

// Handling API Response Code
import Foundation

// Berisikan variable Response
struct NewsAPIResponse: Decodable {
    
    let status: String
    let totalResults: Int? // optional karena bisa return error
    let articles: [Article]? // optional karena bisa tidak menampilkan apa apa kalo codingnya salah
    
    // Error handling untuk Code API Response News
    // optional karena bakal muncul ketika error saja
    let code: String?
    let message: String?
    
}
