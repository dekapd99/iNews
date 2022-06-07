//
//  EmptyPlaceholderView.swift
//  iNews
//
//  Created by Deka Primatio on 07/06/22.
//

import SwiftUI

// Placeholder ketika fetching data gambar
struct EmptyPlaceholderView: View {
    
    let text: String
    let image: Image?
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            
            // kalo imagenya ada, buat image seperti setting dibawah ini
            if let image = self.image {
                image
                    .imageScale(.large)
                    .font(.system(size: 52))
            }
            Text(text)
            Spacer()
        }
    }
}

struct EmptyPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlaceholderView(text: "No Bookmark", image: Image(systemName: "bookmark"))
    }
}
