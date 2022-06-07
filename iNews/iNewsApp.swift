//
//  iNewsApp.swift
//  iNews
//
//  Created by Deka Primatio on 01/06/22.
//

// Environment Object File pada Project iNews
import SwiftUI

@main
struct iNewsApp: App {
    
    // sharing fitur bookmark diseluruh project folder dengan @StateObject secara Environment Object
    @StateObject var articleBookmarkVM = ArticleNewsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // environment object untuk sharing fitur bookmark
                .environmentObject(articleBookmarkVM)
        }
    }
}
