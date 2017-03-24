//
//  FeedViewModel.swift
//  RxSwiftEx2
//
//  Created by Waratnan Suriyasorn on 3/24/2560 BE.
//  Copyright © 2560 Waratnan Suriyasorn. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class FeedViewModel {
    
    var articleSections: Variable<[ArticleSection]> = Variable([])
    
    var todayArticle: [Article] = []
    
    func requestFeed(date: String, month: String, year: String) -> Observable<Void> {
        
        return ApiProvider.request(.feed(date: date, month: month, year: year))
            .mapJSON()
            .map { json in
                let articleJson = JSON(json)
                let articleList = articleJson["mostread"]["articles"].arrayValue.flatMap { Article(json: $0) }
                let seciton = ArticleSection(title: "Today", articles: articleList)
                self.articleSections.value = [seciton]
            }
    }
    
    func search(by title: String) -> Observable<[ArticleSection]> {
        return randomArticle().flatMapLatest { randomArticlesSection -> Observable<[ArticleSection]> in
            return self.related(by: title).flatMap { searchResultSection -> Observable<[ArticleSection]> in
                return .just([searchResultSection, randomArticlesSection])
            }
        }
    }
    
    private func randomArticle() -> Observable<ArticleSection> {
        return ApiProvider.request(.randomArticle)
            .mapJSON()
            .flatMap { (json) -> Observable<ArticleSection> in
                let articleJson = JSON(json)
                let articles = articleJson["pages"].arrayValue.flatMap { Article(json: $0) }
                let seciton = ArticleSection(title: "You May Be Interested", articles: articles)
                return .just(seciton)
        }
    }
    
    private func related(by title: String) -> Observable<ArticleSection> {
        let searchTile = title.replacingOccurrences(of: " ", with: "_")
        return ApiProvider.request(.relate(title: searchTile))
            .mapJSON()
            .flatMap { json -> Observable<ArticleSection> in
                let articleJson = JSON(json)
                let articles = articleJson["pages"].arrayValue.flatMap { Article(json: $0) }
                let seciton = ArticleSection(title: "Result", articles: articles)
                return .just(seciton)
        }
    }
}

struct ArticleSection {
    var title: String?
    var articles: [Article]?
}

struct Article {
    var pageId: Int?
    var title: String?
    var extract: String?
    var thumbnail: String?
    var originalimage: String?
    var description: String?
    var normalizedtitle: String?
    var timestamp: String?
    
    init? (json: JSON) {
        pageId = json["pageid"].int
        title = json["title"].string
        extract = json["extract"].string
        thumbnail = json["thumbnail"]["source"].string
        originalimage = json["originalimage"]["source"].string
        description = json["description"].string
        normalizedtitle = json["normalizedtitle"].string
        timestamp = json["timestamp"].string
    }
    
}
