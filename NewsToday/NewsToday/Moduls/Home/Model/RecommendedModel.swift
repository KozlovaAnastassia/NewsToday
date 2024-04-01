//
//  RecommendedModel.swift
//  NewsToday
//
//  Created by Анастасия on 19.03.2024.
//

import Foundation

struct RecommendedModel {
    let imageURL: String
    let categoryName: String
    let titleText: String
    let id: String
}
struct RecommendedModelResponse {
    let article: [Article]
    let category: String
}
