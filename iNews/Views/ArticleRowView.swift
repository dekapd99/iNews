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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowView(article: .previewData[0])
    }
}
