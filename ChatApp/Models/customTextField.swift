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
        textColor = .black
        self.placeholder = placeholder
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

