//
//  CustomiseTableTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

//protocol CustomiseTableDelegate: AnyObject {
//    func buttonClicked(withTag tag: Int)
//}
protocol CustomiseTableDelegate: AnyObject {
    func buttonClicked(inSection section: Int, withTag tag: Int)
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
           self.selectionStyle = .none
       }
       // Tracks button visibility states
       private var buttonStates: [Bool] = [true, true, true, true]

       func configureRow(withIcons icons: [String]) {
           updateButtonAppearance()
           setButtonImage(button: Breakfastbutton, iconName: icons[0])
           setButtonImage(button: LunchButton, iconName: icons[1])
           setButtonImage(button: SnacksButton, iconName: icons[2])
           setButtonImage(button: DinnerButton, iconName: icons[3])
       }

       private func updateButtonAppearance() {
           Breakfastbutton.alpha = buttonStates[0] ? 1.0 : 0.1
           LunchButton.alpha = buttonStates[1] ? 1.0 : 0.1
           SnacksButton.alpha = buttonStates[2] ? 1.0 : 0.1
           DinnerButton.alpha = buttonStates[3] ? 1.0 : 0.1
       }

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
         
            guard let tableView = self.superview as? UITableView,
                  let indexPath = tableView.indexPath(for: self) else {
                return
            }

            let section = indexPath.section
            print("Button clicked in section: \(section), Tag: \(sender.tag)")
            
            delegate?.buttonClicked(inSection: section, withTag: sender.tag)

            switch sender {
            case Breakfastbutton:
                buttonStates[0].toggle()
            case LunchButton:
                buttonStates[1].toggle()
            case SnacksButton:
                buttonStates[2].toggle()
            case DinnerButton:
                buttonStates[3].toggle()
            default:
                print("Unknown button clicked")
                return
            }

            updateButtonAppearance()
            print("Button visibility toggled")
          }

          private func resetButtonStates() {
              buttonStates = [true, true, true, true]
              updateButtonAppearance()
          }

          override func prepareForReuse() {
              super.prepareForReuse()
              resetButtonStates()
          }
      }
