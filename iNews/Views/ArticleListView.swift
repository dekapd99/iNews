//
//  ArticleListView.swift
//  iNews
//
//  Created by Deka Primatio on 06/06/22.
//

import SwiftUI

// Berisikan Tampilan Berita dalam Bentuk List
struct ArticleListView: View {
    
    let articles: [Article]

    // Artikel yang dipilih untuk membuka fitur SafariView
    @State private var selectedArticle: Article?
    
    var body: some View {
        // Menampilkan setiap berita dalam bentuk list
        List {
            // Fungsi ForEach pemanggilan setiap berita dari API
            ForEach(articles) { article in
                ArticleRowView(article: article)
                    .onTapGesture {
                        selectedArticle = article
                    }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden) // Tidak ada pemisah antar tiap berita
        }
        .listStyle(.plain)
        // Menampilkan tab view baru browser Safari
        .sheet(item: $selectedArticle) {
            SafariView(url: $0.articleURL)
                // Supaya floating bottom menu menempel ke bagian paling bawah layar iphone
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    
    // Mengaktifkan fitur bookmark yang sudah di supply di root project di buat dalam static agar aplikasi tidak crash
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        NavigationView {
            ArticleListView(articles: Article.previewData)
                // Property wrapper observable object fitur bookmark dari root folder diatas
                .environmentObject(articleBookmarkVM)
        }
    }
}
