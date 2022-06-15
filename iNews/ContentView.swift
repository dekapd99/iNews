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
                    Label("Berita", systemImage: "newspaper")
                }
            
            SearchTabView()
                .tabItem{
                    Label("Pencarian", systemImage: "magnifyingglass")
                }
            
            BookmarkTabView()
                .tabItem {
                    Label("Bookmark", systemImage: "bookmark")
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
