//
//  Popuppriceview.swift
//  RasoiChef
//
//  Created by Batch - 1 on 20/01/25.
//

import Foundation
import UIKit



   

    class PricePopupView: UIView {

        private let containerView = UIView()
        private let getPriceLabel = UILabel()
        private let grandTotalLabel = UILabel()
        private let dividerView = UIView() // Divider line
        private let okButton = UIButton(type: .system)

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupView()
        }

        private func setupView() {
            // Configure the background
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)

            // Configure the container view
            containerView.backgroundColor = .white
            containerView.layer.cornerRadius = 12
            containerView.layer.masksToBounds = true
            containerView.translatesAutoresizingMaskIntoConstraints = false

            // Configure the labels
            getPriceLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            getPriceLabel.textColor = .black
            getPriceLabel.textAlignment = .center

            grandTotalLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            grandTotalLabel.textColor = .black
            grandTotalLabel.textAlignment = .center

            // Configure the divider view
            dividerView.backgroundColor = UIColor.lightGray
            dividerView.translatesAutoresizingMaskIntoConstraints = false

            // Configure the button
            okButton.setTitle("OK", for: .normal)
            okButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            okButton.setTitleColor(.systemBlue, for: .normal)
            okButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
            okButton.translatesAutoresizingMaskIntoConstraints = false

            // Add subviews
            containerView.addSubview(getPriceLabel)
            containerView.addSubview(grandTotalLabel)
            containerView.addSubview(dividerView)
            containerView.addSubview(okButton)
            self.addSubview(containerView)

            // Layout the container view
            NSLayoutConstraint.activate([
                containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                containerView.widthAnchor.constraint(equalToConstant: 300),
                containerView.heightAnchor.constraint(equalToConstant: 200),
            ])

            // Layout the labels, divider, and button
            getPriceLabel.translatesAutoresizingMaskIntoConstraints = false
            grandTotalLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                getPriceLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                getPriceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                getPriceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

                grandTotalLabel.topAnchor.constraint(equalTo: getPriceLabel.bottomAnchor, constant: 20),
                grandTotalLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                grandTotalLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

                dividerView.topAnchor.constraint(equalTo: grandTotalLabel.bottomAnchor, constant: 20),
                dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                dividerView.heightAnchor.constraint(equalToConstant: 1),

                okButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 10),
                okButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
                okButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            ])
        }

        // Configure the popup with data
        func configure(getPrice: String, grandTotal: String) {
            getPriceLabel.text = "Get Price: \(getPrice)"
            grandTotalLabel.text = "Grand Total: \(grandTotal)"
        }

        @objc private func dismissPopup() {
            self.removeFromSuperview()
        }
    }


