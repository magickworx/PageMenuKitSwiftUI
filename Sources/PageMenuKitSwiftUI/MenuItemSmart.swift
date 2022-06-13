/*
 * FILE:	MenuItemSmart.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Menu Item for SmartNews Style
 * DATE:	Tue, Jun  7 2022
 * UPDATED:	Fri, Jun 10 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 */

import SwiftUI

struct MenuItemSmart<Menu>: PMKMenuItem where Menu: PMKMenu
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
        .foregroundColor(titleColor)
        .padding(.horizontal, kItemTextPadding)
    }
    .frame(minWidth: kMenuItemWidth, minHeight: kMenuItemHeight)
    .frame(height: isSelected ? kMenuItemHeight + 10 : kMenuItemHeight)
    .cornerRadius(5, corners: [ .topLeft, .topRight ])
    .onTapGesture {
      self.helper.menuBorder = borderColor
      self.helper.selected = menu
    }
    .onAppear {
      if isSelected {
        self.helper.menuBorder = borderColor
      }
    }
  }
}

// MARK: - Equatable
extension MenuItemSmart
{
  static func == (lhs: MenuItemSmart<Menu>, rhs: MenuItemSmart<Menu>) -> Bool {
    return lhs.id == rhs.id
  }
}

// MARK: - PMKMenuAppearance
extension MenuItemSmart
{
  var titleColor: Color { return .white }
  var borderColor: Color { return backgroundColor }

  var backgroundColor: Color {
    return menuColor(at: menu.index)
  }

  var menuColors: [Color] {
    if customAppearance.isAvailable, !customAppearance.configuration.menuColors.isEmpty {
      return customAppearance.configuration.menuColors
    }
    return basicColors
  }
}

// MARK: - Preview
struct MenuItemSmart_Previews: PreviewProvider
{
  @ObservedObject static var helper: PageMenuHelper<TestMenu> = .init(selected: .june)

  static let items = TestMenu.allCases.map({ MenuItemSmart<TestMenu>(menu: $0, helper: helper) })

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
