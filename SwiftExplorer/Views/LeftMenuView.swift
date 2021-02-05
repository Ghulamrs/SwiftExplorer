//
//  LeftMenuView.swift
//  SwiftExplorer
//
//  Created by Home on 2/2/21.
//

import SwiftUI

struct LeftMenuView: View {
    @Binding var isShowing: Bool
    @ObservedObject var viewModel = LeftMenuViewModel()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack {
                LeftMenuHeaderView(isShowing: $isShowing)
                    .frame(height: 240)
                
                //ForEach(viewModel.members) { member in
                List(viewModel.members) { member in
                    LeftMenuOptionView(member: member)
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct LeftMenuView_Previews: PreviewProvider {
    static var previews: some View {
        LeftMenuView(isShowing: .constant(true))
    }
}
