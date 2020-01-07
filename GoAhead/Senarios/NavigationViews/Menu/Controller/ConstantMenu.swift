//
//  Constant.swift
//  TestSideText
//
//  Created by Mustafa on 12/11/19.
//  Copyright © 2019 Mostafa. All rights reserved.
//

import Foundation
import SideMenu


struct ConstantMenu {
       
}

class SharedMenu {
    
    static func settings(view: UIView) -> SideMenuSettings {
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.backgroundColor = .white
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
         settings.menuWidth = view.frame.width-view.frame.width*(1/5)
        settings.statusBarEndAlpha = 0
        return settings
    }

   
    
    
}
