//
//  Article.swift
//  iNews
//
//  Created by Deka Primatio on 01/06/22.
//

import Foundation

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

// Data Article ("articles") dari news.json
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
    
    // komputasi property handler
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    // computed property sumber news dan jam berita di publish
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

// encode & decode data dari API dan untuk simpan ke Bookmark
extension Article: Codable{}
extension Article: Equatable{}
extension Article: Identifiable{
    var id: String { url }
}

// protokol comformance untuk artikel


extension Article {
    // untuk menampung static computed property preview data berisikan array dari Article
    static var previewData: [Article]{
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        // declare jsonDecoder
        let jsonDecoder = JSONDecoder()
        
        // lihat publishedAt itu merupakan standar penulisan tanggal kode: iso8601
        jsonDecoder.dateDecodingStrategy = .iso8601 // konversi iso8601 ke Swift Native Date Type
        
        // API Response
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
}

struct Source {
    let name: String
}
extension Source: Codable{}
extension Source: Equatable{}
