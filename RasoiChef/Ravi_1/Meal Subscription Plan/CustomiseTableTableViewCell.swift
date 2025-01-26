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
    
    @IBOutlet var dayLabel: UILabel!
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
//    override func setSelected(_ selected: Bool, animated: Bool) {
//            super.setSelected(selected, animated: animated)
//        }
//
//    func configure(dayMeals: [String]) {
//           Breakfastbutton.setTitle(dayMeals[0], for: .normal)
//           LunchButton.setTitle(dayMeals[1], for: .normal)
//           SnacksButton.setTitle(dayMeals[2], for: .normal)
//           DinnerButton.setTitle(dayMeals[3], for: .normal)
//       }
//
//        private func setButtonImage(button: UIButton, iconName: String) {
//            if let image = UIImage(named: iconName) {
//                let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 45, height: 45))
//                button.setImage(resizedImage, for: .normal)
//                button.imageView?.contentMode = .scaleAspectFit
//            }
//            button.setTitle(nil, for: .normal) // Remove default button title
//        }
//
//        private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//            let size = image.size
//            let widthRatio = targetSize.width / size.width
//            let heightRatio = targetSize.height / size.height
//            let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
//
//            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//            image.draw(in: CGRect(origin: .zero, size: newSize))
//            let newImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//
//            return newImage!
//    
//
//    }
    // Callback to handle button taps
