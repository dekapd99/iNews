//
//  ArticleBookmarkViewModel.swift
//  iNews
//
//  Created by Deka Primatio on 08/06/22.
//

import SwiftUI

@MainActor
class ArticleBookmarkViewModel: ObservableObject {
    
    @Published private(set) var bookmarks: [Article] = []
    private let bookmarkStore = PlistDataStore<[Article]>(filename: "bookmarks")
    
    static let shared = ArticleBookmarkViewModel()
    private init() {
        async {
            await load()
        }
    }
    
    private func load() async {
        bookmarks = await bookmarkStore.load() ?? []
    }
    
    // fungsi bookmark status dari artikel untuk keperluan add (bookmark) artikel dan remove dari bookmark
    // fungsi status bookmark dalam boolean
    func isBookmarked(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id } != nil // kasih id ketika terdaftar di bookmark
    }
    
    // fungsi add to bookmark
    func addBookmark(for article: Article) {
        // cek apakah artikel sudah di bookmark
        // kalo tidak ada status bookmark ya Continue ke code selanjutnya
        guard !isBookmarked(for: article) else {
            return
        }
        
        // insert ke index 0
        bookmarks.insert(article, at: 0)
        bookmarkUpdated()
    }
    
    // fungsi remove bookmark
    func removeBookmark(for article: Article) {
        // cari index bookmark yang ada
        guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else {
            return // return kalo gak ada artikel didalam bookmark
        }
        
        // remove bookmark
        bookmarks.remove(at: index)
        bookmarkUpdated()
    }
    
    private func bookmarkUpdated() {
        let bookmarks = self.bookmarks
        async {
            await bookmarkStore.save(bookmarks)
        }
    }
}
