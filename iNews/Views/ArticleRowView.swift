//
//  ArticleRowView.swift
//  iNews
//
//  Created by Deka Primatio on 01/06/22.
//

import SwiftUI

struct ArticleRowView: View {
    
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
            
            VStack(alignment: .leading, spacing: 3) {
                Text(article.title)
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                // tampilan ui ketika preview artikel
                ArticleRowView(article: .previewData[0])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain) // style list content
        }
    }
}
