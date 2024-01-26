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
    var viewModel: ImageGeneratorBusinessLogic?

    // MARK :- Activity lifecycle methods
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

    func displayImage(using data: Data) {
        generatedImage.image = UIImage(data: data)
    }

    func displayError(using error: Error?) {
        let alertAction = UIAlertAction(title: "Okay", style: .cancel)
        guard let error = error as? ApiError else {
            let alert = UIAlertController(title: "Something went wrong", message: "Please try again later", preferredStyle: .alert)
            alert.addAction(alertAction)
            navigationController?.present(alert, animated: true)
            return
        }
        let alert = UIAlertController(title: error.title, message: error.subtitle, preferredStyle: .alert)
        alert.addAction(alertAction)
        navigationController?.present(alert, animated: true)
    }

    @objc func generateButtonClicked() {
        viewModel?.fetchImageAndStoreInCache()
    }

    private func setup() {
        let viewModel = ImageGeneratorViewModel()
        viewModel.controller = self
        self.viewModel = viewModel
    }

    private func setupViews() {
        view.backgroundColor = .white
        setupImageView()
        setupGenerateButton()
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
        config.baseBackgroundColor = UIColor(red: 66/255, green: 134/255, blue: 244/255, alpha: 1)
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
}
