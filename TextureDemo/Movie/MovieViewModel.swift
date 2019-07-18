//
//  MovieViewModel.swift
//  TextureDemo
//
//  Created by Chittapon Thongchim on 15/7/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

import RxSwift
import RxCocoa

class MovieViewModel {

    let viewDidLoadTrigger = PublishRelay<Void>()
    let loadMoreTrigger = PublishRelay<Void>()
    let insertRows = PublishRelay<[IndexPath]>()
    let reloadData = PublishRelay<Void>()
    var movies: [Movie] { return _movies.value }
    
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    private let disposeBag = DisposeBag()
    
    init(provider: UseCaseProvider) {
        
        let useCase = provider.makeMovieUseCase()
        let currentPage = BehaviorRelay<Int>(value: 0)
        let isReachEnd = BehaviorRelay<Bool>(value: false)
        let _insertRows = BehaviorRelay<[IndexPath]>(value: [])
        
        /// Fetch movie
        let result = Observable.merge([viewDidLoadTrigger.asObservable(), loadMoreTrigger.asObservable()])
            .withLatestFrom(isReachEnd)
            .filter({ !$0 })
            .withLatestFrom(currentPage)
            .map({ $0 + 1 })
            .do(onNext: { (_currentPage) in
                currentPage.accept(_currentPage)
            })
            .flatMap({
                useCase.getMovies(page: $0)
            }).share()
        
        /// End page
        result
            .map({ $0.page >= $0.totalPages })
            .bind(to: isReachEnd)
            .disposed(by: disposeBag)
        
        /// Handle movie data
        result.do(onNext: { [_movies] (newData) in
            /// Calculate indexpath
            let oldResults = _movies.value.count
            var indexPaths: [IndexPath] = []
            for (index, _) in newData.data.enumerated() {
                let indexPath = IndexPath(row: oldResults + index, section: 0)
                indexPaths.append(indexPath)
            }
            _insertRows.accept(indexPaths)
            
        }).map({ [_movies] (newData) -> [Movie] in
            return _movies.value + newData.data
        }).bind(to: _movies).disposed(by: disposeBag)
        
        /// Result on viewDidLoad
        _movies
            .withLatestFrom(currentPage)
            .filter({ $0 == 1 })
            .take(1)
            .map({ _ in () })
            .bind(to: reloadData)
            .disposed(by: disposeBag)
        
        /// Result on nextpage
        _movies
            .withLatestFrom(currentPage)
            .filter({ $0 > 1 })
            .withLatestFrom(_insertRows)
            .bind(to: insertRows)
            .disposed(by: disposeBag)
    }
    
}
