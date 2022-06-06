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

@MainActor
class ArticleNewsViewModel: ObservableObject {
    
    // ketika kita reference property SwiftUIView dan kita kita update value dari @Published property SwiftUI akan bereaksi untuk merubah dan update dengan value yang baru
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var selectedCategory: Category
    
    private let newsAPI = NewsAPI.shared
    
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        
        self.selectedCategory = selectedCategory
    }
    
    func loadArticles() async {
        phase = .empty
        do {
            let articles = try await newsAPI.fetch(from: selectedCategory)
            phase = .success(articles)
        } catch {
            phase = .failure(error)
        }
    }
    
}
