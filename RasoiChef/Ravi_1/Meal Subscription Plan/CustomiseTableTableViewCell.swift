//
//  CustomiseTableTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

class CustomiseTableTableViewCell: UITableViewCell {

    @IBOutlet var Breakfastbutton: UIButton!
    @IBOutlet var LunchButton: UIButton!
    @IBOutlet var SnacksButton: UIButton!
    @IBOutlet var DinnerButton: UIButton!
   
    

//    override func awakeFromNib() {
//           super.awakeFromNib()
//       }
//
//       override func setSelected(_ selected: Bool, animated: Bool) {
//           super.setSelected(selected, animated: animated)
//       }
//
//       // Configure the cell with images for each meal
//       func configureCell(breakfastIcon: String, lunchIcon: String, snacksIcon: String, dinnerIcon: String) {
//           setButtonImage(button: Breakfastbutton, iconName: breakfastIcon)
//           setButtonImage(button: LunchButton, iconName: lunchIcon)
//           setButtonImage(button: SnacksButton, iconName: snacksIcon)
//           setButtonImage(button: DinnerButton, iconName: dinnerIcon)
//       }
//
//       // Helper function to set button image and remove title
//    private func setButtonImage(button: UIButton, iconName: String) {
//        if let image = UIImage(named: iconName) {
//            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 35, height: 35))
//            button.setImage(resizedImage, for: .normal)
//            button.imageView?.contentMode = .scaleAspectFit
//        }
//        button.setTitle("", for: .normal) // Explicitly remove the button title
//    }
//
//       // Helper function to resize images
//       private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//           let size = image.size
//           let widthRatio = targetSize.width / size.width
//           let heightRatio = targetSize.height / size.height
//           let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
//
//           UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//           image.draw(in: CGRect(origin: .zero, size: newSize))
//           let newImage = UIGraphicsGetImageFromCurrentImageContext()
//           UIGraphicsEndImageContext()
//
//           return newImage!
//       }
//   }
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }

        // Configure cell with icons for the entire row
        func configureRow(withIcons icons: [String]) {
            // Ensure the icons array has 4 elements (Breakfast, Lunch, Snacks, Dinner)
            guard icons.count == 4 else { return }
            setButtonImage(button: Breakfastbutton, iconName: icons[0])
            setButtonImage(button: LunchButton, iconName: icons[1])
            setButtonImage(button: SnacksButton, iconName: icons[2])
            setButtonImage(button: DinnerButton, iconName: icons[3])
        }

        private func setButtonImage(button: UIButton, iconName: String) {
            if let image = UIImage(named: iconName) {
                let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 45, height: 45))
                button.setImage(resizedImage, for: .normal)
                button.imageView?.contentMode = .scaleAspectFit
            }
            button.setTitle(nil, for: .normal) // Remove default button title
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

            return newImage!
        }
    }
