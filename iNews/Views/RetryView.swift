//
//  RetryView.swift
//  iNews
//
//  Created by Deka Primatio on 07/06/22.
//

import SwiftUI

// Berisikan Button untuk Retry dalam bentuk Text "Try Again"
// Case Handler: Failure di ArticleRowView
struct RetryView: View {
    
    let text: String // deklarasi error text
    let retryAction: () -> () // deklarasi ketika retryAction ditekan
    
    var body: some View {
        
        // Wrapper Vertikal untuk Error Text dan Retry Button
        VStack(spacing: 8) {
            // render text error-nya
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            
            // retry button dan render dalam bentuk Text
            Button(action: retryAction) {
                Text("Try Again")
            }
        }
    }
}

struct RetryView_Previews: PreviewProvider {
    // Tampilan Error Case
    static var previews: some View {
        RetryView(text: "An Error Occured") {}
    }
}
