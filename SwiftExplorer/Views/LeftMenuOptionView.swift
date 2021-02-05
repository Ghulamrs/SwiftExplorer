//
//  LeftMenuOptionView.swift
//  SwiftExplorer
//
//  Created by Home on 2/2/21.
//

import SwiftUI

struct LeftMenuOptionView: View {
    var member: Member
    var body: some View {
        HStack (spacing: 24) {
            Image(systemName: "person")
                .frame(width: 24, height: 24)
                .foregroundColor(.purple)
            
            Text(member.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.blue)
            
            Spacer()
        }
//        .foregroundColor(.white)
        .padding()
    }
}
