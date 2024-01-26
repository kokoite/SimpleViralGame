//
//  ViewController.swift
//  Assignment
//
//  Created by Pranjal Agarwal on 24/01/24.
//

import UIKit

class ViewController: UIViewController {
    private var titleView: UILabel!
    private var generateButton: UIButton!
    private var recentButton: UIButton!

    // MARK :- Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK :- Activity Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }

    @objc func generateImageClicked() {
        let controller = ImageGeneratorViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func cachedImageClicked() {
        let controller = CachedImageViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func setupViews() {
        setupTitle()
        setupGenerateButton()
        setupRecentButton()
    }

    private func setupTitle() {
        let title = UILabel()
        titleView = title
        title.text = "Random Image Generator!"
        view.addSubview(title)
        title.setTranslatesMask()
        let centerX = title.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let top = title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        NSLayoutConstraint.activate([centerX, top])
    }

    private func setupGenerateButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
        configuration.baseBackgroundColor = UIColor(red: 66/255, green: 134/255, blue: 244/255, alpha: 1)
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(generateImageClicked), for: .touchUpInside)
        generateButton = button
        button.layer.cornerRadius = 12
        view.addSubview(button)
        button.setTranslatesMask()
        button.setTitle("Generate Image", for: .normal)
        let centerX = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let top = button.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20)
        let minTop = button.topAnchor.constraint(lessThanOrEqualTo: titleView.bottomAnchor, constant: 20)
        NSLayoutConstraint.activate([centerX, top, minTop])
    }

    private func setupRecentButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        configuration.baseBackgroundColor = UIColor(red: 66/255, green: 134/255, blue: 244/255, alpha: 1)
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(cachedImageClicked), for: .touchUpInside)
        recentButton = button
        view.addSubview(button)
        button.setTranslatesMask()
        button.setTitle("My recently generated Dogs!", for: .normal)
        let centerX = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let top = button.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: 20)
        NSLayoutConstraint.activate([centerX, top])
    }
}

