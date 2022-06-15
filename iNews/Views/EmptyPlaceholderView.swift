//
//  EmptyPlaceholderView.swift
//  iNews
//
//  Created by Deka Primatio on 07/06/22.
//

import SwiftUI

// Berisikan Placeholder ketika fetching data berita untuk thumbnail dan text
// Case Handler: Empty di ArticleRowView
struct EmptyPlaceholderView: View {
    
    let text: String // text tetap di generate
    let image: Image? // thumbnail berita optional -> bisa saja berita tidak ada atau tidak support format gambar
    
    var body: some View {

        // Wrapper Vertikal untuk gambar dan text
        VStack(spacing: 8) {
            Spacer()
            // Jika Thumbnailnya ada, maka setting image tersebut seperti dibawah ini
            if let image = self.image {
                image
                    .imageScale(.large)
                    .font(.system(size: 52))
            }
            Text(text) // text berita
            Spacer()
        }
    }
}

struct EmptyPlaceholderView_Previews: PreviewProvider {
    // Default text kalo Bookmark Kosong
    static var previews: some View {
        EmptyPlaceholderView(text: "Kosong", image: Image(systemName: "bookmark"))
    }
}
