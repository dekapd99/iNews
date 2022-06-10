//
//  ArticleRowView.swift
//  iNews
//
//  Created by Deka Primatio on 01/06/22.
//

import SwiftUI

// Berisikan Tampilan Berita (per baris / satuan)
struct ArticleRowView: View {
    
    // Mengaktifkan fitur bookmark dengan @EnvironmentObject terhadap VM Bookmark
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    let article: Article
    var body: some View {
        // Wrapper Vertikal untuk Gambar
        VStack(alignment: .leading, spacing: 16){
            // load tampilan berita di main thread
            AsyncImage(url: article.imageURL) { phase in
                switch phase {
                case .empty: // Skeleton ketika gambar sedang loading
                    HStack { // Wrapper Horizontal untuk animasi ProgressView()
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    
                case .success(let image): // Load thumbnail berita
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                case .failure: // Gagal load berita
                    HStack { // Wrapper Horizontal untuk icon photo
                        Spacer()
                        Image(systemName: "photo").imageScale(.large)
                        Spacer()
                    }
                    
                @unknown default:
                    fatalError()
                }
            }
            .frame(minHeight: 200, maxHeight: 300) // Ukuran frame row untuk gambar
            .background(Color.gray.opacity(0.3)) // Warna background skeleton
            .clipped() // clip gambar sesuai frame agar tidak overflow
            
            // Wrapper Vertikal untuk (Judul, Deskripsi, Caption, Button (Bookmark dan Share))
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3) // Max baris (Judul)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2) // Max baris (Deskripsi)
                
                // Wrapper Horizontal (Caption, Button (Bookmark & Share))
                HStack {
                    Text(article.captionText)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Spacer()
                    
                    // Toggle Bookmark button
                    Button {
                        toggleBookmark(for: article)
                    } label: {
                        // jika sudah di Bookmark maka tampilan button icon berubah menjadi Bookmark Fill,
                        // jika belum di bookmark maka tampilan button icon tetap bookmark biasa
                        Image(systemName: articleBookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                    }
                    .buttonStyle(.bordered)
                    
                    // Share Button
                    Button {
                        presentShareSheet(url: article.articleURL)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding([.horizontal, .bottom]) // kasih padding bawah
        }
    }
    
    // Fungsi toggle bookmark
    // jika button ditekan dan statusnya sudah ada didalam bookmark maka remove dari bookmark
    // jika button ditekan dan statusnya belum ada didalam bookmark maka tambakan ke bookmark
    private func toggleBookmark(for article: Article) {
        if articleBookmarkVM.isBookmarked(for: article) {
            articleBookmarkVM.removeBookmark(for: article)
        } else {
            articleBookmarkVM.addBookmark(for: article)
        }
    }
}

extension View {
    // Fungsi untuk menampilkan Panel sharing with URL ketika tombol share ditekan
    func presentShareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    // Mengaktifkan fitur bookmark yang sudah di supply di root project di buat dalam static agar aplikasi tidak crash
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    // Frontend: Menampilkan Berita dalam bentuk List
    static var previews: some View {
        NavigationView {
            List {
                ArticleRowView(article: .previewData[0])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
        }
        // Property wrapper observable object fitur bookmark dari root folder diatas
        .environmentObject(articleBookmarkVM)
    }
}
