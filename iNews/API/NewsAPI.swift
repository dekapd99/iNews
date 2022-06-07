//
//  NewsAPI.swift
//  iNews
//
//  Created by Deka Primatio on 06/06/22.
//

import Foundation

struct NewsAPI {
    
    static let shared = NewsAPI()
    private init() {}
    
    // HARUS UDAH SIGN UP DAN COPY API KEY-NYA KESINI
    private let apiKey = "c3e18c0d11d34ffc9a4406ce16850aa2" // API Key bisa diganti dengan API Key sendiri
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    // async fetch kategori ke main thread
    func fetch(from category: Category) async throws -> [Article] {
        let url = generateNewsURL(from: category)
        
        // fetch data dengan url secara async
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad Response")
        }
        
        // kita akan decode dengan json decoder
        switch response.statusCode{
            
        case (200...299), (400...499):
            let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
            if apiResponse.status == "ok" {
                return apiResponse.articles ?? []
            } else {
                throw generateError(description: apiResponse.message ?? "An Error Occured")
            }
            
        default:
            throw generateError(description: "A Server Error Occured")
        }
    }
    
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    // generate URL untuk kategori
    private func generateNewsURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        return URL(string: url)!
    }
}
