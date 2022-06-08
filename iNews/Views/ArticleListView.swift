//
//  ArticleListView.swift
//  iNews
//
//  Created by Deka Primatio on 06/06/22.
//

import SwiftUI

// frontend: tampilan list artikel
struct ArticleListView: View {
    
    // delcare content untuk menghubungkan
    let articles: [Article]
    @State private var selectedArticle: Article?
    
    // untuk menampilkan setiap berita yang ada di API
    var body: some View {
        List {
            ForEach(articles) { article in
                ArticleRowView(article: article)
                    .onTapGesture {
                        selectedArticle = article
                    }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        // menampilkan tab view baru browser Safari
        .sheet(item: $selectedArticle) {
            SafariView(url: $0.articleURL)
                // supaya floating bottom menu menempel ke bagian paling bawah layar iphone
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    
    // sharing fitur bookmark diseluruh project folder dengan @StateObject secara Environment Object
    // kalo gak dimasukkin kesini dalam bentuk static bakalan aplikasi crash
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        NavigationView {
            ArticleListView(articles: Article.previewData)
                // inject environmentObject
                .environmentObject(articleBookmarkVM)
        }
    }
}