//       var buttonAction: ((UIButton) -> Void)?
//
//       override func awakeFromNib() {
//           super.awakeFromNib()
//
//           // Configure button appearance
//           configureButton(Breakfastbutton)
//           configureButton(LunchButton)
//           configureButton(SnacksButton)
//           configureButton(DinnerButton)
//
//           // Attach actions to buttons
//           Breakfastbutton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//           LunchButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//           SnacksButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//           DinnerButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//       }
//
//       // Configure button style
//       private func configureButton(_ button: UIButton) {
//           button.layer.cornerRadius = 8
//           button.layer.borderWidth = 1
//           button.layer.borderColor = UIColor.lightGray.cgColor
//           button.clipsToBounds = true
//           button.setTitleColor(.darkGray, for: .normal)
//       }
//
//       // Button tap handler
//       @objc func buttonTapped(_ sender: UIButton) {
//           buttonAction?(sender) // Trigger the callback when a button is tapped
//       }
//
//       // Update cell with dynamic data
//       func configure(day: String, meals: [String?]) {
//           dayLabel.text = day
//
//           // Update button visibility and titles
//           updateButton(Breakfastbutton, with: meals[0])
//           updateButton(LunchButton, with: meals[1])
//           updateButton(SnacksButton, with: meals[2])
//           updateButton(DinnerButton, with: meals[3])
//       }
//
//       private func updateButton(_ button: UIButton, with title: String?) {
//           if let title = title {
//               button.setTitle(title, for: .normal)
//               button.isHidden = false
//           } else {
//               button.isHidden = true
//           }
//       }
//   }
//    var buttonAction: ((UIButton) -> Void)?
//
//       override func awakeFromNib() {
//           super.awakeFromNib()
//
//           // Configure button appearance
//           configureButton(Breakfastbutton)
//           configureButton(LunchButton)
//           configureButton(SnacksButton)
//           configureButton(DinnerButton)
//
//           // Attach actions to buttons
//           Breakfastbutton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//           LunchButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//           SnacksButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//           DinnerButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//       }
//
//       // Configure button style
//       private func configureButton(_ button: UIButton) {
//           button.layer.cornerRadius = 8
//           button.layer.borderWidth = 1
//           button.layer.borderColor = UIColor.lightGray.cgColor
//           button.clipsToBounds = true
//           button.setTitleColor(.darkGray, for: .normal)
//       }
//
//       // Button tap handler
//       @objc func buttonTapped(_ sender: UIButton) {
//           buttonAction?(sender) // Trigger the callback when a button is tapped
//       }
//
//       // Update cell with dynamic data
//       func configure(day: String, meals: [String?]) {
//           dayLabel.text = day
//
//           // Update button visibility and titles
//           updateButton(Breakfastbutton, with: meals[0])
//           updateButton(LunchButton, with: meals[1])
//           updateButton(SnacksButton, with: meals[2])
//           updateButton(DinnerButton, with: meals[3])
//       }
//
//       private func updateButton(_ button: UIButton, with title: String?) {
//           if let title = title {
//               button.setTitle(title, for: .normal)
//               button.isHidden = false
//           } else {
//               button.isHidden = true
//           }
//       }
//   }
//    override func awakeFromNib() {
//            super.awakeFromNib()
//            // Additional configuration if needed
//        }
//
//        func configureRow(withIcons icons: [String]) {
//            // Ensure the icons array has 4 elements (Breakfast, Lunch, Snacks, Dinner)
//            guard icons.count == 4 else { return }
//            setButtonImage(button: Breakfastbutton, iconName: icons[0])
//            setButtonImage(button: LunchButton, iconName: icons[1])
//            setButtonImage(button: SnacksButton, iconName: icons[2])
//            setButtonImage(button: DinnerButton, iconName: icons[3])
//        }
//
//        private func setButtonImage(button: UIButton, iconName: String) {
//            guard let image = UIImage(named: iconName) else {
//                print("Error: Image \(iconName) not found.")
//                button.setImage(nil, for: .normal)
//                return
//            }
//            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 45, height: 45))
//            button.setImage(resizedImage, for: .normal)
//            button.imageView?.contentMode = .scaleAspectFit
//            button.setTitle(nil, for: .normal) // Remove default button title
//        }
//
//        private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//            let size = image.size
//            let widthRatio = targetSize.width / size.width
//            let heightRatio = targetSize.height / size.height
//            let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
//
//            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//            image.draw(in: CGRect(origin: .zero, size: newSize))
//            let newImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//
//            return newImage ?? image // Return original image if resizing fails
//        }
//    @IBAction func buttonClicked(_ sender: UIButton) {
//           sender.isHidden = true // Hide the button
//       }
//    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    // Configure the row with images
//    func configureRow(withIcons icons: [String]) {
//        guard icons.count == 4 else { return }
//        setButtonImage(button: Breakfastbutton, iconName: icons[0])
//        setButtonImage(button: LunchButton, iconName: icons[1])
//        setButtonImage(button: SnacksButton, iconName: icons[2])
//        setButtonImage(button: DinnerButton, iconName: icons[3])
//    }
//
//    private func setButtonImage(button: UIButton, iconName: String) {
//        guard let image = UIImage(named: iconName) else {
//            print("Error: Image \(iconName) not found.")
//            button.setImage(nil, for: .normal)
//            return
//        }
//        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 35, height: 35))
//        button.setImage(resizedImage, for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.setTitle(nil, for: .normal)
//    }
//
//    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//        let size = image.size
//        let widthRatio = targetSize.width / size.width
//        let heightRatio = targetSize.height / size.height
//        let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
//
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//        image.draw(in: CGRect(origin: .zero, size: newSize))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage ?? image
//    }
//
//    // IBAction for button clicks
//    @IBAction func buttonClicked(_ sender: UIButton) {
//        sender.isHidden = true // Hide the button
//    }
//}
    // Maintain the hidden states of buttons for reusability
       private var buttonStates: [Bool] = [true, true, true, true]

       override func awakeFromNib() {
           super.awakeFromNib()
           resetButtonStates()
       }

       func configureRow(withIcons icons: [String]) {
           guard icons.count == 4 else { return }

           // Update button visibility based on states
           Breakfastbutton.isHidden = !buttonStates[0]
           LunchButton.isHidden = !buttonStates[1]
           SnacksButton.isHidden = !buttonStates[2]
           DinnerButton.isHidden = !buttonStates[3]

           setButtonImage(button: Breakfastbutton, iconName: icons[0])
           setButtonImage(button: LunchButton, iconName: icons[1])
           setButtonImage(button: SnacksButton, iconName: icons[2])
           setButtonImage(button: DinnerButton, iconName: icons[3])
       }

       private func setButtonImage(button: UIButton, iconName: String) {
           guard let image = UIImage(named: iconName) else {
               print("Error: Image \(iconName) not found.")
               button.setImage(nil, for: .normal)
               return
           }
           button.setImage(resizeImage(image: image, targetSize: CGSize(width: 45, height: 45)), for: .normal)
           button.imageView?.contentMode = .scaleAspectFit
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

           return newImage ?? image
       }

       @IBAction func buttonClicked(_ sender: UIButton) {
           switch sender {
           case Breakfastbutton:
               buttonStates[0] = false
           case LunchButton:
               buttonStates[1] = false
           case SnacksButton:
               buttonStates[2] = false
           case DinnerButton:
               buttonStates[3] = false
           default:
               return
           }

           sender.isHidden = true // Hide the button
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
