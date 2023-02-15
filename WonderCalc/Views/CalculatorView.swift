//
//  ContentView.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import SwiftUI

struct CalculatorView: View {
    
    @ObservedObject var calculator: Calculator
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text("\(calculator.publishedValue)")
                        .font(.heading)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray, lineWidth: 1)
                )

                LazyVGrid(columns: layout) {
                    clearButton()
                    button(.cut)
                    button(.copy)
                    button(.paste)
                }
                
                LazyVGrid(columns: layout) {
                    button(.negative)
                    button(.percent)
                    button(.squareRoot)
                    button(.squared)
                }
                LazyVGrid(columns: layout) {
                    button(.seven)
                    button(.eight)
                    button(.nine)
                    button(.divide)
                }
                LazyVGrid(columns: layout) {
                    button(.four)
                    button(.five)
                    button(.six)
                    button(.multiply)
                }
                LazyVGrid(columns: layout) {
                    button(.one)
                    button(.two)
                    button(.three)
                    button(.minus)
                }
                LazyVGrid(columns: layout) {
                    button(.zero)
                    button(.decimal)
                    button(.equal)
                    button(.plus)
                }
            }
            .padding(horizontalSizeClass == .regular ? .wide : .standard)
            .navigationTitle("WonderCalc")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Private
    
    private let layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private func button(_ option: CalculatorButtonOption) -> CalculatorButton {
        CalculatorButton(option: option, callback: calculator.buttonTapped)
    }

    private func clearButton() -> some View {
        Button(action: clearButtonTapped) {
            Text(calculator.clearButtonText)
                .font(.subHeading)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 3)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Capsule()
                    .fill(.red)
                    .frame(height: 56))
        }
    }

    private func clearButtonTapped() {
        calculator.buttonTapped(.clear)
    }
}

struct CalcView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView(calculator: Calculator())
    }
}
