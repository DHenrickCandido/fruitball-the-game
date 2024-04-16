//
//  MenuStartView.swift
//  fruitball
//
//  Created by Diego Henrick on 05/04/24.
//

import SwiftUI
import GameKit
import NavigationTransitions


struct MenuStartView: View {
    let highscore = UserDefaults.standard.integer(forKey: "highscore")
    let gameService = GameService()
    
    var body: some View {
        NavigationStack {
            HStack{
                Spacer()
                VStack{
                    Spacer()
                    VStack {
                        HStack{
                            VStack(alignment: .leading){
                                Text("MELHOR")
                                    .font(.custom("SigmarOne-Regular", size: 30))
                                    .foregroundStyle(.white)
                                    .frame(width: 150, height: 30)
                                Text("PONTUAÇÃO")
                                    .font(.custom("SigmarOne-Regular", size: 30))
                                    .foregroundStyle(.white)
                                    .frame(width: 230, height: 30)
                            }
                            Spacer()
                            Button(action: {
                                print("click")
                                gameService.showLeaderboard()
                            }, label: {
                                Image("Button")
                            })
                        }
                        .padding(.horizontal, 24)
                        Text(String(highscore))
                            .font(.custom("SigmarOne-Regular", size: 150))
                            .foregroundStyle(Color("ColorScore"))
                            .frame(height: 120)
                        Text("EMBAIXADINHAS")
                            .font(.custom("SigmarOne-Regular", size: 30))
                            .foregroundStyle(Color("ColorScore"))
                    }.padding(.bottom, 180)
                    Spacer()
                    NavigationLink(destination: GameSceneView().navigationBarBackButtonHidden(true)) {
                        Text("PLAY")
                            .font(.custom("SigmarOne-Regular", size: 80))
                            .foregroundStyle(Color("ColorScore"))
                            .padding(.bottom, 60)
                    }
                    .navigationBarBackButtonHidden(true)
                    
                }
                Spacer()
            }.background() {
                Color("ColorYellow")
            }
            .ignoresSafeArea(.all)
            .onTapGesture {
                print("click")
            }
            .onAppear() {
                gameService.authenticate { error in
                    if let error = error {
                        print("Erro ao autenticar: \(error)")
                    } else {
                        print("Autenticação bem-sucedida!")
                    }
                }
            }
        }.navigationTransition(.fade(.cross))

    }
    

    
}

#Preview {
    MenuStartView()
}
