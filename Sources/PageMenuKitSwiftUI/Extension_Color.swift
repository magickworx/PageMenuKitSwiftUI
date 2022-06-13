/*****************************************************************************
 *
 * FILE:	Extension_Color.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Color Extension Class Method to Convert Hex
 * DATE:	Tue, Jun  7 2022
 * UPDATED:	Tue, Jun  7 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 *
 *****************************************************************************/

import SwiftUI

extension Color
{
  // ex.: Color.hexColor(0xffeeff)
  public static func hexColor(_ hex: UInt32, alpha: Double = 1.0) -> Color {
    let   red: Double = Double((hex & 0xff0000) >> 16) / 255.0
    let green: Double = Double((hex &   0xff00) >>  8) / 255.0
    let  blue: Double = Double((hex &     0xff)) / 255.0
    return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
  }

  // ex.: Color.hexColor(named: "#ffeeff")
  public static func hexColor(named hexStr: String, alpha: Double = 1.0) -> Color {
    let str = hexStr.replacingOccurrences(of: "#", with: "")
    let scanner = Scanner(string: str)
    var hex: UInt64 = 0
    if scanner.scanHexInt64(&hex) {
      let   red: Double = Double((hex & 0xff0000) >> 16) / 255.0
      let green: Double = Double((hex &   0xff00) >>  8) / 255.0
      let  blue: Double = Double((hex &     0xff)) / 255.0
      return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
    return .white
  }
}
