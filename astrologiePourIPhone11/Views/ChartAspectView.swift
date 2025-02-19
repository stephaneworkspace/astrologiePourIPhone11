//
// Created by Stéphane on 27.01.22.
//
import Foundation
import SwiftUI

struct ChartAspectView: View {
    @State var swTransit: Bool
    @Binding var swBodies: [Bool]
    @Binding var swPluton: Bool
    @Binding var swNode: Bool
    @Binding var swChiron: Bool
    @Binding var swCeres: Bool
    var swe: Swe
    var body: some View {
        let cD: ChartDraw = ChartDraw(swe: swe)
        ForEach(1...8, id: \.self) { idx in
            // nombre d'aspects
            ForEach(0...2, id: \.self) { jdx in
                let aspect = Swe.Aspects.init(rawValue: Int32(idx)) ?? Swe.Aspects.conjunction
                let aspectType = ChartDraw.AspectType.init(rawValue: jdx) ?? ChartDraw.AspectType.natal
                let aspectColor = aspect.color()
                let aspectStyle = aspect.style()
                let lines = ChartDraw(swe: swe).aspect_lines(
                        swe: cD.swe,
                        swBodies: swBodies,
                        swPluton: swPluton,
                        swNode: swNode,
                        swChiron: swChiron,
                        swCeres: swCeres,
                        aspect: aspect,
                        aspectType: aspectType
                )
                if aspectType == .natal {
                    if lines.count > 0 {
                        VStack {
                            ChartDraw.DrawAspectLines(lines: lines).stroke(aspectColor, style: aspectStyle)
                        }.frame(width: cD.swe.SIZE, height: cD.swe.SIZE)
                    }
                } else {
                    if swTransit {
                        if lines.count > 0 {
                            VStack {
                                ChartDraw.DrawAspectLines(lines: lines).stroke(aspectColor, style: aspectStyle)
                            }.frame(width: cD.swe.SIZE, height: cD.swe.SIZE)
                        }
                    }
                }
            }
        }
    }
}