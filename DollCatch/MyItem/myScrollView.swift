//
//  myScrollView.swift
//  DollCatch
//
//  Created by allen on 2021/10/5.
//

import UIKit

class myScrollView: UIScrollView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
           for subview in subviews {
               if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                   return true
               }
           }
           return false
       }


}
