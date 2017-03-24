//
//  ViewController.swift
//  RxSwiftEx2
//
//  Created by Waratnan Suriyasorn on 3/24/2560 BE.
//  Copyright © 2560 Waratnan Suriyasorn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    let viewModel = FeedViewModel()
    var articleList: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        loadFeedOfTheDay()
    }

    func bindViewModel() {
        viewModel.articleList.asObservable()
            .subscribe(onNext: { articleList in
                self.articleList = articleList
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func loadFeedOfTheDay() {
        viewModel.requestFeed(date: "24", month: "03", year: "2017")
            .subscribe { _ in
                print("loadFeedOfTheDay success?")
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("deinit ViewController");
    }

}

//MARK:- UITableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //guard
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       //     as? UITableViewCell else {
       //     return UITableViewCell()
       // }
        
        let article = articleList[indexPath.row]
        cell.textLabel?.text = article.normalizedtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artilce = articleList[indexPath.row]
        performSegue(withIdentifier: "ArticleDetail", sender: artilce)
    }
    
}

//MARK:- segue
extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ArticleDetail",
            let vc = segue.destination as? ArticleDetailViewController,
            let article = sender as? Article {
                vc.viewModel.article.value = article
        }
    }
}


