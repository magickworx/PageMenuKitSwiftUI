/*
 * FILE:	PageMenuStack.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Page Menu Stack Container
 * DATE:	Sat, Jun  4 2022
 * UPDATED:	Sat, Jun 11 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 */

import SwiftUI

final class CustomAppearance: ObservableObject
{
  let isAvailable: Bool
  let configuration: PMKColorConfiguration

  init(_ flag: Bool, configuration: PMKColorConfiguration) {
    self.isAvailable = flag
    self.configuration = configuration
  }
}

public struct PMKPageMenuStack<Menu,Content>: View where Menu: PMKMenu, Content: View
{
  typealias Helper = PageMenuHelper<Menu>

  private let menus: [Menu]
  private let style: PMKMenuStyle
  private var items = [MenuItem<Menu>]()
  private let content: (Menu) -> Content

  @ObservedObject private var helper: Helper

  @StateObject private var customAppearance: CustomAppearance

  public init(_ menus: [Menu], style: PMKMenuStyle, selected: Menu, configuration: PMKColorConfiguration? = nil, @ViewBuilder content: @escaping (Menu) -> Content) {
    self._helper = ObservedObject(wrappedValue: Helper(selected: selected))
    self.menus = menus
    self.style = style
    self.content = content

    self._customAppearance = {
      let appearance: CustomAppearance = {
        if let configuration = configuration {
          return CustomAppearance(true, configuration: configuration)
        }
        return CustomAppearance(false, configuration: PMKColorConfiguration())
      }()
      return StateObject(wrappedValue: appearance)
    }()

    defer {
      self.items = menus.map({ MenuItem<Menu>(style: style, menu: $0, helper: helper) })
    }
  }

  @State private var contentOffset: CGPoint = .zero
  @State private var scrollViewProxy: ScrollViewProxy?
  @State private var scrollDirection: ScrollDirection = .unknown

  @ViewBuilder
  public var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        BetterScrollView(contentOffset: $contentOffset, scrollDirection: $scrollDirection) { proxy in
          HStack(alignment: .bottom, spacing: 0) {
            ForEach(items) { item in
              item.id(item.menu)
                .environmentObject(self.customAppearance)
            }
          }
          .onAppear {
            self.scrollViewProxy = proxy
          }
        }
        .onReceive(helper.publisher) { selected in
          self.scrollTo(helper.selected, geometry: geometry)
        }
        .border(width: style.bottomBorderWidth, edges: [.bottom], color: bottomBorderColor)
        .onAppear {
          UIScrollView.appearance().bounces = false
          self.scrollTo(helper.selected, geometry: geometry)
        }
        TabView(selection: $helper.selected) {
          ForEach(self.menus, id: \.self) { menu in
            content(menu).tag(menu)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
      }
    }
  }

  private func scrollTo(_ selected: Menu, geometry: GeometryProxy) {
    let w: CGFloat = kMenuItemWidth + style.margin
    let x: CGFloat = w * CGFloat(selected.index)

    let viewWidth: CGFloat = geometry.size.width
    let contentWidth: CGFloat = w * CGFloat(items.count)
    let  leftX: CGFloat = (viewWidth - w) * 0.5
    let   tabN: CGFloat = ceil(viewWidth / w) // 画面内に見えるタブの数
    let rightX: CGFloat = contentWidth - floor((tabN * 0.5 + 0.5) * w)

    let anchor: UnitPoint? = {
           if x < leftX  { return .leading }
      else if x > rightX { return .trailing }
      else               { return .center }
    }()
    withAnimation {
      self.scrollViewProxy?.scrollTo(selected, anchor: anchor)
    }
  }
}

extension PMKPageMenuStack
{
  private var bottomBorderColor: Color {
    if customAppearance.isAvailable {
      switch style {
        case .tab, .smart:
          return self.helper.menuBorder
        default:
          return customAppearance.configuration.borderColor
      }
    }
    return style.bottomBorderColor(menuColor: self.helper.menuBorder)
  }
}


// MARK: - Preview
enum TestMenu: Int, PMKMenu
{
  case january
  case february
  case march
  case april
  case may
  case june
  case july
  case august
  case september
  case october
  case november
  case december

  var index: Int {
    return rawValue
  }

  var title: String {
    switch self {
      case .january:   return "January"
      case .february:  return "February"
      case .march:     return "March"
      case .april:     return "April"
      case .may:       return "May"
      case .june:      return "June"
      case .july:      return "July"
      case .august:    return "August"
      case .september: return "September"
      case .october:   return "October"
      case .november:  return "November"
      case .december:  return "December"
    }
  }
}

struct PageMenuStack_Previews: PreviewProvider
{
  struct ContentView: View
  {
    @State private var style: PMKMenuStyle = .plain

    var body: some View {
      PMKPageMenuStack(TestMenu.allCases, style: style, selected: .june) {
        (menu) -> MenuContentView in
        MenuContentView(menu: menu)
      }
      .navigationTitle(style.description)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Menu {
            Button("Plain",   action: { style = .plain })
            Button("Tab",     action: { style = .tab })
            Button("Smart",   action: { style = .smart })
            Button("Hacka",   action: { style = .hacka })
            Button("Ellipse", action: { style = .ellipse })
            Button("Web",     action: { style = .web })
            Button("Suite",   action: { style = .suite })
            Button("Netlab",  action: { style = .netlab })
            Button("NHK",     action: { style = .nhk })
          } label: {
            Image(systemName: "ellipsis.circle")
          }
        }
      }
    }
  }

  struct MenuContentView: View
  {
    let menu: TestMenu

    var body: some View {
      GeometryReader { geometry in
        ZStack {
          Rectangle()
            .foregroundColor(.white)
            .frame(width: geometry.size.width, height: geometry.size.height)
          Text(menu.title)
            .font(.title)
        }
      }
    }
  }

  static var previews: some View {
    NavigationView {
      ContentView()
    }
  }
}
