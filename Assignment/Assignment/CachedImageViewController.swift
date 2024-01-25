//
//  CachedImageViewController.swift
//  Assignment
//
//  Created by Pranjal Agarwal on 24/01/24.
//

import UIKit

final class CachedImageViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var dataSource: [Data] = []

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setup() {

    }

    private func setupViews() {
        view.backgroundColor = .red
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.setTranslatesMask()
        let leading = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let top = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cacheCell")
        dataSource = LRUCache.shared.getAllCached()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension CachedImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cacheCell", for: indexPath) as? ImageCell
        cell?.configure(using: dataSource[indexPath.row])
        return cell ?? UICollectionViewCell()
    }

}

extension CachedImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.bounds.width - 20, height: 300)
    }
}
