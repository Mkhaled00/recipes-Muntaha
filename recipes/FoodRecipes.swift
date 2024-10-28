//
//  FoodRecipes.swift
//  recipes
//
//  Created by muntaha khaled Alduraywish on 27/10/2024.
//

//import SwiftUI
//
//struct FoodRecipes: View {
//    @State private var searchText: String = ""
//    @State private var isPresentingNewRecipe = false
//
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Food Recipes")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.leading)
//                    .padding(.leading, -95.0)
//                    .padding(.top, -58.425)
//                    .frame(width: 361.0, height: 41.0)
//                
//
//                // حقل البحث
//                TextField("Search recipes...", text: $searchText)
//                    .padding(10)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//                    .padding(.horizontal, 16)
//
//                // اقتراحات البحث
//                List {
//                    if searchText.isEmpty {
//                        Text("Please enter a search term.")
//                    } else {
//                        // هنا يمكنك إضافة اقتراحات البحث بناءً على نص البحث
//                        ForEach(searchSuggestions(for: searchText), id: \.self) { suggestion in
//                            Text(suggestion)
//                        }
//                    }
//                }
//                .frame(height: 200) // عرض محدد للقائمة
//
//                Spacer()
//            }
//            .navigationBarTitle("", displayMode: .inline)
//            .navigationBarItems(trailing: Button(action: {
//                isPresentingNewRecipe = true
//                print("Plus button tapped")
//            }) {
//                Image(systemName: "plus")
//                    .font(.title)
//                    .foregroundColor(Color(red: 0.985, green: 0.379, blue: 0.072))
//            })
//            .padding()
//            .sheet(isPresented: $isPresentingNewRecipe) {
//                Newrecipes()
//            }
//            
//        }
//    }
//    
//    // دالة للحصول على اقتراحات البحث
//    private func searchSuggestions(for query: String) -> [String] {
//        let allSuggestions = ["Pasta", "Pizza", "Salad", "Sushi", "Burger"]
//        return allSuggestions.filter { $0.lowercased().contains(query.lowercased()) }
//    }
//}
//
//#Preview {
//    FoodRecipes()
//}
import SwiftUI

struct FoodRecipes: View {
    @State private var searchText: String = ""
    @State private var isPresentingNewRecipe = false
    @State private var recipes: [NewRecipe] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Food Recipes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, -95.0)
                    .padding(.top, -58.425)
                    .frame(width: 361.0, height: 41.0)

                // حقل البحث
                TextField("Search recipes...", text: $searchText)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)

                // قائمة عرض الوصفات
                List {
                    if recipes.isEmpty {
                        Text("No recipes available.")
                    } else {
                        ForEach(filteredRecipes, id: \.title) { recipe in
                            VStack(alignment: .leading) {
                                Text(recipe.title)
                                    .font(.headline)
                                Text(recipe.description)
                                    .font(.subheadline)
                                
                                
                            }
                        }
                    }
                }
                .frame(height: 300) // ضبط ارتفاع القائمة

                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isPresentingNewRecipe = true
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(Color(red: 0.985, green: 0.379, blue: 0.072))
            })
            .padding()
            .sheet(isPresented: $isPresentingNewRecipe, onDismiss: loadRecipes) {
                Newrecipes()
            }
            .onAppear(perform: loadRecipes)
        }
    }

    // دالة لتحميل الوصفات من UserDefaults
    private func loadRecipes() {
        if let data = UserDefaults.standard.data(forKey: "savedRecipes"),
           let savedRecipes = try? JSONDecoder().decode([NewRecipe].self, from: data) {
            recipes = savedRecipes
        }
    }

    // دالة لتصفية الوصفات بناءً على البحث
    private var filteredRecipes: [NewRecipe] {
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }

    // دالة للحصول على اقتراحات البحث
    private func searchSuggestions(for query: String) -> [String] {
        let allSuggestions = ["Pasta", "Pizza", "Salad", "Sushi", "Burger"]
        return allSuggestions.filter { $0.lowercased().contains(query.lowercased()) }
    }
}

#Preview {
    FoodRecipes()
}
