//
//  ViewController.swift
//  Assignment
//
//  Created by Pranjal Agarwal on 24/01/24.
//

import UIKit

class ViewController: UIViewController {
    private let viewModel: HomeViewModel
    private var titleView: UILabel!
    private var generateButton: UIButton!
    private var recentButton: UIButton!

    // MARK :- Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel = HomeViewModel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        viewModel = HomeViewModel()
        super.init(coder: coder)
    }
    

    // MARK :- Activity Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupViews()
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
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
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
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        recentButton = button
        view.addSubview(button)
        button.setTranslatesMask()
        button.setTitle("My recently generated Dogs!", for: .normal)
        let centerX = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let top = button.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: 20)
        NSLayoutConstraint.activate([centerX, top])
    }
}

