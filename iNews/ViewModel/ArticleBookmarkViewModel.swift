//
//  ArticleBookmarkViewModel.swift
//  iNews
//
//  Created by Deka Primatio on 08/06/22.
//

// VM Bookmarks
import SwiftUI

// Berisikan fungsi inisial default bookmark empty array, load artikel di halaman bookmark, cek status bookmark, update halaman bookmark, add & remove artikel dari bookmark
@MainActor // Antrian fetch data utama (Main thread)
class ArticleBookmarkViewModel: ObservableObject {
    
    @Published private(set) var bookmarks: [Article] = [] // default bookmark = empty array
    private let bookmarkStore = PlistDataStore<[Article]>(filename: "bookmarks") // dimana bookmark disimpan
    
    static let shared = ArticleBookmarkViewModel() //
    
    // inisialisasi load isi bookmark
    private init() {
        Task {
            await load()
        }
    }
    
    // fungsi load apakah ada artikel yang dibookmark
    private func load() async {
        bookmarks = await bookmarkStore.load() ?? []
    }
    
    // fungsi cek status bookmark -> jika ada artikel yang di bookmark, maka akan artikel tersebut mendapatkan id (bookmark) dan bookmark sudah tidak lagi kosong
    func isBookmarked(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id } != nil // kasih id ketika terdaftar di bookmark
    }
    
    // fungsi add to bookmark
    func addBookmark(for article: Article) {
        // Apabila artikel sudah dibookmark, maka tidak boleh muncul lagi di halaman bookmark
        guard !isBookmarked(for: article) else {
            return
        }
        
        bookmarks.insert(article, at: 0) // bookmark artikel ditambahkan diposisi paling atas halaman bookmark (index: 0)
        bookmarkUpdated() // update isi bookmark baru yang sudah ditambahkan
    }
    
    // fungsi remove bookmark
    func removeBookmark(for article: Article) {
        // cari artikel berdasarkan id index yang tersimpan di bookmark
        guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else {
            return
        }
        
        bookmarks.remove(at: index) // remove bookmark berdasarkan posisi index artikelnya
        bookmarkUpdated() // update isi bookmark baru yang sudah dikurangi
    }
    
    // fungsi update halaman bookmark jika artikel sudah ditambahkan atau dikurangi terjadi di main thread
    private func bookmarkUpdated() {
        let bookmarks = self.bookmarks
        Task {
            await bookmarkStore.save(bookmarks)
        }
    }
}
