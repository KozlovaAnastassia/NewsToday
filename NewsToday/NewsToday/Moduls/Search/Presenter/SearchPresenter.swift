//
//  SearchPresenter.swift
//  NewsToday
//
//  Created by Maryna Bolotska on 24/03/24.
//

import UIKit

protocol SearchArticlesPresenterProtocol {
    func numberOfArticles() -> Int
    func getArticles(at index: Int) -> Article
    func reloadData()
    func updateArticles(_ articles: [Article])
}

final class SearchArticlesPresenter: SearchArticlesPresenterProtocol {
    
    weak var searchArticlesViewControllerProtocol: SearchArticlesViewControllerProtocol?
    
    // MARK: Properties

    var articles: [Article] = []

    // MARK: Init

    init(searchArticlesViewControllerProtocol: SearchArticlesViewControllerProtocol? = nil) {
        self.searchArticlesViewControllerProtocol = searchArticlesViewControllerProtocol
    }

    // MARK: Methods

    func reloadData() {
        searchArticlesViewControllerProtocol?.reloadData()
    }

    func numberOfArticles() -> Int {
        return articles.count
    }

    func getArticles(at index: Int) -> Article {
        return articles[index]
    }

    func updateArticles(_ articles: [Article]) {
        self.articles = articles
        
        reloadData()
    }
}
