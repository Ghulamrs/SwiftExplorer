//
//  ContentView.swift
//  SwiftExplorer
//
//  Created by Home on 1/30/21.
// 

import SwiftUI

struct ContentView: View {
    @State private var isShowing = false
    var body: some View {
        NavigationView {
            ZStack {
                if( isShowing) {
                    LeftMenuView(isShowing: $isShowing)
                }
                HomeView()
                    .cornerRadius(isShowing ? 20 : 10)
                    .offset(x: isShowing ? 300: 0, y: isShowing ? 44 : 0)
                    .scaleEffect(isShowing ? 0.8 : 1)
                .navigationBarItems(leading: Button(action: {
                    withAnimation(.spring()) {
                        isShowing.toggle()
                    }
                }, label: {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.black)
                }))
                .navigationTitle("Morning Walk")            }
        }
        .onAppear() {
            isShowing = false
        }
    }
}

struct HomeView: View {
    var body: some View {
        ZStack {
            VStack {
                GoogleMapsView()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
