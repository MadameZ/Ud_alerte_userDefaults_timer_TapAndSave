//
//  TapButton.swift
//  alerte_userDefaults_timer_TapAndSave
//
//  Created by Caroline Zaini on 09/06/2020.
//  Copyright © 2020 Caroline Zaini. All rights reserved.
//

import UIKit

class TapButton: UIButton {

    func setup(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 4
        backgroundColor = .systemRed
        tintColor = .white
    }

}
