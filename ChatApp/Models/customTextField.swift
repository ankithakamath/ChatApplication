//
//  customTextField.swift
//  Customcell
//
//  Created by Ankitha Kamath on 11/11/21.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        font = UIFont.systemFont(ofSize: 16)
        self.placeholder = placeholder
        textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

