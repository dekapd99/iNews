//
//  NewsAPI.swift
//  iNews
//
//  Created by Deka Primatio on 06/06/22.
//

import Foundation

// Berisikan inisialisasi API, Api Key, URL Session, decode JSON file, fetch (kategori, search), fungsi fetch response status code, error domain, Generate hasil (search dan kategori) dalam bentuk URL
struct NewsAPI {
    
    static let shared = NewsAPI()
    private init() {} // inisialisasi API
    
    private let apiKey = "copy & paste your apikey here" // replace with your API Key
    private let session = URLSession.shared // get URL Session
    
    // Fungsi decode JSON File (standar iso8601 -> ini dari API-nya) menjadi native swift file
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    // Fetching Berita dari Kategori dan Generate hasil Artikel berdasarkan kategori tersebut
    func fetch(from category: Category) async throws -> [Article] {
        try await fetchArticles(from: generateNewsURL(from: category))
    }
    
    // Fungsi search dari String Input dan Generate hasil Artikel berdasarkan Input tersebut
    func search(for query: String) async throws -> [Article] {
        try await fetchArticles(from: generateSearchURL(from: query))
    }
    
    // Fungsi Fetching Data dan Response Code API Berita dari URL
    private func fetchArticles(from url: URL) async throws -> [Article] {
        // deklarasi data dan response di main thread
        let (data, response) = try await session.data(from: url)
        
        // Error handling response from API Provider (Directly)
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad Response")
        }
        
        // Decode Response Code API dengan jsonDecoder dan Generate Hasil Error berdasarkan Code response tersebut
        switch response.statusCode{
        case (200...299), (400...499):
            let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
            if apiResponse.status == "ok" {
                return apiResponse.articles ?? [] // return berita ke dalam array
            } else {
                throw generateError(description: apiResponse.message ?? "An Error Occured")
            }
            
        default:
            throw generateError(description: "A Server Error Occured")
        }
    }
    
    // Fungsi Generate Error Domain
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    // Fungsi Generate Hasil Search dari String Input ke dalam bentuk URL
    private func generateSearchURL(from query: String) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&q=\(percentEncodedString)"
        return URL(string: url)!
    }
    
    // Fungsi Generate Berita dari Hasil Pemilihan Kategori ke dalam bentuk URL
    private func generateNewsURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        return URL(string: url)!
    }
}
