//
//  MyTextField.swift
//  DollCatch
//
//  Created by allen on 2021/9/2.
//

import UIKit
protocol MyTextFieldDelegate: class {
    func textFieldDidDelete()
}

class MyTextField: UITextField {

    weak var myDelegate: MyTextFieldDelegate? // make sure to declare this as weak to prevent a memory leak/retain cycle

        override func deleteBackward() {
            super.deleteBackward()
            myDelegate?.textFieldDidDelete()
        }

        // when a char is inside the textField this keeps the cursor to the right of it. If the user can get on the left side of the char and press the backspace the current char won't get deleted
        override func closestPosition(to point: CGPoint) -> UITextPosition? {
            let beginning = self.beginningOfDocument
            let end = self.position(from: beginning, offset: self.text?.count ?? 0)
            return end
        }
}
