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
    
    var articleList: Variable<[Article]> = Variable([])
    
    func requestFeed(date: String, month: String, year: String) -> Observable<Void> {
        
        return ApiProvider.request(.feed(date: date, month: month, year: year))
            .mapJSON()
            .map { json in
                let articleJson = JSON(json)
                self.articleList.value = articleJson["mostread"]["articles"].arrayValue.flatMap { Article(json: $0) }
            }
    }
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
