//
//  DNButoon.swift
//  Egg Timer
//
//  Created by Daniel on 10.07.2022.
//

import Foundation
import UIKit

class DNButton: UIButton {
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init (title: String){
        self.init()
        setTitle(title, for: .normal)
        layer.cornerRadius = 16
        titleLabel?.font = .boldSystemFont(ofSize: 30)
        setTitleColor(UIColor(named: "colorText"), for: .normal)
        sizeToFit()

    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
