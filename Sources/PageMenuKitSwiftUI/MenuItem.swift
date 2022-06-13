/*
 * FILE:	MenuItem.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Representation Menu Item for PageMenuStack
 * DATE:	Thu, Jun  2 2022
 * UPDATED:	Fri, Jun 10 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 */

import SwiftUI

// MARK: - Essential Entity for Menu
public protocol PMKMenu: CaseIterable, Hashable
{
  var index: Int { get }
  var title: String { get }
}

// MARK: - Essential Entity for Item
protocol PMKItem: Hashable, Identifiable
{
  var id: String { get }
  var title: String { get }
}

// MARK: - Essential Entity for MenuItem
protocol PMKMenuItem: View, PMKItem, PMKMenuAppearance
{
  associatedtype Menu: PMKMenu

  var menu: Menu { get }
  var icon: Image? { get }
}

// MARK: - Defaults
extension PMKMenuItem
{
  var icon: Image? { return nil }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(title)
    hasher.combine(menu)
  }
}

// MARK: - Constants
let kMenuItemWidth: CGFloat = 90
let kMenuItemHeight: CGFloat = 40
let kMenuItemMargin: CGFloat = 10
let kSeparatorHeight: CGFloat = 2
let kItemTextPadding: CGFloat = 8

let   kHackaHexColor: UInt32 = 0x66cdaa
let  kJCNewsHexColor: UInt32 = 0x3fa9f5
let  kNetlabHexColor: UInt32 = 0x8e0c4e
let kNHKNewsHexColor: UInt32 = 0x0387d2


// MARK: - Representation "MenuItem"
struct MenuItem<Menu>: PMKMenuItem where Menu: PMKMenu
{
  typealias Helper = PageMenuHelper<Menu>

  let id: String = UUID().uuidString // to use "ForEach"

  private let style: PMKMenuStyle
  let title: String
  let menu: Menu
  @ObservedObject private var helper: Helper

  @EnvironmentObject var customAppearance: CustomAppearance

  init(style: PMKMenuStyle, title: String, menu: Menu, helper: Helper) {
    self.style = style
    self.title = title
    self.menu = menu
    self.helper = helper
  }

  init(style: PMKMenuStyle, menu: Menu, helper: Helper) {
    self.init(style: style, title: menu.title, menu: menu, helper: helper)
  }

  var body: some View {
    switch style {
      case .plain:
        MenuItemPlain<Menu>(title: title, menu: menu, helper: helper)
          .environmentObject(self.customAppearance)
      case .tab:
        MenuItemTab<Menu>(title: title, menu: menu, helper: helper)
          .environmentObject(self.customAppearance)
      case .smart:
        MenuItemSmart<Menu>(title: title, menu: menu, helper: helper)
          .environmentObject(self.customAppearance)
      case .hacka:
        MenuItemHacka<Menu>(title: title, menu: menu, helper: helper)
          .environmentObject(self.customAppearance)
      case .ellipse:
        MenuItemEllipse<Menu>(title: title, menu: menu, helper: helper)
          .environmentObject(self.customAppearance)
      case .web:
        MenuItemWeb<Menu>(title: title, menu: menu, helper: helper)
          .environmentObject(self.customAppearance)
      case .suite:
        MenuItemSuite<Menu>(title: title, menu: menu, helper: helper)
          .environmentObject(self.customAppearance)
      case .netlab:
        MenuItemNetlab<Menu>(title: title, menu: menu, helper: helper)
          .environmentObject(self.customAppearance)
      case .nhk:
        MenuItemNHK<Menu>(title: title, menu: menu, helper: helper)
          .environmentObject(self.customAppearance)
    }
  }
}

// MARK: - Equatable
extension MenuItem
{
  static func == (lhs: MenuItem<Menu>, rhs: MenuItem<Menu>) -> Bool {
    return lhs.id == rhs.id
  }
}

import Combine

// MARK: - Property Wrapper to Manage Selected Item
final class PageMenuHelper<Menu>: ObservableObject where Menu: PMKMenu
{
  let publisher: PassthroughSubject<Menu,Never> = .init()

  @Published var selected: Menu {
    willSet {
      publisher.send(selected)
    }
  }

  @Published var menuBorder: Color = .clear

  init(selected: Menu) {
    self.selected = selected
  }
}
