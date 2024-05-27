//import SwiftUI
//
//struct RunningDetailView: View {
//    var body: some View {
//        ZStack {
//            HStack(alignment: .top, spacing: 3) {
//                HStack(spacing: 0) {
//                    Text("SPRINTING 1 / 6")
//                        .font(Font.custom("SF Compact", size: 9))
//                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
//                }
//                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 23))
//                .background(Color(red: 0.83, green: 0.20, blue: 0.20))
//                .cornerRadius(5)
//                HStack(spacing: 0) {
//                    Text("JOGGING 2 / 6")
//                        .font(Font.custom("SF Compact", size: 9))
//                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
//                }
//                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 59))
//                .background(Color(red: 0.17, green: 1, blue: 0.65))
//                .cornerRadius(5)
//                HStack(spacing: 0) {
//                    Text("SPRINTING 3 / 6")
//                        .font(Font.custom("SF Compact", size: 9))
//                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
//                }
//                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 22))
//                .background(Color(red: 0.95, green: 0.52, blue: 0))
//                .cornerRadius(5)
//                HStack(spacing: 0) {
//                    Text("JOGGING 4 / 6")
//                        .font(Font.custom("SF Compact", size: 9))
//                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
//                }
//                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 59))
//                .background(Color(red: 0.17, green: 1, blue: 0.65))
//                .cornerRadius(5)
//                HStack(spacing: 0) {
//                    Text("SPRINTING 5 / 6")
//                        .font(Font.custom("SF Compact", size: 9))
//                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
//                }
//                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 22))
//                .background(Color(red: 0.95, green: 0.52, blue: 0))
//                .cornerRadius(5)
//                HStack(spacing: 0) {
//                    Text("JOGGING 6 / 6")
//                        .font(Font.custom("SF Compact", size: 9))
//                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
//                }
//                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 59))
//                .background(Color(red: 0.17, green: 1, blue: 0.65))
//                .cornerRadius(5)
//            }
//            .offset(x: 259, y: -83)
//            Rectangle()
//                .foregroundColor(.clear)
//                .frame(width: 2, height: 18)
//                .background(.white)
//                .cornerRadius(6)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 6)
//                        .inset(by: -1)
//                        .stroke(Color(red: 0.12, green: 0.12, blue: 0.12), lineWidth: 1)
//                )
//                .offset(x: -80, y: -82.50)
//            VStack(spacing: 14) {
//                VStack(spacing: -4) {
//                    Text("28")
//                        .font(Font.custom("SF Compact", size: 45.49))
//                        .foregroundColor(Color(red: 0.83, green: 0.20, blue: 0.20))
//                    Text("seconds")
//                        .font(Font.custom("SF Compact", size: 11.31))
//                        .foregroundColor(.white)
//                }
//                HStack(alignment: .top, spacing: 40) {
//                    VStack(spacing: 0) {
//                        Text("80")
//                            .font(Font.custom("SF Compact", size: 30.60))
//                            .foregroundColor(.white)
//                        Text("􀊵 BPM")
//                            .font(Font.custom("SF Compact", size: 9.93))
//                            .foregroundColor(Color(red: 0.83, green: 0.20, blue: 0.20))
//                    }
//                    VStack(spacing: 0) {
//                        Text("0.00")
//                            .font(Font.custom("SF Compact", size: 30.60))
//                            .foregroundColor(.white)
//                        Text("METERS")
//                            .font(Font.custom("SF Compact", size: 9.93))
//                            .foregroundColor(Color(red: 0.83, green: 0.20, blue: 0.20))
//                    }
//                }
//                HStack(spacing: 0) {
//                    Text("STOP")
//                        .font(Font.custom("SF Compact", size: 11.31))
//                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
//                }
//                .padding(EdgeInsets(top: 2, leading: 22, bottom: 3, trailing: 23))
//                .background(Color(red: 0.83, green: 0.20, blue: 0.20))
//                .cornerRadius(9)
//            }
//            .offset(x: 0, y: 16.50)
//            Rectangle()
//                .foregroundColor(.clear)
//                .frame(width: 177, height: 215)
//                .background(
//                    AsyncImage(url: URL(string: "https://via.placeholder.com/177x215"))
//                )
//                .offset(x: 0.50, y: 0)
//        }
//        .frame(width: 176, height: 215)
//        .background(Color(red: 0.07, green: 0.07, blue: 0.07))
//    }
//}
//
//struct RunningDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RunningDetailView()
//    }
//}
