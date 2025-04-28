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
    private let priceTitleLabel = UILabel()
    private let priceValueLabel = UILabel()
    private let gstTitleLabel = UILabel()
    private let gstValueLabel = UILabel()
    private let discountTitleLabel = UILabel()
    private let discountValueLabel = UILabel()
    private let grandTotalTitleLabel = UILabel()
    private let grandTotalValueLabel = UILabel()
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

        // Configure title labels (e.g., "Price", "GST")
        [priceTitleLabel, gstTitleLabel, discountTitleLabel, grandTotalTitleLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textColor = .black
            label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        grandTotalTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        // Configure value labels (e.g., "₹260")
        [priceValueLabel, gstValueLabel, discountValueLabel, grandTotalValueLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textColor = .black
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        grandTotalValueLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        discountValueLabel.textColor = .systemGreen
        

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
        containerView.addSubview(priceTitleLabel)
        containerView.addSubview(priceValueLabel)
        containerView.addSubview(gstTitleLabel)
        containerView.addSubview(gstValueLabel)
        containerView.addSubview(discountTitleLabel)
        containerView.addSubview(discountValueLabel)
        containerView.addSubview(grandTotalTitleLabel)
        containerView.addSubview(grandTotalValueLabel)
        containerView.addSubview(dividerView)
        containerView.addSubview(okButton)
        self.addSubview(containerView)

        // Layout the container view
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 273),
            containerView.heightAnchor.constraint(equalToConstant: 192),
        ])

        // Layout the labels and button
        NSLayoutConstraint.activate([
            // Price row
            priceTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            priceTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            priceValueLabel.centerYAnchor.constraint(equalTo: priceTitleLabel.centerYAnchor),
            priceValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // GST row
            gstTitleLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 8),
            gstTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            gstValueLabel.centerYAnchor.constraint(equalTo: gstTitleLabel.centerYAnchor),
            gstValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // Discount row
            discountTitleLabel.topAnchor.constraint(equalTo: gstTitleLabel.bottomAnchor, constant: 8),
            discountTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            discountValueLabel.centerYAnchor.constraint(equalTo: discountTitleLabel.centerYAnchor),
            discountValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // Grand Total row
            grandTotalTitleLabel.topAnchor.constraint(equalTo: discountTitleLabel.bottomAnchor, constant: 8),
            grandTotalTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            grandTotalValueLabel.centerYAnchor.constraint(equalTo: grandTotalTitleLabel.centerYAnchor),
            grandTotalValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // Divider view
            dividerView.topAnchor.constraint(equalTo: grandTotalTitleLabel.bottomAnchor, constant: 16),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),

            // OK button
            okButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 10),
            okButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
    }

    // Configure the popup with data
    func configure(price: String, gst: String, discount: String, grandTotal: String) {
        // Convert strings to numbers and format them with two decimal places
        let priceNumber = Double(price) ?? 0
        let gstNumber = Double(gst) ?? 0
        let discountNumber = Double(discount) ?? 0
        let grandTotalNumber = Double(grandTotal) ?? 0
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        priceTitleLabel.text = "Price"
        priceValueLabel.text = "₹\(numberFormatter.string(from: NSNumber(value: priceNumber)) ?? "0.00")"
        gstTitleLabel.text = "GST"
        gstValueLabel.text = "₹\(numberFormatter.string(from: NSNumber(value: gstNumber)) ?? "0.00")"
        discountTitleLabel.text = "Discount"
        discountValueLabel.text = "-₹\(numberFormatter.string(from: NSNumber(value: discountNumber)) ?? "0.00")"
        grandTotalTitleLabel.text = "Grand Total"
        grandTotalValueLabel.text = "₹\(numberFormatter.string(from: NSNumber(value: grandTotalNumber)) ?? "0.00")"
    }

    @objc private func dismissPopup() {
        self.removeFromSuperview()
    }
}
