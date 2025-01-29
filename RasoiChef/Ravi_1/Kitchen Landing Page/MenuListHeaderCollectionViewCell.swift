//
//  MenuListHeaderCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 29/01/25.
//

import UIKit
protocol MenuListHeaderDelegate: AnyObject {
    func didTapSeeMore()
}

class MenuListHeaderCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MenuListHeaderDelegate?

    @IBAction func seeMoreTapped(_ sender: UIButton) {
           delegate?.didTapSeeMore()
       }
}
