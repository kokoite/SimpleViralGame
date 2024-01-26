//
//  CachedImageViewController.swift
//  Assignment
//
//  Created by Pranjal Agarwal on 24/01/24.
//

import UIKit

protocol CachedImageViewDisplayLogic: AnyObject {
    func displayCachedImages(using data: [Data], and error: Error?)
    func displayDeleteCachedImage(using error: Error?)
}

final class CachedImageViewController: UIViewController, CachedImageViewDisplayLogic {

    private var collectionView: UICollectionView!
    private var dataSource: [Data] = []
    private var clearButton: UIButton!
    private var viewModel: CachedImageViewBusinessLogic?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getCachedImage()
        setupViews()
    }

    func displayCachedImages(using data: [Data], and error: Error?) {
        guard error == nil else {
            displayError(using: error)
            return
        }
        dataSource = data
        collectionView.reloadData()
    }

    func displayDeleteCachedImage(using error: Error?) {
        guard error == nil else {
            displayError(using: error)
            return
        }
        dataSource = []
        collectionView.reloadData()
    }

    @objc func clearButtonClicked() {
        viewModel?.deleteCachedImage()
    }

    private func setup() {
        let  viewModel = CachedImageViewModel()
        viewModel.controller = self
        self.viewModel = viewModel
    }

    private func displayError(using error: Error?) {
        let alertAction = UIAlertAction(title: "Okay", style: .cancel)
        guard let error = error as? ApiError else {
            let alert = UIAlertController(title: "Something went wrong", message: "Due to \(error?.localizedDescription ?? "Some unknown reason")", preferredStyle: .alert)
            alert.addAction(alertAction)
            navigationController?.present(alert, animated: true)
            return
        }
        let alert = UIAlertController(title: error.title, message: error.subtitle, preferredStyle: .alert)
        alert.addAction(alertAction)
        navigationController?.present(alert, animated: true)
    }

    private func setupViews() {
        view.backgroundColor = .white
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
        collectionView.delegate = self
        collectionView.dataSource = self
        setupClearButton()
    }

    private func setupClearButton() {
        let config = UIButton.Configuration.filled()
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(clearButtonClicked), for: .touchUpInside)
        button.setTitle("Clear", for: .normal)
        button.setTranslatesMask()
        view.addSubview(button)
        let centerX = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let top = button.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20)
        NSLayoutConstraint.activate([centerX, top])
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
        .init(width: view.bounds.width - 40, height: 300)
    }
}
