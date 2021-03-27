import SwiftUI
import Combine

struct SelectCountriesAndCategoriesView: View {
    
    @EnvironmentObject var settings: UserSettings
    
    @ObservedObject var viewModel = SelectCountriesAndCategoriesViewModel()
    @State private var selectedCountry = 0
    @State private var selectedCountryValue:Country? = nil
    @State var selectedCategories: [String] = []
    @State var goTheHome: Int? = nil
    
    private func categoriesField() -> some View {
        Text("Please Select 3 Fav item")
            .font(.headline)
            .foregroundColor(Color(UIColor.systemBackground))
            .frame(minWidth: 100, maxWidth: UIScreen.main.bounds.size.width/1.2, minHeight: 50)
            .background(RoundedRectangle(cornerRadius: 15)
                            .shadow( color: Color.gray.opacity(0.35), radius: 15, x: 0, y: 0))
    }
    
    private func gridView()  -> some View {
        GridStack(minCellWidth: UIScreen.main.bounds.size.width/3.3, spacing: 2, numItems: self.viewModel.categoriesList.count) { index, cellWidth in
            Text("\(self.viewModel.categoriesList[index])")
                .foregroundColor(.white)
                .frame(width: cellWidth, height: cellWidth * 0.5)
                .background(self.selectedCategories.contains(self.viewModel.categoriesList[index]) ? Color.green : Color.blue)
                .onTapGesture {
                    if self.selectedCategories.contains(self.viewModel.categoriesList[index]) {
                        self.selectedCategories.removeAll(where: { $0 == self.viewModel.categoriesList[index] })
                    }
                    else {
                        self.selectedCategories.append(self.viewModel.categoriesList[index])
                    }
                }
        }.padding([.leading, .trailing], 4)
    }
    
    private func countriesField() -> some View {
        return Text(selectedCountryValue?.name ?? "Please Select Country")
            .font(.headline)
            .foregroundColor(Color(UIColor.systemBackground))
            .frame(minWidth: 100, maxWidth: UIScreen.main.bounds.size.width/1.2, minHeight: 50).background( RoundedRectangle(cornerRadius: 15).shadow( color: Color.gray.opacity(0.35), radius: 15, x: 0, y: 0))
    }
    
    
    private func pickerFooterButton() -> some  View {
        return HStack {
            Button(action: {
                self.selectedCountryValue = self.viewModel.countriesList[self.selectedCountry]
            }) {
                Text("Select")
                    .padding(EdgeInsets.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(5.0)
            }.padding(10)
        }
    }
    
    private func pickerRow(_ country:Country) -> some View {
        return HStack {
            Text(country.name ?? "").foregroundColor(Color(UIColor.systemBackground))
        }
    }
    
    private func pickerView() -> some View {
        return
            Picker("", selection: $selectedCountry) {
                ForEach(0 ..< self.viewModel.countriesList.count) {
                    self.pickerRow(self.self.viewModel.countriesList[$0])
                }
            }.labelsHidden().frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/4)
    }
    
    private func goNewsPageButton() -> some View {
        
        return  Button(action: {
            //            self.isPickerSelected = !self.isPickerSelected
            UserDefaults.standard.set(true, forKey: "Loggedin")
            UserDefaults.standard.synchronize()
            self.settings.loggedIn = true
        }) {
            Text("Go news Page")
                .font(.headline)
                .foregroundColor(Color(UIColor.systemBackground))
                .frame(minWidth: 100, maxWidth: UIScreen.main.bounds.size.width/1.2, minHeight: 50)
        }.background(RoundedRectangle(cornerRadius: 15)
                        .shadow( color: Color.gray.opacity(0.35), radius: 15, x: 0, y: 0))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
               categoriesField()
               gridView()
               countriesField()
                VStack{
                  pickerView().padding([.leading, .trailing], 20)
                  pickerFooterButton().padding([.leading, .trailing], 20)
                }.background( RoundedRectangle(cornerRadius: 15)
                                .shadow( color: Color.gray.opacity(0.35), radius: 15, x: 0, y: 0))
                
                goNewsPageButton().padding(8.0)
            }.navigationBarTitle("Selection screen")
        }
        .onAppear {
            
        }
    }
}

struct SelectCountriesAndCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCountriesAndCategoriesView()
    }
}
