//
//  MovieViewController.swift
//  TextureDemo
//
//  Created by Chittapon Thongchim on 15/7/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RxSwift

class MovieViewController: UIViewController {

    let tableNode = ASTableNode(style: .plain)
    let viewModel = MovieViewModel(provider: AppDelegate.provider)
    let disposeBag = DisposeBag()
    var loadmoreBag = DisposeBag()
    
    deinit {
        /// Make sure memmory deallocate
        print("deinit \(type(of: self))")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(viewModel: viewModel)
        viewModel.viewDidLoadTrigger.accept(())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableNode.frame = view.bounds
    }
    
    private func setupUI() {
        title = "Upcoming movies"
        tableNode.leadingScreensForBatching = 2
        tableNode.view.separatorStyle = .none
        view.addSubnode(tableNode)
    }

    private func bind(viewModel: MovieViewModel){
        viewModel.reloadData.subscribe(onNext: { [weak self] in
            self?.tableNode.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension MovieViewController: ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let cellNodeBlock = { [unowned self] () -> ASCellNode in
            let movie = self.viewModel.movies[indexPath.row]
            return MovieCellNode(movie: movie)
        }
        return cellNodeBlock
    }
}

extension MovieViewController: ASTableDelegate {
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return !viewModel.movies.isEmpty
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        viewModel.loadMoreTrigger.accept(())
        viewModel.insertRows.subscribe(onNext: { [weak self] (indexPaths) in
            tableNode.insertRows(at: indexPaths, with: .automatic)
            context.completeBatchFetching(true)
            /// Make sure don't duplicate subscribe
            self?.loadmoreBag = DisposeBag()
        }).disposed(by: loadmoreBag)
    }
    
}
