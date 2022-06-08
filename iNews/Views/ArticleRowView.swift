//
//  ArticleRowView.swift
//  iNews
//
//  Created by Deka Primatio on 01/06/22.
//

import SwiftUI

// frontend: tampilan satu artikel
struct ArticleRowView: View {
    
    // sambungin fitur bookmark dengan @EnvironmentObject
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    // menggunakan file Article dari folder Models
    let article: Article
    var body: some View {
        
        // untuk memunculkan gambar ketika loading
        VStack(alignment: .leading, spacing: 16){ // Vertical Stack
            AsyncImage(url: article.imageURL) { phase in
                switch phase {
                case .empty: // Skeleton ketika gambar sedang loading
                    HStack { // Horizontal Stack
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    
                case .success(let image): // ketika berhasil loading
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                case .failure: // ketika error API Code Response
                    HStack { // Horizontal Stack
                        Spacer()
                        Image(systemName: "photo").imageScale(.large)
                        Spacer()
                    }
                    
                @unknown default:
                    fatalError()
                }
            }
            .frame(minHeight: 200, maxHeight: 300)
            .background(Color.gray.opacity(0.3))
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
                
                HStack {
                    Text(article.captionText)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Spacer()
                    
                    // Bookmark button
                    Button {
                        toggleBookmark(for: article)
                    } label: {
                        // jika ada Artikel yang di Bookmark maka munculkan icon Bookmark Fil, jika tidak ada maka pakai icon bookmark biasa
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
            .padding([.horizontal, .bottom])
        }
    }
    
    private func toggleBookmark(for article: Article) {
        if articleBookmarkVM.isBookmarked(for: article) {
            articleBookmarkVM.removeBookmark(for: article)
        } else {
            articleBookmarkVM.addBookmark(for: article)
        }
    }
}

extension View {
    
    func presentShareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    
    // sharing fitur bookmark diseluruh project folder dengan @StateObject secara Environment Object
    // kalo gak dimasukkin kesini dalam bentuk static bakalan aplikasi crash
    @StateObject static var articleBookmarkVM = ArticleNewsViewModel()
    
    static var previews: some View {
        NavigationView {
            List {
                // tampilan ui ketika preview artikel
                ArticleRowView(article: .previewData[0])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain) // style list content
        }
        // inject environmentObject
        .environmentObject(articleBookmarkVM)
    }
}
