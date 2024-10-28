import SwiftUI

//struct NewRecipe {
//    let title: String
//    let description: String
//    let ingredients: [String]
//}
struct NewRecipe: Codable {
   let title: String
   let description: String
   let ingredients: [String]
}

struct Newrecipes: View {
   @Environment(\.presentationMode) var presentationMode // Dismiss environment variable

   @State private var title: String = ""
   @State private var description: String = ""
   @State private var ingredients: [String] = []
   @State private var newIngredient: String = ""
   @State private var selectedMeasurement: String = "Spoon"
   @State private var servingCount: Int = 1
   
   @State private var showingActionSheet = false
   @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
   @State private var showingImagePicker = false
   @State private var selectedImage: UIImage?
   @State private var showingIngredientPopup = false
   @State private var recipes: [NewRecipe] = [] // مصفوفة لتخزين الوصفات
   
   
   var body: some View {
       NavigationView {
           ScrollView {
               VStack(spacing: 20) {
                   Button(action: {
                       showingActionSheet = true
                   }) {
                       VStack {
                           ZStack {
                               RoundedRectangle(cornerRadius: 5)
                                   .stroke(Color(red: 0.894, green: 0.894, blue: 0.903), lineWidth: 166)

                                   .background(Color(red: 120/255, green: 120/255, blue: 128/255).opacity(0.2))
                                   .padding(.horizontal, -475.646)
                                   .padding(.top, 124.066)
                                   .padding(.bottom, 67.744)

                               VStack {
                                   Image(systemName: "photo.badge.plus")
                                       .renderingMode(.template)
                                       .resizable(capInsets: EdgeInsets(top: 15.0, leading: 15.0, bottom: 0.0, trailing: 17.0))
                                       .frame(width: 85, height: 71)
                                       .foregroundColor(Color(red: 0.985, green: 0.379, blue: 0.072))
                                       
                                   Text("Upload Photo")
                                       .fontWeight(.bold)
                                       .foregroundColor(.black)
                                       .padding(.bottom, 2.95)
                               }
                               .padding()
                           }
                       }
                   }
                   .actionSheet(isPresented: $showingActionSheet) {
                       ActionSheet(title: Text("Choose Photo Source"), buttons: [
                           .default(Text("Take Photo")) {
                               sourceType = .camera
                               showingImagePicker = true
                           },
                           .default(Text("Use Photo Library")) {
                               sourceType = .photoLibrary
                               showingImagePicker = true
                           },
                           .cancel()
                       ])
                   }

                   VStack(alignment: .leading) {
                       Text("Title")
                           .foregroundColor(.black)
                           .font(.headline)
                           .padding(.leading, 16)

                       TextField("Enter recipe title", text: $title)
                           .padding()
                           .background(Color.gray.opacity(0.1))
                           .cornerRadius(8)
                           .padding(.horizontal, 16)
                   }

                   VStack(alignment: .leading) {
                       Text("Description")
                           .foregroundColor(.black)
                           .font(.headline)
                           .padding(.leading, 16)

                       TextField("Enter recipe description", text: $description)
                           .padding()
                           .background(Color.gray.opacity(0.1))
                           .cornerRadius(8)
                           .padding(.horizontal,16)
                       
                   }

                   VStack(alignment: .leading) {
                       HStack {
                           Text("Add Ingredient")
                               .font(.headline)
                               .foregroundColor(.black)
                               .padding(.leading, 16)

                           Spacer()

                           Button(action: {
                               showingIngredientPopup = true
                           }) {
                               Image(systemName: "plus.circle.fill")
                                   .foregroundColor(.orange)
                                   .font(.title)
                           }
                           .padding(.trailing, 16)
                       }

                       ForEach(ingredients, id: \.self) { ingredient in
                           Text(ingredient)
                               .padding(.leading, 16)
                       }
                   }
                   .padding(.bottom, 20)

                   Spacer()
               }
           }
           .navigationBarTitle("", displayMode: .inline)
           .navigationBarItems(
               leading:
                   HStack {
                   Button(action: {
                       presentationMode.wrappedValue.dismiss() // Dismiss the view
                   }) {
                       Text("Back")
                           .foregroundColor(.blue)
                   }
                   Text("New Recipe")
                       .font(.title)
                       .fontWeight(.bold)
                       .foregroundColor(.black)
               },
               trailing: Button("Save") {
                   saveRecipe() // Save the recipe
               }
           )
//            .navigationBarItems(leading: Text("New Recipe").font(.title)
//                .fontWeight(.bold)
//                .foregroundColor(.black),trailing: Button("Save"){
//                    saveRecipe()
//                })
         
           .padding(.bottom)
       }
       .popup(isPresented: $showingImagePicker) {
           ImagePicker(isPresented: $showingImagePicker, image: $selectedImage, sourceType: $sourceType)
       }
       .popup(isPresented: $showingIngredientPopup) {
           IngredientSheet(newIngredient: $newIngredient, selectedMeasurement: $selectedMeasurement, servingCount: $servingCount, ingredients: $ingredients, showingIngredientSheet: $showingIngredientPopup)
       }
   }
   private func saveRecipe() {
       let newRecipe = NewRecipe(title: title, description: description, ingredients: ingredients)
       recipes.append(newRecipe)

       // تخزين الوصفات في UserDefaults
       if let encodedData = try? JSONEncoder().encode(recipes) {
           UserDefaults.standard.set(encodedData, forKey: "savedRecipes")
       }

       // إعادة تعيين الحقول بعد الحفظ
       title = ""
       description = ""
       ingredients = []
   }
//    private func saveRecipe() {
//        let newRecipe = NewRecipe(title: title, description: description, ingredients: ingredients)
//        recipes.append(newRecipe)
//        // إعادة تعيين الحقول بعد الحفظ
//        title = ""
//        description = ""
//        ingredients = []
//    }
}

