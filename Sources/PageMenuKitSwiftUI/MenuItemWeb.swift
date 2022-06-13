/*
 * FILE:	MenuItemWeb.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Menu Item like JCNews Web
 * DATE:	Thu, Jun  9 2022
 * UPDATED:	Fri, Jun 10 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 */

import SwiftUI

struct MenuItemWeb<Menu>: PMKMenuItem where Menu: PMKMenu
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
    .frame(height: kMenuItemHeight)
    .onTapGesture {
      self.helper.selected = menu
    }
  }
}

// MARK: - Equatable
extension MenuItemWeb
{
  static func == (lhs: MenuItemWeb<Menu>, rhs: MenuItemWeb<Menu>) -> Bool {
    return lhs.id == rhs.id
  }
}

// MARK: - PMKMenuAppearance
extension MenuItemWeb
{
  var tintColor: Color {
    if customAppearance.isAvailable {
      return customAppearance.configuration.tintColor
    }
    return .hexColor(0xffbf7f)
  }

  var titleColor: Color {
    return isSelected ? .white : tintColor
  }

  var borderColor: Color {
    if customAppearance.isAvailable {
      return customAppearance.configuration.borderColor
    }
    return .orange
  }

  var backgroundColor: Color {
    if customAppearance.isAvailable {
      return isSelected ? tintColor : customAppearance.configuration.backgroundColor.inactive
    }
    return isSelected ? tintColor : .hexColor(0x332f2e)
  }
}

// MARK: - Preview
struct MenuItemWeb_Previews: PreviewProvider
{
  @ObservedObject static var helper: PageMenuHelper<TestMenu> = .init(selected: .june)

  static let items = TestMenu.allCases.map({ MenuItemWeb<TestMenu>(menu: $0, helper: helper) })

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
