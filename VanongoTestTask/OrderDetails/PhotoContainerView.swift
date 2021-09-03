//
//  PhotoContainerView.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 02.09.2021.
//

import UIKit

class PhotoContainerView: UIImageView {
    var closeButton: UIButton
    
    override init(image: UIImage?) {
        closeButton = UIButton(type: .close)
        super.init(image: image)
        setup()
    }
    
    required init?(coder: NSCoder) {
        closeButton = UIButton(type: .close)
        super.init(coder: coder)
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        setRoundCorners()
        
        setupCloseButton()
        addSubview(closeButton)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 150),
            heightAnchor.constraint(equalToConstant: 150),

            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
    }
    
    private func setupCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }

    @objc
    func didTapCloseButton() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
