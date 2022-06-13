/*
 * FILE:	MenuItemSuite.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Menu Item for Gradient Background Style
 * DATE:	Wed, Jun  8 2022
 * UPDATED:	Fri, Jun 10 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 */

import SwiftUI

struct MenuItemSuite<Menu>: PMKMenuItem where Menu: PMKMenu
{
  typealias Helper = PageMenuHelper<Menu>

  let id: String = UUID().uuidString // to use "ForEach"

  let title: String
  let menu: Menu

  var isSelected: Bool {
    return helper.selected == menu
  }

  @ObservedObject private var helper: Helper

  @EnvironmentObject var customAppearance: CustomAppearance

  init(title: String, menu: Menu, helper: Helper) {
    self.title = title
    self.menu = menu
    self.helper = helper
  }

  init(menu: Menu, helper: Helper) {
    self.init(title: menu.title, menu: menu, helper: helper)
  }

  @ViewBuilder
  var body: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom)
      Text(title)
        .foregroundColor(isSelected ? titleColor : .gray)
        .padding(.horizontal, kItemTextPadding)
    }
    .frame(minWidth: kMenuItemWidth, minHeight: kMenuItemHeight)
    .frame(height: kMenuItemHeight)
    .border(width: isSelected ? 4 : 0, edges: [.bottom], color: borderColor)
    .onTapGesture {
      self.helper.selected = menu
    }
  }
}

// MARK: - Equatable
extension MenuItemSuite
{
  static func == (lhs: MenuItemSuite<Menu>, rhs: MenuItemSuite<Menu>) -> Bool {
    return lhs.id == rhs.id
  }
}

// MARK: - PMKMenuAppearance
extension MenuItemSuite
{
  var tintColor: Color {
    if customAppearance.isAvailable {
      return customAppearance.configuration.tintColor
    }
    return .hexColor(0x7ab7cc)
  }
  var titleColor: Color { return .white }
  var borderColor: Color { return tintColor }

  var gradientColors: [Color] {
    if customAppearance.isAvailable {
      return customAppearance.configuration.backgroundColor.gradient
    }
    return [.hexColor(0x445a66), .hexColor(0x677983)]
  }
}

// MARK: - Preview
struct MenuItemSuite_Previews: PreviewProvider
{
  @ObservedObject static var helper: PageMenuHelper<TestMenu> = .init(selected: .june)

  static let items = TestMenu.allCases.map({ MenuItemSuite<TestMenu>(menu: $0, helper: helper) })

  static var previews: some View {
    VStack(spacing: 0) {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .bottom, spacing: 0) {
          ForEach(items) { item in
            item
          }
        }
      }
      GeometryReader { geometry in
        Rectangle()
          .foregroundColor(.indigo)
          .frame(width: geometry.size.width, height: geometry.size.height)
      }
    }
  }
}
