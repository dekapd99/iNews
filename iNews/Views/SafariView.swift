//
//  SafariView.swift
//  iNews
//
//  Created by Deka Primatio on 06/06/22.
//

import SwiftUI
import SafariServices // Library untuk membuka aplikasi safari ketika klik berita yang diinginkan

// Berisikan fungsi untuk membuka safari berdasarkan URL Berita
struct SafariView: UIViewControllerRepresentable {
    
    let url: URL // Deklarasi berita
    
    // Backend: mekanisme perpindahan view controll berita menjadi browser safari
    func makeUIViewController(context: Context) -> some SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    // View control update (Browser Safari terbuka di dalam Aplikasi iNews)
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
}
