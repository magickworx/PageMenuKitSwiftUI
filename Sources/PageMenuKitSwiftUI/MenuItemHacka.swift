/*
 * FILE:	MenuItemHacka.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Menu Item for Hacka-dolls Style
 * DATE:	Thu, Jun  9 2022
 * UPDATED:	Sat, Jun 11 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 */

import SwiftUI
import Combine

struct MenuItemHacka<Menu>: PMKMenuItem where Menu: PMKMenu
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

  private let publisher: PassthroughSubject<Int,Never> = .init()
  @State var badgeValue: Int = 0

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
    .border(width: isSelected ? 0 : 2, edges: [.top, .leading, .trailing], color: borderColor)
    .padding(.horizontal, kHackaItemMargin)
    .overlay(alignment: .topTrailing) {
      showBadge()
    }
    .onReceive(publisher) { value in
      self.badgeValue = value
    }
    .onTapGesture {
      self.helper.selected = menu
    }
  }
}

// MARK: - Badge
extension MenuItemHacka
{
  @ViewBuilder
  private func showBadge() -> some View {
    Group {
      if !isSelected, badgeValue > 0 {
        ZStack(alignment: .center) {
          Group {
            switch badgeValue {
              case 1..<100:
                Circle().frame(width: 20, height: 20)
              default:
                RoundedRectangle(cornerRadius: 8)
                  .frame(maxWidth: 40, maxHeight: 20)
            }
          }
          .foregroundColor(.red)
          Text(String(badgeValue))
            .font(.footnote)
            .foregroundColor(.white)
        }
        .offset(x: -10, y: -10)
      }
    }
  }

  public func badge(_ value: Int) -> Self {
    publisher.send(value)
    return self
  }
}

// MARK: - Equatable
extension MenuItemHacka
{
  static func == (lhs: MenuItemHacka<Menu>, rhs: MenuItemHacka<Menu>) -> Bool {
    return lhs.id == rhs.id
  }
}

// MARK: - PMKMenuAppearance
extension MenuItemHacka
{
  var tintColor: Color {
    if customAppearance.isAvailable {
      return customAppearance.configuration.tintColor
    }
    return .hexColor(kHackaHexColor)
  }

  var titleColor: Color {
    return isSelected ? .white : tintColor
  }

  var borderColor: Color { return tintColor }

  var backgroundColor: Color {
    return isSelected ? tintColor : .white
  }
}

// MARK: - Preview
struct MenuItemHacka_Previews: PreviewProvider
{
  @ObservedObject static var helper: PageMenuHelper<TestMenu> = .init(selected: .june)

  @StateObject static var customAppearance: CustomAppearance = .init(false, configuration: PMKColorConfiguration())

  static let items = TestMenu.allCases.map({ MenuItemHacka<TestMenu>(menu: $0, helper: helper) })

  static var previews: some View {
    VStack(spacing: 0) {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .bottom, spacing: 0) {
          ForEach(items) { item in
            item.badge(10)
              .environmentObject(customAppearance)
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
