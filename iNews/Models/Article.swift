//
//  Article.swift
//  iNews
//
//  Created by Deka Primatio on 01/06/22.
//

import Foundation

// Formatter Tanggal
fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

// Berisikan Endpoint Data API Article ("articles") yang akan digunakan pada aplikasi dari news.json dan Online API
// Endpoint Data API (Mandatory): Sumber, Judul, URL Berita, dan Tanggal Publish !
// Endpoint Data API (Optional) : Author, Deskripsi, dan URL Thumbnail Berita ?
struct Article {
    
    let source: Source
    
    // mandatory data
    let title: String
    let url: String
    let publishedAt: Date
    
    // optional data
    let author: String?
    let description: String?
    let urlToImage: String?
    
    // computed property author & deskripsi (optional)
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    // computed property sumber berita dan berapa lama sudah dipublish
    var captionText: String {
        "\(source.name) ・ \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date())) "
    }
    
    var articleURL: URL {
        URL(string: url)!
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)

    }
}

// Encode & Decode data dari API dan untuk simpan ke Bookmark
extension Article: Codable{}
extension Article: Equatable{}
extension Article: Identifiable{
    var id: String { url } // unique id provider ketika berita di tampilkan di aplikasi
}

// Protokol comformance untuk artikel dengan JSONDecoder
extension Article {
    // Menampung static computed property preview data berisikan array dari Article
    static var previewData: [Article]{
        // Preview data dari URL Berita dengan bentuk ekstensi JSON
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL) // tampilkan data dari previewDataURL
        
        let jsonDecoder = JSONDecoder()
        
        // publishedAt itu merupakan standar penulisan tanggal kode: iso8601
        jsonDecoder.dateDecodingStrategy = .iso8601 // konversi iso8601 ke Swift Native Date Type
        
        // API Response untuk hasil decode data json
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles ?? [] // store apiResponse artikel ke array
    }
}

struct Source {
    let name: String
}

extension Source: Codable{}
extension Source: Equatable{}
