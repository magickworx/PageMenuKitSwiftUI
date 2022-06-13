/*
 * FILE:	MenuItemPlain.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Menu Item for Plain Style
 * DATE:	Fri, Jun  3 2022
 * UPDATED:	Sat, Jun 11 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 */

import SwiftUI

struct MenuItemPlain<Menu>: PMKMenuItem where Menu: PMKMenu
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
      backgroundColor
      Text(title)
        .foregroundColor(isSelected ? titleColor : .gray)
        .padding(.horizontal, kItemTextPadding)
    }
    .frame(minWidth: kMenuItemWidth, minHeight: kMenuItemHeight)
    .frame(height: kMenuItemHeight)
    .border(width: isSelected ? 4 : 1, edges: [.bottom], color: borderColor)
    .onTapGesture {
      self.helper.selected = menu
    }
  }
}

// MARK: - Equatable
extension MenuItemPlain
{
  static func == (lhs: MenuItemPlain<Menu>, rhs: MenuItemPlain<Menu>) -> Bool {
    return lhs.id == rhs.id
  }
}

// MARK: - PMKMenuAppearance
extension MenuItemPlain
{
  var tintColor: Color {
    if customAppearance.isAvailable {
      return customAppearance.configuration.tintColor
    }
    return .orange
  }
  var titleColor: Color { return tintColor }
  var borderColor: Color { return tintColor }

  var backgroundColor: Color {
    return .white
  }
}

// MARK: - Preview
struct MenuItemPlain_Previews: PreviewProvider
{
  @ObservedObject static var helper: PageMenuHelper<TestMenu> = .init(selected: .june)

  static let items = TestMenu.allCases.map({ MenuItemPlain<TestMenu>(menu: $0, helper: helper) })

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
