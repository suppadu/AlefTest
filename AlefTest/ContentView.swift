//
//  ContentView.swift
//  AlefTest
//
//  Created by Дмитрий Константинов on 23.11.2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    
    @State var isPresentClearDialog: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Персональные данные")
                    .foregroundColor(.primary)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                CustomTextField(textType: $viewModel.nameFirst, label: "Имя")
                CustomTextField(textType: $viewModel.age, label: "Возраст", isNumber: true)
                
                HStack(alignment: .center) {
                    Text("Дети (макс. 5)")
                        .foregroundColor(.primary)
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                    Spacer()
                    if viewModel.kids.count < 5 {
                        Button {
                            viewModel.kids.append(Children())
                        } label: {
                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "plus")
                                Text("Добавить ребенка")
                            }
                        }.buttonStyle(OvalButton(color: .blue))
                    }
                }
                
                ForEach($viewModel.kids) { children in
                    HStack {
                        VStack {
                            HStack(alignment: .center, spacing: 20) {
                                CustomTextField(textType: children.name, label: "Имя")
                                    .frame(width: UIScreen.main.bounds.width / 2)
                                Button {
                                    viewModel.removeChildren(children.wrappedValue)
                                } label: {
                                    Text("Удалить")
                                }
                                Spacer()
                            }
                            HStack {
                                CustomTextField(textType: children.age, label: "Возраст", isNumber: true)
                                    .frame(width: UIScreen.main.bounds.width / 2)
                                Spacer()
                            }
                        }
                    }
                    Divider()
                }
                
                if !viewModel.kids.isEmpty {
                    HStack(alignment: .center) {
                        Spacer()
                        Button {
                            isPresentClearDialog.toggle()
                        } label: {
                            Text("Очистить")
                                .padding(.horizontal, 40)
                        }
                        .buttonStyle(OvalButton(color: .red))
                        Spacer()
                    }
                    Spacer()
                }
                
            }
            .padding([.horizontal, .top])
            
        }
        .onTapGesture {
            hideKeyboard()
        }
        .actionSheet(isPresented: $isPresentClearDialog) {
            ActionSheet(title: Text("Очистить?"), message: Text("Все дети будут удаленны"), buttons: [
                .default(Text("Очистить")) { viewModel.removeAllKids() },
                .cancel(Text("Отмена"))
            ])
        }
    }
}

//MARK: - customTextField
struct CustomTextField: View {
    
    @Binding var textType: String
    var label: String
    var isNumber: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .foregroundColor(.gray)
            TextField("Введите текст", text: $textType)
                .keyboardType(isNumber ? .numberPad : .default)
                
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 7)
                    .stroke(.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

//MARK: - стиль для кнопок
struct OvalButton: ButtonStyle {
    
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: 40)
                        .stroke(color, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .foregroundColor(color)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
