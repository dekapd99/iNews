//
//  BookmarkTabView.swift
//  iNews
//
//  Created by Deka Primatio on 08/06/22.
//

import SwiftUI

// Tampilan Halaman Bookmark berisikan NavigationView dan Search Berita yang ada di Daftar Bookmark
struct BookmarkTabView: View {
    
    // Mengaktifkan fitur bookmark dengan @EnvironmentObject
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    // Fitur Search di Bookmark
    @State var searchText: String = ""
    
    // Frontend: Tampilan default halaman bookmark
    var body: some View {
        let articles = self.articles
        
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView(isEmpty: articles.isEmpty))
                .navigationTitle("Saved Articles")
        }
        .searchable(text: $searchText)
    }
    
    // Fungsi search di halaman bookmark
    // Jika tidak ada yang di search maka tampilkan Bookmark yang tersimpan
    // Jika ada yang di search maka tampilkan hasil searchnya dengan membandingkan String input dengan Judul dan Deskripsi berita yang tersimpan di bookmark
    private var articles: [Article] {
        if searchText.isEmpty {
            return articleBookmarkVM.bookmarks
        }
        return articleBookmarkVM.bookmarks
            .filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.descriptionText.lowercased().contains(searchText.lowercased())
            }
    }
    
    // Fungsi penampilan halaman ketika bookmark kosong / ada isinya
    @ViewBuilder
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            EmptyPlaceholderView(text: "No Saved Articles", image: Image(systemName: "bookmark"))
        }
    }
}

struct BookmarkTabView_Previews: PreviewProvider {
    // Mengaktifkan fitur bookmark yang sudah di supply di root project di buat dalam static agar aplikasi tidak crash
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        BookmarkTabView()
            // Property wrapper observable object fitur bookmark dari root folder diatas
            .environmentObject(articleBookmarkVM)
    }
}
