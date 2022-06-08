//
//  ArticleNewsViewModel.swift
//  iNews
//
//  Created by Deka Primatio on 06/06/22.
//

import SwiftUI

enum DataFetchPhase<T> {
    case empty
    case success(T)
    case failure(Error)
}

// Data struktur Fetching Token untuk mendeteksi perubahan berita berdasarkan interval waktu
struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

@MainActor // new paradigm
class ArticleNewsViewModel: ObservableObject {
    
    // ketika kita reference property SwiftUIView dan kita kita update value dari @Published property SwiftUI akan bereaksi untuk merubah dan update dengan value yang baru
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var fetchTaskToken: FetchTaskToken
    
    private let newsAPI = NewsAPI.shared
    
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    func loadArticles() async {
        // Free Plan newsapi.org -> Handling Quota berlebih -> Komen coding dibawahnya supaya gak hit API jadi langsung get data dari local stored API (news.json)
        // Kalo mau langsung hit API comment line code dibawah ini dan uncomment line code dibawahnya
//        phase = .success(Article.previewData)
        
        // Handling bug: Cancelled Error ketika awal menjalankan aplikasi
        if Task.isCancelled { return }

        phase = .empty
//        phase = .success([]) // Test case .success (No Articles) -> kalo mau nyoba Komen do & catch dibawah
        do {
            let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
            if Task.isCancelled { return } // cek task cancelled error
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return } // cek task cancelled error
            // print error
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
    
}
