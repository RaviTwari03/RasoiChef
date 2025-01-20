//
//  pricePopupview.swift
//  RasoiChef
//
//  Created by Batch - 1 on 20/01/25.
//

import UIKit

class pricePopupview: UIView {
    
    @IBOutlet weak var getPriceLabel: UILabel!
       @IBOutlet weak var grandTotalLabel: UILabel!
       @IBOutlet weak var okButton: UIButton!

       // Load the view from the xib file
    class func instantiateFromNib() -> pricePopupview {
           let nib = UINib(nibName: "pricePopupview", bundle: nil)
           return nib.instantiate(withOwner: nil, options: nil).first as! pricePopupView
       }

       // Dismiss the popup when the "OK" button is tapped
       @IBAction func dismissPopup(_ sender: UIButton) {
           self.removeFromSuperview()
       }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
