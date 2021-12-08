//
//  Protocols.swift
//  CustomCell
//
//  Created by Anirudha SM on 22/11/21.
//

import Foundation

protocol UserAuthenticatedDelegate {
    func userAuthenticated()
}

protocol ChatSelectedDelegate {
    func chatSelected(isSelected: Bool)
}
