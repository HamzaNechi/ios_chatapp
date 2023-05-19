//
//  ForgetPassword.swift
//  student_chat
//
//  Created by Mac Mini 5 on 26/4/2023.
//

import SwiftUI

struct ForgetPassword: View {
    
    @State var code = ""
    @State var new_pass = ""
    @State var viewModel = AuthViewModel();
    @State var goLogin: Bool = false

    var body: some View {
        NavigationView{
            VStack(spacing: 20){
                Image("vemail")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                
                
                Text("Forget password").font(.largeTitle).fontWeight(.heavy)
                   
                
                Text("Please enter your activation code and new password")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 12)
                
                
                
                VStack{
                    TextField("activation code",text: $code)
                  //  FirstResponderTextField(text: $no)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, 15)
                    
                    TextField("New password",text: $new_pass)
                  //  FirstResponderTextField(text: $no)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, 15)
                }
                
                
                
                NavigationLink(destination: AuthView(),isActive: self.$goLogin){
                    //Text("goLogin")
                }
                
                Button(action: {
                    viewModel.forgetPassword(code: self.code, pass: self.new_pass){
                        resp in
                        self.goLogin = resp
                        print(resp)
                    }
                }){
                    Text("Send").frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    
                }
                .foregroundColor(Color("Secondary"))
                .foregroundColor(Color("accentColor"))
                .background(Color("Color1"))
                .cornerRadius(10)
                
            }.padding()
        }.navigationBarBackButtonHidden(true)
    }
      
}

struct FiirstResponderTextField: UIViewRepresentable {
    
    @Binding var text: String
    
    class Coordinator: NSObject, UITextFieldDelegate{
        @Binding var text: String
        var becameFirst = true
        init(text: Binding<String>) {
            self._text = text
        }
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> some UIView{
        let textField = UITextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becameFirst {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirst = true
        }
    }
    
    
    
}

struct ForgetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPassword()
    }
}
