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
            statusIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusIndicator.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor),
            statusIndicator.widthAnchor.constraint(equalToConstant: 10),
            statusIndicator.heightAnchor.constraint(equalToConstant: 10),

            lineView.centerXAnchor.constraint(equalTo: statusIndicator.centerXAnchor),
            lineView.topAnchor.constraint(equalTo: statusIndicator.bottomAnchor),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 2),

            statusLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 20),
            statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            descriptionLabel.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5),

            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timeLabel.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor)
        ])
    }

    func configure(status: String, description: String, time: String, isCompleted: Bool) {
        statusLabel.text = status
        descriptionLabel.text = description
        timeLabel.text = time

        statusIndicator.backgroundColor = isCompleted ? .systemGreen : .systemOrange
        lineView.isHidden = status == "Delivered"
    }
}
