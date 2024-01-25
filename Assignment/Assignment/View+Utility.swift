//
//  View+Utility.swift
//  Assignment
//
//  Created by Pranjal Agarwal on 24/01/24.
//

import UIKit

extension UIView {

    func setTranslatesMask() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func pinToEdges(in view: UIView) {
        let leading = leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let top = topAnchor.constraint(equalTo: view.topAnchor)
        let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
}
