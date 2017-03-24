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
    var articleSectionList: [ArticleSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        loadFeedOfTheDay()
        //search(for: "bangkok")
    }

    func bindViewModel() {
        viewModel.articleSections.asObservable()
            .subscribe(onNext: { articleSectionList in
                self.articleSectionList = articleSectionList
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
    
    func search(for title: String) {
        viewModel.search(by: title)
            .subscribe(onNext: { result in
                self.articleSectionList = result
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("deinit ViewController");
    }

}

//MARK:- UITableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return articleSectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleSectionList[section].articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let article = articleSectionList[indexPath.section].articles?[indexPath.row] {
            cell.textLabel?.text = article.normalizedtitle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let article = articleSectionList[indexPath.section].articles?[indexPath.row] {
            performSegue(withIdentifier: "ArticleDetail", sender: article)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return articleSectionList[section].title
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


