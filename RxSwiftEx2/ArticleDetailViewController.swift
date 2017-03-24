//
//  ArticleDetailViewController.swift
//  RxSwiftEx2
//
//  Created by Waratnan Suriyasorn on 3/24/2560 BE.
//  Copyright © 2560 Waratnan Suriyasorn. All rights reserved.
//

import UIKit
import RxSwift
import Nuke

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    let viewModel = ArticleDetailViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
    }
    
    func bindToViewModel() {
        viewModel.article.asObservable()
            .subscribe(onNext: { article in
                if let article = article {
                    self.updateViewWith(article: article)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func updateViewWith(article data: Article) {
        title = data.normalizedtitle
        timeStamp.text = data.timestamp
        descLabel.text = data.extract
        if let imageUrl = data.originalimage, let url = URL(string: imageUrl) {
            Nuke.loadImage(with: url, into: imageView)
        }
        
    }
    
    deinit {
        print("deinit ArticleDetailViewController")
    }
}
