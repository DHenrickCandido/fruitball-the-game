//
//  GameOverView.swift
//  fruitball
//
//  Created by Diego Henrick on 06/04/24.
//

import SwiftUI
import GameKit

struct GameOverView: View {

    @State var highscore = UserDefaults.standard.integer(forKey: "highscore")
        
    @State var showGameSceneView = false
    
    @Environment(\.dismiss) var dismiss

    let gameService = GameService()
    var body: some View {
            ZStack {
                Spacer()
                VStack(alignment: .center, spacing: -30) {
                    HStack() {
                        Spacer()
                        Button(action: {
                            print("click")
                            gameService.showLeaderboard()
                        }, label: {
                            Image("Button")
                        }).padding(.bottom, 30)
                            .padding(.trailing, 50)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 8)
                    Text("HIGHSCORE")
                        .font(.custom("SigmarOne-Regular", size: 50))
                        .foregroundStyle(Color("ColorScoreGrey"))
                    Text(String(highscore))
                        .font(.custom("SigmarOne-Regular", size: 165))
                        .foregroundStyle(Color("ColorScoreGrey"))
                        .frame(height: 150)
                    Spacer()
                }
                .padding(.top, 80)
                ZStack {
                    VStack{
                        Spacer()
                        Image("chaoCampo")
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    HStack{
                        Image("legTorto")
                            .rotationEffect(.degrees(-45))
                            .frame(width: 0, height: 100)
                            .padding(.trailing, 300)
                            .padding(.top, 140)
                        Spacer()
                        VStack{
                            Spacer()
                            Image("fruitApple")
                                .resizable()
                                .frame(width: 80, height: 90)
                                .padding(.trailing, 100)
                                .padding(.bottom, 100)
                        }
                    }
                        NavigationLink(
                            destination: GameSceneView()
                                .navigationBarBackButtonHidden(true),
                            label: {
                                Text("Play Again")
                                    .font(.custom("SigmarOne-Regular", size: 50))
                                    .foregroundStyle(Color("ColorScoreGrey"))
                            }
                        )
                }
                Spacer()
            }.background(){
                Color(UIColor.black)
            }
            .ignoresSafeArea(.all)
            .onAppear(){
                UserDefaults.standard.synchronize()
                highscore = UserDefaults.standard.integer(forKey: "highscore")
        }
    }
}

#Preview {
    GameOverView()
}
