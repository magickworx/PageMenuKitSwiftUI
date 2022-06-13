/*
 * FILE:	RoundedCorner.swift
 * DESCRIPTION:	PageMenuKitSwiftUI: Add Rounded Corner to Any View
 * DATE:	Tue, Jun  7 2022
 * UPDATED:	Tue, Jun  7 2022
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		https://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2022 阿部康一／Kouichi ABE (WALL)
 * LICENSE:	The 2-Clause BSD License (See LICENSE.txt)
 */

import SwiftUI

/*
 * user interface - Round Specific Corners SwiftUI - Stack Overflow
 * https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui
 *
 * How to use:
 *  .cornerRadius(20, corners: [.topLeft, .bottomRight])
 */
extension View
{
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

#if true
// MARK: - Using Shape with UIBezierPath
struct RoundedCorner: Shape
{
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}
#else
// MARK: - Using Path + GeometryReader
struct RoundedCorners: View
{
  var color: Color = .blue
  var tl: CGFloat = 0.0
  var tr: CGFloat = 0.0
  var bl: CGFloat = 0.0
  var br: CGFloat = 0.0
  
  var body: some View {
    GeometryReader { geometry in
      Path { path in
        let w = geometry.size.width
        let h = geometry.size.height

        let w_2 = w * 0.5
        let h_2 = h * 0.5

        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h_2), w_2)
        let tl = min(min(self.tl, h_2), w_2)
        let bl = min(min(self.bl, h_2), w_2)
        let br = min(min(self.br, h_2), w_2)

        path.move(to: CGPoint(x: w_2, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        path.closeSubpath()
      }
      .fill(self.color)
    }
  }
}

// MARK: - Using Custom Shape
struct RoundedCorners: Shape
{
  var tl: CGFloat = 0.0
  var tr: CGFloat = 0.0
  var bl: CGFloat = 0.0
  var br: CGFloat = 0.0

  func path(in rect: CGRect) -> Path {
    var path = Path()

    let w = rect.size.width
    let h = rect.size.height

    let w_2 = w * 0.5
    let h_2 = h * 0.5

    // Make sure we do not exceed the size of the rectangle
    let tr = min(min(self.tr, h_2), w_2)
    let tl = min(min(self.tl, h_2), w_2)
    let bl = min(min(self.bl, h_2), w_2)
    let br = min(min(self.br, h_2), w_2)

    path.move(to: CGPoint(x: w_2, y: 0))
    path.addLine(to: CGPoint(x: w - tr, y: 0))
    path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

    path.addLine(to: CGPoint(x: w, y: h - br))
    path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

    path.addLine(to: CGPoint(x: bl, y: h))
    path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

    path.addLine(to: CGPoint(x: 0, y: tl))
    path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
    path.closeSubpath()

    return path
  }
}
#endif
