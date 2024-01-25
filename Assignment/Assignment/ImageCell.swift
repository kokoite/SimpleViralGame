//
//  ImageCell.swift
//  Assignment
//
//  Created by Pranjal Agarwal on 24/01/24.
//

import UIKit

final class ImageCell: UICollectionViewCell {

    private var cachedImage: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(using data: Data) {
        cachedImage.image = UIImage(data: data)
    }

    private func setup() {
        let imageView = UIImageView()
        cachedImage = imageView
        contentView.addSubview(imageView)
        imageView.setTranslatesMask()
        imageView.pinToEdges(in: contentView)
    }
}
