//Created for Ebcom in 2024
// Using Swift 5.0

import SwiftUI
import CachedAsyncImage

struct MessageView: View {
    @EnvironmentObject var vm: ViewModel

    @State var messageBody : Message
    @State var expCollapse: Bool = false
    @Binding var showSelection: Bool
    @Binding var selectedToRemove: [Message]

    var body: some View {
        
        HStack {
            if showSelection {
                
                Toggle("", isOn: Binding(
                    get: { selectedToRemove.contains(where: { $0.id == messageBody.id }) ? true : false },
                    set: { newValue in
                        withAnimation {
                            if newValue {
                                selectedToRemove.append(messageBody)
                                print(selectedToRemove.count)
                            }else{
                                selectedToRemove.remove(at: selectedToRemove.firstIndex(where: { $0.id == messageBody.id } )!)
                            }
                        }
                    }
                ))
                .toggleStyle(iOSCheckboxToggleStyle())
                .padding(.leading,10)
                .padding(.trailing,-20)
            }

            VStack(alignment: .leading, content: {
                HStack {
                    Text(messageBody.date )
                        .font(Font.get(.body))
                        .foregroundStyle(.secondary)
                    Spacer()
                                    
                    ShareLink(item: messageBody.title) {
                        Image("share")
                            .resizable()
                            .frame(width: 18,height: 20)
                    }
                    
                    .padding([.trailing],10)
                    
                    Button(action: {
                          messageBody.isTagged.toggle()
                          vm.setTagged(id: messageBody.id, status: messageBody.isTagged)
                        
                    }, label: {
                        Image(systemName: messageBody.isTagged ? "bookmark.fill" : "bookmark")
                            .resizable()
                            .frame(width: 15,height: 20)
                            .foregroundColor(messageBody.isTagged ? .orange : .black)
                    })
                    
                }
                
                Text(messageBody.title)
                    .font(Font.get(.title))
                    .padding([.top],10)
                
                
                DynamicStack(isCollapsed: $expCollapse) {
                    if messageBody.imageURL != "" {
                        CachedAsyncImage(
                            url: URL(string: messageBody.imageURL)
    //                        transaction: .init(animation: .easeIn(duration: 1))
                        ) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()

                            default:
                                Image("bigImage")
                                    .resizable()
    //                                .scaledToFit()
                                    .clipped()
                                    .foregroundColor(.clear)
                            }
                        }
                        .frame(width: expCollapse ? showSelection ? UIScreen.main.bounds.width * 0.77 :  UIScreen.main.bounds.width * 0.84 : 40, height: expCollapse ? 110 : 40, alignment: .leading)
                        .cornerRadius(4)
                        .shadow(radius: 5)
                        .isHidden(messageBody.imageURL.isEmpty, remove: true)
                    }
                    
                    Text(messageBody.message)
                        .font(Font.get(.body))
                        .lineLimit(expCollapse ? 10 : 1)
                        .lineSpacing(10)
                        .frame(width: UIScreen.main.bounds.width * (expCollapse ? showSelection ? messageBody.imageURL != "" ? 0.64 : 0.74 : 0.84 : showSelection ? 0.64 : 0.74), height: expCollapse ? 170 : 40, alignment: .leading)
                }
                
                Divider()
                    .padding([.trailing,.leading])
                
                HStack {
                    Text("اعتبار پیام")
                        .font(Font.get(.body))
                        .foregroundStyle(.secondary)
                    
                    
                    Spacer()
                    
                    Text(messageBody.expireDate)
                        .font(Font.get(.body))
                        .foregroundStyle(.secondary)
                    
                    
                    Button(action: {
                        withAnimation {
                            expCollapse.toggle()
//                            vm.setRead(id: messageBody.id, status: false)
                        }

                    }, label: {
                        Image("expand")
                            .rotationEffect(expCollapse ? .degrees(180) : .zero)
                            .animation(.default, value: 1.0)
                    })
                    
                }
                .padding([.top])
                
            })
            .padding()
            .environment(\.layoutDirection, .rightToLeft)
            .frame(width: UIScreen.main.bounds.width - (showSelection ? 60 : 32), height: expCollapse ? messageBody.imageURL.isEmpty ? UIScreen.main.bounds.height * 0.4 : UIScreen.main.bounds.height * 0.53 : UIScreen.main.bounds.height * 0.2465, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill((!messageBody.isRead) ? Color.init(uiColor: .quaternarySystemFill) : Color.white)
                    .shadow(radius: 1)
                    .padding([.leading,.trailing])
            )
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    MessageView(messageBody:
                    Message(id: UUID(), title: "تیتر پیام",
                            date: "۱۴۰۰/۱۰/۲۴ - ۱۰:۵۰",
                            message: "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد،",
                            expireDate: "۱۴۰۰/۱۱/۳۰ - ۱۳:۰۰",
                            imageURL: "",
                            isRead: true,
                            isTagged: true),
                showSelection: .constant(true),
                selectedToRemove: .constant([])
    )
}
