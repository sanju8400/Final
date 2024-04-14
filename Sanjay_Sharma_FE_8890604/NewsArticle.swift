//
//  NewsArticle.swift
//  Sanjay_Sharma_FE_8890604
//
//  Created by user238626 on 4/13/24.
//

import Foundation

struct NewsArticle: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let author: String
    let source: String
}