struct IngredientSheet: View {
   @Binding var newIngredient: String
   @Binding var selectedMeasurement: String
   @Binding var servingCount: Int
   @Binding var ingredients: [String]
   @Binding var showingIngredientSheet: Bool
   
   var body: some View {
       VStack {
           Text("Ingrediant Name")
               .font(.headline)
               .fontWeight(.bold)
               .padding(.leading, -150.0)

           TextField("Ingrediant Name", text: $newIngredient)
               .padding()
               .background(Color.gray.opacity(0.1))
               .cornerRadius(8)
               .padding([.leading, .trailing], 16)

           Text("Measurement")
               .font(.headline)
               .fontWeight(.bold)
               .padding(.leading, -150.0)

           HStack {
               Button(action: {
                   selectedMeasurement = "Spoon"
               }) {
                   Text("Spoon 🥄")
                       .padding()
                       .frame(maxWidth: .infinity)
                       .background(selectedMeasurement == "Spoon" ? Color.orange : Color.gray.opacity(0.2))
                       .foregroundColor(selectedMeasurement == "Spoon" ? .white : .black)
                       .cornerRadius(8)
               }
               
               Button(action: {
                   selectedMeasurement = "Cup"
               }) {
                   Text("Cup 🥛")
                       .padding()
                       .frame(maxWidth: .infinity)
                       .background(selectedMeasurement == "Cup" ? Color.orange : Color.gray.opacity(0.2))
                       .foregroundColor(selectedMeasurement == "Cup" ? .white : .black)
                       .cornerRadius(8)
               }
           }
           .padding(.horizontal, 16)

           
           Text("Serving")
               .font(.headline)
               .fontWeight(.bold)
               .padding(.leading, -150.0)

           HStack(spacing: 10) {
               HStack(spacing: 10) {
                   Button(action: {
                       if servingCount > 1 {
                           servingCount -= 1
                       }
                   }) {
                       Image(systemName: "minus")
                           .foregroundColor(.orange)
                           .frame(width: 30, height: 30)
                           .background(Color.gray.opacity(0.1))
                           .cornerRadius(8)
                   }

                   Text("\(servingCount)")
                       .font(.title2)
                       .frame(width: 30, alignment: .center)

                   Button(action: {
                       servingCount += 1
                   }) {
                       Image(systemName: "plus")
                           .foregroundColor(.orange)
                           .frame(width: 30, height: 30)
                           .background(Color.gray.opacity(0.1))
                           .cornerRadius(8)
                   }
               }
               .padding(8)
               .background(Color.gray.opacity(0.2))
               .cornerRadius(8)

               Button(action: {
                   // Action for selecting measurement if needed
               }) {
                   HStack {
                       Image(systemName: "fork.knife") // استبدل هذا الرمز برمز الملعقة إذا كان متاحًا
                       Text("Spoon")
                   }
                   .padding()
                   .frame(height: 40)
                   .background(Color.orange)
                   .foregroundColor(.white)
                   .cornerRadius(8)
               }
           }
           .padding(.horizontal, 16)


           HStack {
               Button("Cancel") {
                   showingIngredientSheet = false
               }
               .padding()
               .background(Color.gray.opacity(0.2))
               .foregroundColor(.red)
               .cornerRadius(8)

               Spacer()

               Button("Add") {
                   if !newIngredient.isEmpty {
                       ingredients.append("\(newIngredient) - \(selectedMeasurement) (Serves \(servingCount))")
                       newIngredient = ""
                   }
                   showingIngredientSheet = false
               }
               .padding()
               .background(Color.orange)
               .foregroundColor(Color.white)
               .cornerRadius(8)
           }
           .padding([.leading, .trailing], 16)
       }
       .padding()
       .background(Color.white)
       .cornerRadius(12)
       .shadow(radius: 20)
       .padding()
   }
}

// UIViewControllerRepresentable لعرض Image Picker
struct ImagePicker: UIViewControllerRepresentable {
   @Binding var isPresented: Bool
   @Binding var image: UIImage?
   @Binding var sourceType: UIImagePickerController.SourceType

   class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
       @Binding var isPresented: Bool
       @Binding var image: UIImage?

       init(isPresented: Binding<Bool>, image: Binding<UIImage?>) {
           _isPresented = isPresented
           _image = image
       }

       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let uiImage = info[.originalImage] as? UIImage {
               image = uiImage
           }
           isPresented = false
       }

       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           isPresented = false
       }
   }

   func makeCoordinator() -> Coordinator {
       Coordinator(isPresented: $isPresented, image: $image)
   }

   func makeUIViewController(context: Context) -> UIImagePickerController {
       let picker = UIImagePickerController()
       picker.delegate = context.coordinator
       picker.sourceType = sourceType
       return picker
   }

   func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// MARK: - Popup Modifier
extension View {
   func popup<Popup: View>(isPresented: Binding<Bool>, @ViewBuilder popup: () -> Popup) -> some View {
       ZStack {
           self
           if isPresented.wrappedValue {
               Color.black.opacity(0.4)
                   .edgesIgnoringSafeArea(.all)
               popup()
                   .transition(.scale)
           }
       }
   }
}

// Preview
#Preview {
   Newrecipes()
}
