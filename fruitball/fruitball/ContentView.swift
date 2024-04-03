//
//  ContentView.swift
//  fruitball
//
//  Created by Diego Henrick on 21/03/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
//            RewardedAd.shared.loadAd(withAdUnitId: rewardAdId)
        }
    }
}

#Preview {
    ContentView()
}
