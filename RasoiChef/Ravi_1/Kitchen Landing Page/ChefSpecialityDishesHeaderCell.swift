//
//  ChefSpecialityDishCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 29/01/25.
//

import UIKit

protocol ChefSpeacialityHeaderDelegate: AnyObject {
    func didTapSeeMore1()
}

class ChefSpecialityDishesHeaderCell: UICollectionViewCell {
   
    weak var delegate: ChefSpeacialityHeaderDelegate?

    @IBAction func seeMoreTapped(_ sender: UIButton) {
           delegate?.didTapSeeMore1()
       }
}
