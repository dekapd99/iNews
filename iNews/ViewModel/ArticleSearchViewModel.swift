//
//  ArticleSearchViewModel.swift
//  iNews
//
//  Created by Deka Primatio on 08/06/22.
//

// VM Search
import Foundation

// Berisikan fungsi insial default search value, (add, remove, load, update) search history, dan fungsi hasil pencarian artikel berdasarkan String input
@MainActor // Antrian fetch data utama (Main thread)
class ArticleSearchViewModel: ObservableObject {
    
    @Published var phase: DataFetchPhase<[Article]> = .empty // default empty phase
    @Published var searchQuery = "" // kolom search "kosong"
    @Published var history = [String]() // history hasil search dalam bentuk string
    private let historyDataStore = PlistDataStore<[String]>(filename: "histories") // dimana bookmark disimpan
    private let historyMaxLimit = 10 // limit history search max = 10
    
    private let newsAPI = NewsAPI.shared
    
    // Trim character pada kolom search sehingga yang valid adalah keywordnya saja
    private var trimmedSearchQuery: String {
        searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static let shared = ArticleSearchViewModel()

    // inisialisasi load hasil search
    private init() {
        load()
    }
    
    // fungsi add to history
    func addHistory(_ text: String) {
        
        // jika history pencarian sama dengan yang collection sebelumnya, maka hapus collection sebelumnya berdasarkan index-nya
        // jika history pencarian sudah lebih dari 10, maka otomatis hapus pencarian yang lawas
        if let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) {
            history.remove(at: index)
        } else if history.count == historyMaxLimit {
            history.remove(at: history.count - 1)
        }
        
        history.insert(text, at: 0) // history pencarian baru ditambahkan diposisi paling atas halaman search (index: 0)
        historiesUpdated() // update isi history pencarian baru yang sudah ditambahkan
    }
    
    // remove from search history
    func removeHistory(_ text: String) {
        // cek history pencarian yang sama dari collection pernah dilakukan setelah itu lanjut ke history.remove(...)
        guard let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) else {
            return
        }
        
        history.remove(at: index) // remove history pencarian berdasarkan posisi index artikelnya
        historiesUpdated() // update isi history pencarian baru yang sudah dikurangi
    }
    
    // remove all history
    func removeAllHistory() {
        history.removeAll() // remove all history
        historiesUpdated() // update isi history pencarian baru yang sudah dikurangi semua
    }
    
    // fungsi search artikel berdasarkan String yang dimasukkan
    func searchArticle() async {
        // Handling bug: Cancelled Error ketika awal menjalankan fitur search
        if Task.isCancelled { return } // cek task cancelled error
        
        let searchQuery = trimmedSearchQuery // hasil search adalah hasil string yang sudah di trim depan dan belakangnya
        phase = .empty // default phase = empty
        
        // kalo tidak ada input pada kolom search maka tidak ada yang terjadi
        if searchQuery.isEmpty {
            return
        }
        
        // Error Handling ketika melakukan pencarian berdasarkan input kolom search
        // DO (sukses / berhasil pencarian) dan CATCH (error / gagal pencarian)
        do {
            let articles = try await newsAPI.search(for: searchQuery)
            if Task.isCancelled { return } // cek task cancelled error
            if searchQuery != trimmedSearchQuery {
                return
            }
            phase = .success(articles) // tampilkan artikel
        } catch {
            if Task.isCancelled { return } // cek task cancelled error
            if searchQuery != trimmedSearchQuery {
                return
            }
            phase = .failure(error) // tampilkan error tidak ada hasil pencarian
        }
    }
    
    // fungsi load history pencarian terjadi di main thread
    private func load() {
        Task {
            self.history = await historyDataStore.load() ?? []
        }
    }
    
    // fungsi update halaman search jika hasil pencarian sudah ditambahkan atau dikurangi terjadi di main thread
    private func historiesUpdated() {
        let history = self.history
        Task {
            await historyDataStore.save(history)
        }
    }
}
