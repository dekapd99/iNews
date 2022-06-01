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
        VStack(alignment: .leading, spacing: 16){
            AsyncImage(url: article.imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case . success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                case .failure:
                    Image(systemName: "photo")
                    
                @unknown default:
                    fatalError()
                }
            }
        }
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            // tampilan ui ketika preview artikel
            ArticleRowView(article: .previewData[0])
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain) // style list content
    }
}
