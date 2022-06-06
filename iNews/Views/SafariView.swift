//
//  SafariView.swift
//  iNews
//
//  Created by Deka Primatio on 06/06/22.
//

import SwiftUI
import SafariServices // untuk membuka aplikasi safari ketika klik berita

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL // declare url
    
    // backend menampilkan tampilan browser safari
    func makeUIViewController(context: Context) -> some SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
}
