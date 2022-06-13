/*
 * FILE:	EdgeBorder.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Add Border to Any Edges
 * DATE:	Sat, Jun  4 2022
 * UPDATED:	Thu, Jun  9 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 */

import SwiftUI

/*
 * swift - SwiftUI - Add Border to One Edge of an Image - Stack Overflow
 * https://stackoverflow.com/questions/58632188/swiftui-add-border-to-one-edge-of-an-image
 *
 * How to use:
 *  .border(width: 5, edges: [.top, .leading], color: .yellow)
 */
extension View
{
  func border(width: CGFloat, edges: [Edge] = [.top, .bottom, .leading, .trailing], color: Color) -> some View {
    overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
  }
}

struct EdgeBorder: Shape
{
  var width: CGFloat
  var edges: [Edge]

  func path(in rect: CGRect) -> Path {
    var path = Path()
    for edge in edges {
      var x: CGFloat {
        switch edge {
          case .top, .bottom, .leading: return rect.minX
          case .trailing: return rect.maxX - width
        }
      }

      var y: CGFloat {
        switch edge {
          case .top, .leading, .trailing: return rect.minY
          case .bottom: return rect.maxY - width
        }
      }

      var w: CGFloat {
        switch edge {
          case .top, .bottom: return rect.width
          case .leading, .trailing: return self.width
        }
      }

      var h: CGFloat {
        switch edge {
          case .top, .bottom: return self.width
          case .leading, .trailing: return rect.height
        }
      }
      path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
    }
    return path
  }
}
