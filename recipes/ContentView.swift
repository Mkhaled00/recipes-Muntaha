import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Food Recipes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, -95.0)
                    .padding(.top, 41)
                    .frame(width: 361.0, height: 41.0)

                Spacer()

                Image(systemName: "fork.knife.circle")
                    .resizable()
                    .foregroundColor(Color(red: 0.985, green: 0.379, blue: 0.072))
                    .scaledToFit()
                    .frame(width: 325, height: 327)
                    .padding(.top, -40.0)

                Text("There's No Recipes yet!")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(.top, 10)

                Text("Please add your recipes")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 5)

                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: Newrecipes()) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(Color(red: 0.985, green: 0.379, blue: 0.072))
            })
            .padding()
        }
    }
}

// Preview
#Preview {
    ContentView()
}
