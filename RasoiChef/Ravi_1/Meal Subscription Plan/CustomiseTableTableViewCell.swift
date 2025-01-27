//
//  CustomiseTableTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

protocol CustomiseTableDelegate: AnyObject {
    func buttonClicked(withTag tag: Int)
}

class CustomiseTableTableViewCell: UITableViewCell {
    
    weak var delegate: CustomiseTableDelegate?
  
    @IBOutlet var Breakfastbutton: UIButton!
    @IBOutlet var LunchButton: UIButton!
    
    @IBOutlet var SnacksButton: UIButton!
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var DinnerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetButtonStates()

        // Assign custom tags
        Breakfastbutton.tag = 40
        LunchButton.tag = 60
        SnacksButton.tag = 40
        DinnerButton.tag = 60
    }
    // Tracks button visibility states
        private var buttonStates: [Bool] = [true, true, true, true]

        
    func configureRow(withIcons icons: [String]) {
           Breakfastbutton.isHidden = false
           LunchButton.isHidden = false
           SnacksButton.isHidden = false
           DinnerButton.isHidden = false

           setButtonImage(button: Breakfastbutton, iconName: icons[0])
           setButtonImage(button: LunchButton, iconName: icons[1])
           setButtonImage(button: SnacksButton, iconName: icons[2])
           setButtonImage(button: DinnerButton, iconName: icons[3])
       }

//    func configureRow(withIcons icons: [String]) {
//        print("Configuring row with icons: \(icons)")
//
//        Breakfastbutton.isHidden = !buttonStates[0]
//        LunchButton.isHidden = !buttonStates[1]
//        SnacksButton.isHidden = !buttonStates[2]
//        DinnerButton.isHidden = !buttonStates[3]
//
//        setButtonImage(button: Breakfastbutton, iconName: icons[0])
//        setButtonImage(button: LunchButton, iconName: icons[1])
//        setButtonImage(button: SnacksButton, iconName: icons[2])
//        setButtonImage(button: DinnerButton, iconName: icons[3])
//    }

//        private func setButtonImage(button: UIButton, iconName: String) {
//            guard let image = UIImage(named: iconName) else {
//                print("Error: Image \(iconName) not found.")
//                button.setImage(nil, for: .normal)
//                return
//            }
//            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 30, height: 30))
//            button.setImage(resizedImage, for: .normal)
//            button.imageView?.contentMode = .scaleAspectFit
//            button.setTitle(nil, for: .normal)
//        }
    private func setButtonImage(button: UIButton, iconName: String) {
           guard let image = UIImage(named: iconName) else { return }
           let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 30, height: 30))
           button.setImage(resizedImage, for: .normal)
           button.imageView?.contentMode = .scaleAspectFit
           button.setTitle(nil, for: .normal)
       }

        private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            let widthRatio = targetSize.width / size.width
            let heightRatio = targetSize.height / size.height
            let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)

            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage ?? image
        }


    @IBAction func buttonClicked(_ sender: UIButton) {
        print("Button clicked: \(sender)")
        print("Tag: \(sender.tag)")
        delegate?.buttonClicked(withTag: sender.tag)
        switch sender {
        case Breakfastbutton:
            print("Breakfast button clicked")
            buttonStates[0] = false
        case LunchButton:
            print("Lunch button clicked")
            buttonStates[1] = false
        case SnacksButton:
            print("Snacks button clicked")
            buttonStates[2] = false
        case DinnerButton:
            print("Dinner button clicked")
            buttonStates[3] = false
        default:
            print("Unknown button clicked")
            return
        }

        sender.isHidden = true
        print("Button hidden: \(sender.isHidden)")
        
    }

        private func resetButtonStates() {
            buttonStates = [true, true, true, true]
            Breakfastbutton.isHidden = false
            LunchButton.isHidden = false
            SnacksButton.isHidden = false
            DinnerButton.isHidden = false
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            resetButtonStates()
        }
    }
