//
//  SearchHistoryListView.swift
//  iNews
//
//  Created by Deka Primatio on 08/06/22.
//

import SwiftUI

// Tampilan Search History berisikan Button Clear, Text, dan Riwayat Pencarian Lawas
struct SearchHistoryListView: View {
    
    // Search History diambil dari hasil Search terhadap VM Search
    @ObservedObject var searchVM: ArticleSearchViewModel
    let onSubmit: (String) -> () // Store value dalam Bentuk String
    
    // Frontend: Tampilan History dalam Bentuk List
    var body: some View {
        List {
            // Wrapper Horizontal yang berisikan elemen Text & Button
            HStack {
                Text("Riwayat Pencarian")
                Spacer()
                // Jika button di tekan jalankan fungsi remove semua history
                Button("Hapus") {
                    searchVM.removeAllHistory()
                }
                .foregroundColor(.accentColor)
            }
            .listRowSeparator(.hidden)
            // Menampilkan String Input Riwayat Pencarian Lawas
            ForEach(searchVM.history, id: \.self) { history in
                Button(history) {
                    onSubmit(history)
                }
                // Mekanisme Delete History Secara Swipe
                .swipeActions {
                    Button(role: .destructive) {
                        searchVM.removeHistory(history)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct SearchHistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        // Tampilkan Search History, default: kosong
        SearchHistoryListView(searchVM: ArticleSearchViewModel.shared) {_ in
            
        }
    }
}
