//
//  CheckBox.swift
//  ios-itmo-2022-assignment2
//
//  Created by mac on 02.11.2022.
//

import UIKit

class CheckBoxStar: UIButton {
    
    private let btnImageOff = UIImage(named: "Star.png")
    private let btnImageOn = UIImage(named: "Star-2.png")
    
    override func awakeFromNib() {
        self.setImage(btnImageOn, for: .selected)
        self.setImage(btnImageOff, for: .normal)
        self.addTarget(self, action: #selector(CheckBoxStar.starClicked(_:)), for: .touchUpInside)
    }

    @objc func starClicked(_ sender: UIButton) {
        self.isSelected = !self.isSelected
    }
}
