//
//  ArticleNewsViewModel.swift
//  iNews
//
//  Created by Deka Primatio on 06/06/22.
//

// VM Load Berita
import SwiftUI

// 3 kasus fetch data
enum DataFetchPhase<T> {
    case empty // default: awal membuka aplikasi
    case success(T) // memunculkan berita
    case failure(Error) // error
}

// Token untuk mendeteksi perubahan berita berdasarkan interval waktu
struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

// Ketika aplikasi dibuka, VM ini akan mulai fetch data dengan Token pada main thread
// Data tersebut akan terus diupdate berdasarkan rentang waktu
// Sehingga user akan selalu mendapatkan berita terbaru
@MainActor // Antrian fetch data utama (Main thread)
class ArticleNewsViewModel: ObservableObject {
    
    @Published var phase = DataFetchPhase<[Article]>.empty // default phase
    @Published var fetchTaskToken: FetchTaskToken // built-in fetch task token
    
    private let newsAPI = NewsAPI.shared
    
    // inisialisasi fetch data berita (terbaru) terjadi ketika awal load aplikasi di beranda
    // .general = kategori berita default
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        
        // menampilkan berita terikini berdasarkan kategori dan waktu
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    // fungsi load artikel
    func loadArticles() async {
        // Free Plan newsapi.org -> Handling Quota berlebih -> Komen coding dibawahnya supaya gak hit API jadi langsung get data dari local stored API (news.json)
        // Kalo mau langsung hit API comment line code dibawah ini dan uncomment line code dibawahnya
//        phase = .success(Article.previewData)
        
        // Handling bug: Cancelled Error ketika awal menjalankan aplikasi
        if Task.isCancelled { return } // cek task cancelled error

        phase = .empty
//        phase = .success([]) // Test case .success (No Articles) -> kalo mau nyoba Komen do & catch dibawah
        do {
            let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
            if Task.isCancelled { return } // cek task cancelled error
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return } // cek task cancelled error
            print(error.localizedDescription) // print error
            phase = .failure(error)
        }
    }
}
