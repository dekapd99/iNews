//
//  RetryView.swift
//  iNews
//
//  Created by Deka Primatio on 07/06/22.
//

import SwiftUI

// Case Handler Failure
struct RetryView: View {
    
    let text: String
    let retryAction: () -> ()
    
    var body: some View {
        VStack(spacing: 8) {
            // render text errornya
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            
            // retry button
            Button(action: retryAction) {
                // render button dalam bentuk teks
                Text("Try Again")
            }
            
        }
    }
}

struct RetryView_Previews: PreviewProvider {
    static var previews: some View {
        RetryView(text: "An Error Occured") {
            
        }
    }
}
