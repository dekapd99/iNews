//
//  SearchTabView.swift
//  iNews
//
//  Created by Deka Primatio on 08/06/22.
//

import SwiftUI

// Tampilan Halaman Search
struct SearchTabView: View {
    
    // Mengaktifkan fitur Search dengan @EnvironmentObject terhadap ViewModel Search
    @StateObject var searchVM = ArticleSearchViewModel.shared
    
    //  Frontend: Tampilan Fitur Halaman Search
    var body: some View {
        // Untuk Overlay Default Halaman Search ketika klik Kolom Search
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        // Penggunaan method search dari daftar SuggestionView
        .searchable(text: $searchVM.searchQuery) { suggestionsView }
        // Jika String Input kolom search kosong, maka tidak akan menampilkan apa-apa (tetap dalam kondisi search sampai tekan cancel)
        .onChange(of: searchVM.searchQuery) { newValue in
            if newValue.isEmpty {
                searchVM.phase = .empty
            }
        }
        .onSubmit(of: .search, search) // Search berita berdasarkan String Input
    }
    
    // Jika search berhasil maka tampilkan hasil pencarian berita berdasarkan String Input
    // Jika tidak, maka tidak perlu menampilkan apa-apa
    private var articles: [Article] {
        if case .success(let articles) = searchVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    // Fungsi OverlayView untuk handling kasus halaman Search
    @ViewBuilder
    private var overlayView: some View {
        switch searchVM.phase {
        // Kasus Empty Sistem: jika sedang mencari tampilkan ProgressView (default loading awal-awal)
        // Jika sudah pernah mencari (dan sudah memasukkan String Input) tampilkan history, tambahkan ke dalam history dan lakukan search
        case .empty:
            if !searchVM.searchQuery.isEmpty {
                ProgressView()
            } else if !searchVM.history.isEmpty {
                SearchHistoryListView(searchVM: searchVM) { newValue in
                    searchVM.searchQuery = newValue
                    search() // Lakukan search
                }
            } else {
                EmptyPlaceholderView(text: "Search News", image: Image(systemName: "magnifyingglass"))
            }
        // Kasus Sukses Sistem: tampilkan hasil tidak ada artikel dan
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No search results found", image: Image(systemName: "magnifyingglass"))
        // Kasus Gagal Sistem: tampilkan deskripsi error dan tombol retry
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: search)
            
        default: EmptyView()
            
        }
    }
    
    // fungsi SuggestionView
    @ViewBuilder
    private var suggestionsView: some View {
        // Manual: List Suggestion define as Button dan tampilkan dalam bentuk Text String
        ForEach(["Swift", "Covid-19", "BTC", "PS5", "iOS 15"], id: \.self) { text in
            Button {
                searchVM.searchQuery = text
            } label: {
                Text(text)
            }
        }
    }
    
    // fungsi search
    private func search() {
        // searchQuery mengambil String Input yang telah di trim segala jenis Whitespace di Awal & Akhir akan dihilangkan, kecuali Whitespace antar kata
        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        // Jika searchQuery kosong maka tambahkan ke history
        if !searchQuery.isEmpty {
            searchVM.addHistory(searchQuery)
        }
        // Jalankan Pencarian Berita di Main Thread
        Task {
            await searchVM.searchArticle()
        }
    }
}

struct SearchTabView_Previews: PreviewProvider {
    
    // Mengaktifkan fitur bookmark yang sudah di supply di root project di buat dalam static agar aplikasi tidak crash
    @StateObject static var bookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        SearchTabView()
            // Property wrapper observable object fitur bookmark dari root folder diatas
            .environmentObject(bookmarkVM)
    }
}
