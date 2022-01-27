//
// Created by Stéphane on 26.01.22.
//

import Foundation
import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Image("bgl")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
            VStack {
                VStack {
                    Spacer()
                    Image("bressani.dev")
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    Text("Développé par bressani.dev (Stéphane Bressani)")
                    Spacer()
                    Text("Cette application est sous license GNU public license version 3.")
                    Spacer()
                    Text("Elle utilise la libraiaire swiss ephemeris developé par Dieter Koch and Alois Treindl en Dual license (GNU v2 ou supérieur ou commercial)")
                    Spacer()
                    Text("Cette application utilise aussi le package swift Zip en MIT par Roy Marmelstein")
                    Spacer()
                }
            }.padding()
        }
    }
}
