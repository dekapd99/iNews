//
//  NewsTabView.swift
//  iNews
//
//  Created by Deka Primatio on 07/06/22.
//

import SwiftUI

// Frontend: untuk bottom menu tab view
struct NewsTabView: View {
    
    // 
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView) // overlay tampilan ketika fetching data
            
                // mereload kategori berita berdasarkan menu kategori yang dipilih
                // cancel task yang lama ketika value task kategori yang baru muncul
                .task(id: articleNewsVM.fetchTaskToken, loadTask)
            
                // refresh mekanism ketika tarik layar keatas
                .refreshable(action: refreshTask)
    
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text) // title
                .navigationBarItems(trailing: menu) // menu pojok kanan atas
        }
    }
    
    // cases handler fetching data
    @ViewBuilder
    private var overlayView: some View {
        switch articleNewsVM.phase {
        
            // case empty = loading progress
            case .empty:
                ProgressView()
                
            // case success = memunculkan Artikel didalam placeholder (EmptyPlaceholderView)
            case .success(let articles) where articles.isEmpty:
                EmptyPlaceholderView(text: "No Articles", image: nil)
                
            // case failure = memunculkan error (RetryView)
            case .failure(let error):
                RetryView(text: error.localizedDescription, retryAction: refreshTask)
                
            // default case
            default: EmptyView()
        }
    }
    
    // computed property Articles untuk mengakses Enum DataFetchPhase untuk Case Success pada ArticleNewsViewModel()
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase{
            return articles
        } else {
            return []
        }
    }
    
    // load mekanism
    @Sendable
    private func loadTask() async {
        await articleNewsVM.loadArticles()
    }
    
    // refresh mekanism ketika refresh dan klik retry button, refresh test token dan assign new timestamp
    @Sendable
    private func refreshTask() {
        articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
    }
    
    // menampilkan kategori berita yang dipilih
    private var menu: some View {
        Menu {
            // Menu kategori dengan picker untuk menampilkan seluruh berita berdasarkan kategori yang dipilih
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                ForEach(Category.allCases) {
                    // render textnya
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
                .imageScale(.large)
        }
    }
}

struct NewsTabView_Previews: PreviewProvider {
    
    // sharing fitur bookmark diseluruh project folder dengan @StateObject secara Environment Object
    // kalo gak dimasukkin kesini dalam bentuk static bakalan aplikasi crash
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel()
    
    static var previews: some View {
        NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
            // inject environmentObject
            .environmentObject(articleBookmarkVM)
    }
}
