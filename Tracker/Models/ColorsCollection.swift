//
//  ColorCollection.swift
//  Tracker
//
//  Created by Алексей Тиньков on 21.08.2023.
//

import UIKit

var colorsCollection: [UIColor] = {
    var colors: [UIColor] = []
    for i in 1...18 {
        let color = UIColor(named: "YP Color selection \(i)") ?? .clear
        colors.append(UIColor(cgColor: color.cgColor))
    }
    return colors
}()
