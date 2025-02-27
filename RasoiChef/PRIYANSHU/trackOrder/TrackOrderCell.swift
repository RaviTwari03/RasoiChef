//
//  TrackOrderCell.swift
//  RasoiChef
//
//  Created by Batch - 1 on 21/01/25.
//

import Foundation
import UIKit

class TrackOrderCell: UITableViewCell {
    private let statusLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let timeLabel = UILabel()
    private let statusIndicator = UIView()
    private let lineView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Configure views
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        timeLabel.textColor = .gray

        statusIndicator.layer.cornerRadius = 5
        lineView.backgroundColor = .lightGray

        // Add subviews
        contentView.addSubview(statusIndicator)
        contentView.addSubview(lineView)
        contentView.addSubview(statusLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(timeLabel)

        // Disable autoresizing masks
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add constraints
        NSLayoutConstraint.activate([
            // Status Indicator
            statusIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            statusIndicator.widthAnchor.constraint(equalToConstant: 12),
            statusIndicator.heightAnchor.constraint(equalToConstant: 12),

            // Line View
            
            lineView.leadingAnchor.constraint(equalTo: statusIndicator.centerXAnchor, constant: -1),
            lineView.topAnchor.constraint(equalTo: statusIndicator.bottomAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 2),
            lineView.heightAnchor.constraint(equalToConstant: 55),
//

            // Status Label
            statusLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 20),
            statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -10),

            // Time Label
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timeLabel.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor),

            // Description Label
            descriptionLabel.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }


    func configure(status: String, description: String, time: String, isCompleted: Bool)
    {
        statusLabel.text = status
        descriptionLabel.text = description
        timeLabel.text = time
    

        // Change the color of the status indicator based on completion
        statusIndicator.backgroundColor = isCompleted ? .systemGreen : .systemOrange

        // Adjust the visibility of the line based on the status
        if isCompleted {
            lineView.backgroundColor = .systemGreen
            
            lineView.isHidden = false
        } else {
            lineView.backgroundColor = .lightGray
            
            lineView.isHidden = true
        }
    }


}
