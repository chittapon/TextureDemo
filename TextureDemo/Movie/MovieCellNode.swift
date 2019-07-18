//
//  MovieCellNode.swift
//  TextureDemo
//
//  Created by Chittapon Thongchim on 15/7/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MovieCellNode: ASCellNode {
    
    let titleTextNode = ASTextNode()
    let networkImageNode = ASNetworkImageNode()
    let imageNode = ASImageNode()
    let overViewTextNode = ASTextNode()
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        super.init()
        selectionStyle = .none
        titleTextNode.attributedText = NSAttributedString(string: movie.title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        addSubnode(titleTextNode)
        overViewTextNode.attributedText = NSAttributedString(string: movie.overview)
        addSubnode(overViewTextNode)
        
        networkImageNode.shouldCacheImage = true
        networkImageNode.url = movie.posterURL
        networkImageNode.contentMode = .scaleAspectFill
        networkImageNode.delegate = self
        addSubnode(networkImageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let verticalStackSpec = ASStackLayoutSpec()
        verticalStackSpec.direction = .vertical
        verticalStackSpec.spacing = 8
        
        if let image = networkImageNode.image {
            let ratio = image.size.height/image.size.width
            let imageRatioSpec = ASRatioLayoutSpec(ratio: ratio, child: networkImageNode)
            verticalStackSpec.children = [imageRatioSpec, titleTextNode]
        }else {
            verticalStackSpec.children = [titleTextNode]
        }
        if !movie.overview.isEmpty {
            verticalStackSpec.children?.append(overViewTextNode)
        }
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15), child: verticalStackSpec)
        return insetSpec
    }
    
    override func didLoad() {
        /// Do something on main thread
    }
    
}

extension MovieCellNode: ASNetworkImageNodeDelegate {
    
    func imageNode(_ imageNode: ASNetworkImageNode, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        networkImageNode.url = nil
        networkImageNode.image = image
        networkImageNode.delegate = nil
        if let tableNode = owningNode as? ASTableNode {
            tableNode.performBatch(animated: true, updates: { [weak self] in
                self?.setNeedsLayout()
            }, completion: nil)
        }
    }
}
