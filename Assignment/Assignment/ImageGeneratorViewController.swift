//
//  ImageGeneratorViewController.swift
//  Assignment
//
//  Created by Pranjal Agarwal on 24/01/24.
//

import UIKit

protocol ImageGeneratorDisplayLogic: AnyObject {
    func displayImage(using data: Data)
    func displayError(using error: Error?)
}

final class ImageGeneratorViewController: UIViewController, ImageGeneratorDisplayLogic {

    var generateButton: UIButton!
    var generatedImage: UIImageView!
    var cacheButton: UIButton!
    let viewModel: HomeViewModel

    // MARK :- Activity lifecycle methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel = HomeViewModel()
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

    func displayImage(using data: Data) {
        generatedImage.image = UIImage(data: data)
    }

    func displayError(using error: Error?) {

    }

    @objc func generateButtonClicked() {
        viewModel.fetchImageAndStoreInCache()
    }

    @objc func getAllImageClicked() {
        let controller = CachedImageViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func clearButton() {
        LRUCache.shared.clearAll()
    }

    private func setup() {
        viewModel.controller = self
    }

    private func setupViews() {
        view.backgroundColor = .yellow
        setupImageView()
        setupGenerateButton()
        setupImagesButton()
        setupClearButton()
    }

    private func setupImageView() {
        let imageView = UIImageView()
        generatedImage = imageView
        view.addSubview(imageView)
        imageView.setTranslatesMask()
        let height = imageView.heightAnchor.constraint(equalToConstant: 300)
        let width = imageView.widthAnchor.constraint(equalToConstant: 300)
        let centerX = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let top = imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        NSLayoutConstraint.activate([centerX, top, height, width])
    }

    private func setupGenerateButton() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        let button = UIButton(configuration: config)
        generateButton = button
        view.addSubview(button)
        button.setTitle("Generate Random Image", for: .normal)
        button.setTranslatesMask()
        let centerX = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let top = button.topAnchor.constraint(equalTo: generatedImage.bottomAnchor, constant: 20)
        NSLayoutConstraint.activate([centerX, top])
        button.addTarget(self, action: #selector(generateButtonClicked), for: .touchUpInside)
    }

    private func setupClearButton() {
        let config = UIButton.Configuration.filled()
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(clearButton), for: .touchUpInside)
        button.setTitle("Clear", for: .normal)
        button.setTranslatesMask()
        view.addSubview(button)
        let centerX = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let top = button.topAnchor.constraint(equalTo: cacheButton.bottomAnchor, constant: 20)
        NSLayoutConstraint.activate([centerX, top])
    }

    private func setupImagesButton() {
        let config = UIButton.Configuration.filled()
        let button = UIButton(configuration: config)
        cacheButton = button
        button.addTarget(self, action: #selector(getAllImageClicked), for: .touchUpInside)
        button.setTitle("Get all image", for: .normal)
        button.setTranslatesMask()
        view.addSubview(button)
        let centerX = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let top = button.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: 20)
        NSLayoutConstraint.activate([centerX, top])
    }
}
