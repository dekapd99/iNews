//
//  ContentView.swift
//  iNews
//
//  Created by Deka Primatio on 01/06/22.
//

import SwiftUI

// Testing Ground Simulator
struct ContentView: View {
    var body: some View {
        TabView {
            NewsTabView()
                .tabItem{
                    Label("News", systemImage: "newspaper")
                }
        }
        
        // test ArticleListView
//        ArticleListView(articles: Article.previewData)
        
        // initialization code
//        Text("Hello, world!")
//            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
