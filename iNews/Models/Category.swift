//
//  Category.swift
//  iNews
//
//  Created by Deka Primatio on 06/06/22.
//

import Foundation

// declare raw value untuk kategori berita
enum Category: String, CaseIterable {
    case general
    case business
    case technology
    case entertainment
    case sports
    case science
    case health
    
    // computed property untuk display setiap case ke dalam teks
    var text: String {
        if self == .general {
            return "Top Headlines"
        }
        return rawValue.capitalized
    }
}

extension Category: Identifiable {
    var id: Self { self }
}
