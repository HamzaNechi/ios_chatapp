//
//  verifEmail.swift
//  student_chat
//
//  Created by Mac Mini 5 on 26/4/2023.
//



import SwiftUI

struct verifEmail: View {
    
    @State var email = ""
    @State var viewModel = AuthViewModel();
    @State var goLogin: Bool = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20){
                Image("vemail")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                
                Text("Verify your email").font(.largeTitle).fontWeight(.heavy)
                
                Text("Please enter your email")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 12)
                
                
                
                TextField("Your email",text: $email)
              //  FirstResponderTextField(text: $no)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 15)
                
                
                NavigationLink(destination: ForgetPassword(),isActive: self.$goLogin){
                    
                }
                
                Button(action: {
                   /* viewModel.activate(Activation: self.email){
                        (res) in
                        self.goLogin=res
                    }*/
                    
                    viewModel.findEmail(email: self.email){
                        resp in
                        self.goLogin = resp
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

struct fFirstResponderTextField: UIViewRepresentable {
    
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

struct verifEmail_Previews: PreviewProvider {
    static var previews: some View {
        verifEmail()
    }
}
