/*****************************************************************************
 *
 * FILE:	ColorConfiguration.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Custom Color for MenuItem
 * DATE:	Fri, Jun 10 2022
 * UPDATED:	Fri, Jun 10 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 *
 *****************************************************************************/

import SwiftUI

public struct PMKColorConfiguration
{
  struct BackgroundColor
  {
    var active: Color = .clear
    var inactive: Color = .white
    var gradient: [Color] = [.hexColor(0x445a66), .hexColor(0x677983)]
  }
  let tintColor: Color
  let borderColor: Color
  var backgroundColor: BackgroundColor = .init()
  var menuColors: [Color] = [] // Empty: uses framework defaults

  // MARK: - Initializer for plain, hacka, ellipse, nhk
  public init(tintColor: Color) {
    self.tintColor = tintColor
    self.borderColor = tintColor
  }

  // MARK: - Initializer for netlab
  init(tintColor: Color, activeBackgroundColor: Color) {
    self.tintColor = tintColor
    self.borderColor = tintColor
    self.backgroundColor.active = activeBackgroundColor
  }

  // MARK: - Initializer for tab, smart
  public init(menuColors: [Color]) {
    self.tintColor = .white
    self.borderColor = .clear
    self.menuColors = menuColors
  }

  // MARK: - Initializer for web
  init(tintColor: Color, borderColor: Color, inactiveBackgroundColor: Color) {
    self.tintColor = tintColor
    self.borderColor = borderColor
    self.backgroundColor.inactive = inactiveBackgroundColor
  }

  // MARK: - Initializer for suite
  init(tintColor: Color, gradient: [Color]) {
    self.tintColor = tintColor
    self.borderColor = tintColor
    self.backgroundColor.gradient = gradient
  }

  // MARK: - System Local Initializer
  init() {
    self.tintColor = .black
    self.borderColor = .gray
  }
}

// MARK: - Convenience Methods
extension PMKColorConfiguration
{
  public static func plain(tintColor: Color) -> Self {
    return .init(tintColor: tintColor)
  }

  public static func hacka(tintColor: Color) -> Self {
    return .init(tintColor: tintColor)
  }

  public static func ellipse(tintColor: Color) -> Self {
    return .init(tintColor: tintColor)
  }

  public static func nhk(tintColor: Color) -> Self {
    return .init(tintColor: tintColor)
  }

  public static func tab(menuColors: [Color]) -> Self {
    return .init(menuColors: menuColors)
  }

  public static func smart(menuColors: [Color]) -> Self {
    return .init(menuColors: menuColors)
  }

  public static func netlab(tintColor: Color, activeBackgroundColor: Color) -> Self {
    return .init(tintColor: tintColor, activeBackgroundColor: activeBackgroundColor)
  }

  public static func suite(tintColor: Color, gradient: [Color]) -> Self {
    return .init(tintColor: tintColor, gradient: gradient)
  }

  public static func web(tintColor: Color, borderColor: Color, inactiveBackgroundColor: Color) -> Self {
    return .init(tintColor: tintColor, borderColor: borderColor, inactiveBackgroundColor: inactiveBackgroundColor)
  }
}
