//
//  iNewsApp.swift
//  iNews
//
//  Created by Deka Primatio on 01/06/22.
//

// Environment Object File pada Project iNews
import SwiftUI

// Root Project
@main
struct iNewsApp: App {
    
    // Sharing fitur bookmark pada root project dengan @StateObject secara Environment Object
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Property wrapper observable object supplied by a parent or ancestor view untuk sharing fitur bookmark
                .environmentObject(articleBookmarkVM)
        }
    }
}
