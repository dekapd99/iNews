//
//  NewsTabView.swift
//  iNews
//
//  Created by Deka Primatio on 07/06/22.
//

import SwiftUI

// Halaman Beranda berisikan NavigationView
struct NewsTabView: View {
    
    // Mengaktifkan fitur Generate Berita dengan @EnvironmentObject terhadap ViewModel News
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    // Frontend: Tampilan News Tab dalam bentuk NavigationView
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView) // Overlay Kasus Halaman Beranda
            
                // Reload berita berdasarkan kategori yang dipilih
                .task(id: articleNewsVM.fetchTaskToken, loadTask)
            
                // refresh mekanism ketika tarik layar keatas
                .refreshable(action: refreshTask)
    
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
                // Menu kategori (pojok kanan atas)
                .navigationBarItems(trailing: menu)
        }
    }
    
    // cases handler fetching data
    @ViewBuilder
    private var overlayView: some View {
        switch articleNewsVM.phase {
        
            // Kasus Empty Sistem = tampilkan ProgressView (default loading awal-awal)
            case .empty:
                ProgressView()
                
            // Kasus Sukses Sistem = Ketika tidak ada berita
            case .success(let articles) where articles.isEmpty:
                EmptyPlaceholderView(text: "No Articles", image: nil)
                
            // Kasus Failure Sistem = memunculkan error dan tombol Retry (RetryView) -> ketika ditekan bisa refresh halaman
            case .failure(let error):
                RetryView(text: error.localizedDescription, retryAction: refreshTask)
                
            default: EmptyView()
        }
    }
    
    // Jika search berhasil maka tampilkan fetch data berita dari API
    // Jika tidak, maka tidak perlu menampilkan apa-apa
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase{
            return articles
        } else {
            return []
        }
    }
    
    // Load mekanism di Main Thread, selalu menghasilkan value baru jika dijalankan
    @Sendable
    private func loadTask() async {
        await articleNewsVM.loadArticles()
    }
    
    // Refresh mekanism ketika refresh dan klik retry button
    @Sendable
    private func refreshTask() {
        // Refresh fetch token dan assign new timestamp
        DispatchQueue.main.async {
            articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
        }
    }
    
    // Fungsi Menu: Menampilkan daftar kategori yang ada dari VM News dan Model Category
    private var menu: some View {
        Menu {
            // Sebuah Picker kategori yang di fetch dari VM Search
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                // Render semua kategori dari Model Category
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "square.grid.2x2")
                .imageScale(.large) // Icon Category Berita
        }
    }
}

struct NewsTabView_Previews: PreviewProvider {
    
    // Mengaktifkan fitur bookmark yang sudah di supply di root project di buat dalam static agar aplikasi tidak crash
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        // Tampilkan Preview Berita dari VM News
        NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
            // Property wrapper observable object fitur bookmark dari root folder diatas
            .environmentObject(articleBookmarkVM)
    }
}
