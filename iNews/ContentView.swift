//
//  ContentView.swift
//  iNews
//
//  Created by Deka Primatio on 01/06/22.
//

// Root Content
import SwiftUI

// Testing Ground Simulator
struct ContentView: View {
    var body: some View {
        // Bottom Navigation Menu
        TabView {
            NewsTabView()
                .tabItem{
                    Label("News", systemImage: "newspaper")
                }
            
            SearchTabView()
                .tabItem{
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            BookmarkTabView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
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
