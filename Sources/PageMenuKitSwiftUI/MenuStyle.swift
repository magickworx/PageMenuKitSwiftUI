/*****************************************************************************
 *
 * FILE:	MenuStyle.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Page Menu Style for MenuItem
 * DATE:	Thu, Jun  2 2022
 * UPDATED:	Sat, Jun 11 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 *
 *****************************************************************************/

import SwiftUI

let kHackaItemMargin: CGFloat = 2.0

public enum PMKMenuStyle
{
  case plain   // NewsPass  [https://itunes.apple.com/jp/app/id1106788059]
  case tab     // Gunosy    [https://itunes.apple.com/jp/app/id590384791]
  case smart   // SmartNews [https://itunes.apple.com/jp/app/id579581125]
  case hacka   // Hackadoll [https://itunes.apple.com/jp/app/id888231424]
  case ellipse // JCNews    [https://itunes.apple.com/jp/app/id1024341813]
  case web     // JCNewsa   [https://jcnews.tokyo/]
  case suite   // NewsSuite [https://itunes.apple.com/jp/app/id1176431318]
  case netlab  // NLab      [https://itunes.apple.com/jp/app/id949325541]
  case nhk     // NHK NEWS  [https://itunes.apple.com/jp/app/id1121104608]

  var margin: CGFloat { // メニュー間のすき間
    switch self {
      case .hacka: return kHackaItemMargin
      default: return 0.0
    }
  }
}

// MARK: - Default Bottom Border Color and Width of Menu
extension PMKMenuStyle
{
  var bottomBorderWidth: CGFloat {
    switch self {
      case .plain: return 1
      case .hacka, .nhk: return 2
      case .tab, .smart, .web: return 4
      default: return 0
    }
  }

  // XXX: 'menuColor' is the color of the selected menu.
  // The 'smart' and 'tab' style use it.
  func bottomBorderColor(menuColor: Color) -> Color {
    switch self {
      case .plain, .web: return .orange
      case .tab, .smart: return menuColor
      case .nhk: return .hexColor(kNHKNewsHexColor)
      case .hacka: return .hexColor(kHackaHexColor)
      default: return .clear
    }
  }
}

extension PMKMenuStyle: CustomStringConvertible
{
  public var description: String {
    switch self {
      case .plain:   return "Plain"
      case .tab:     return "Tab"
      case .smart:   return "Smart"
      case .hacka:   return "Hacka"
      case .ellipse: return "Ellipse"
      case .web:     return "Web"
      case .suite:   return "Suite"
      case .netlab:  return "Netlab"
      case .nhk:     return "NHK"
    }
  }
}

// MARK: - Menu Item Appearance
protocol PMKMenuAppearance
{
  var tintColor: Color { get } // メニューの基本色
  var titleColor: Color { get }
  var borderColor: Color { get } // メニュー枠の色
  var backgroundColor: Color { get }

  var menuColors: [Color] { get }
  func menuColor(at index: Int) -> Color
}

// MARK: - Defaults
extension PMKMenuAppearance
{
  var tintColor: Color { return .black } // メニューの基本色
  var titleColor: Color { return .black }
  var borderColor: Color { return .gray } // メニュー枠の色
  var backgroundColor: Color { return .white }

  var menuColors: [Color] {
    return basicColors
  }

  func menuColor(at index: Int) -> Color {
    let n = menuColors.count
    let v = index
    let i = (v < 0 ? -v : v) % n
    return menuColors[i]
  }

  var pastelColors: [Color] {
    return [
      .hexColor(0xff7f7f),
      .hexColor(0xff7fbf),
      .hexColor(0xff7fff),
      .hexColor(0xbf7fff),
      .hexColor(0x7f7fff),
      .hexColor(0x7fbfff),
      .hexColor(0x7fffff),
      .hexColor(0x7fffbf),
      .hexColor(0x7fff7f),
      .hexColor(0xbfff7f),
      .hexColor(0xffff7f),
      .hexColor(0xffbf7f),
    ]
  }

  var basicColors: [Color] {
    return [
      .hexColor(0xff7f7f),
      .hexColor(0xbf7fff),
      .hexColor(0x7f7fff),
      .hexColor(0x7fbfff),
      .hexColor(0x7fff7f),
      .hexColor(0xffbf7f),
    ]
  }
}
