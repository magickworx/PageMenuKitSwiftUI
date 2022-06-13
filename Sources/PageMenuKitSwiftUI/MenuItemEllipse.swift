/*
 * FILE:	MenuItemEllipse.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Menu Item for Ellipse Style
 * DATE:	Wed, Jun  8 2022
 * UPDATED:	Fri, Jun 10 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 */

import SwiftUI

struct MenuItemEllipse<Menu>: PMKMenuItem where Menu: PMKMenu
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
      menuTitle
    }
    .frame(minWidth: kMenuItemWidth, minHeight: kMenuItemHeight)
    .frame(height: kMenuItemHeight)
    .onTapGesture {
      self.helper.selected = menu
    }
  }

  @ViewBuilder
  private var menuTitle: some View {
    if isSelected {
      ZStack {
        RoundedRectangle(cornerRadius: 15)
          .frame(height: 30)
          .foregroundColor(.white)
        Text(title)
          .foregroundColor(titleColor)
          .padding(.horizontal, kItemTextPadding)
      }
    }
    else {
      Text(title)
        .padding(.horizontal, kItemTextPadding)
        .foregroundColor(titleColor)
    }
  }
}

// MARK: - Equatable
extension MenuItemEllipse
{
  static func == (lhs: MenuItemEllipse<Menu>, rhs: MenuItemEllipse<Menu>) -> Bool {
    return lhs.id == rhs.id
  }
}

// MARK: - PMKMenuAppearance
extension MenuItemEllipse
{
  var tintColor: Color {
    if customAppearance.isAvailable {
      return customAppearance.configuration.tintColor
    }
    return .hexColor(kJCNewsHexColor)
  }

  var titleColor: Color {
    return isSelected ? tintColor : .white
  }

  var backgroundColor: Color {
    return tintColor
  }
}

// MARK: - Preview
struct MenuItemEllipse_Previews: PreviewProvider
{
  @ObservedObject static var helper: PageMenuHelper<TestMenu> = .init(selected: .june)

  static let items = TestMenu.allCases.map({ MenuItemEllipse<TestMenu>(menu: $0, helper: helper) })

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
