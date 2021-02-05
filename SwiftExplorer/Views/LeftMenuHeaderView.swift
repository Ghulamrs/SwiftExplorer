//
//  LeftMenuHeaderView.swift
//  SwiftExplorer
//
//  Created by Home on 2/2/21.
//

import SwiftUI

struct LeftMenuHeaderView: View {
    @Binding var isShowing: Bool
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: { withAnimation(.spring()) { isShowing.toggle() } }, label: {Image(systemName: "xmark")})
                .frame(width: 32, height: 32)
                .foregroundColor(.white)
                .padding()
            
            VStack(alignment: .leading) {
                Image("minarepakistan")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .padding(.bottom, 16)
                
                Text("Morning Walk, 2.0")
                    .font(.system(size: 24, weight: .semibold))
//                    .foregroundColor(Color(red: 0, green: 0.25, blue: 0))
                Text("March 23, 2021")
                    .font(.system(size: 14))
                    .padding(.bottom, 12)
                
                HStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Text("Latitude").bold()
                        Text("34.2")
                    }
                    HStack(spacing: 6) {
                        Text("Longitude").bold()
                        Text("73.5")
                    }
                    Spacer()
                }
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}

struct LeftMenuHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LeftMenuHeaderView(isShowing: .constant(true))
    }
}
