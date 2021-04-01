import SwiftUI
import Combine

struct SelectCountriesAndCategoriesView: View {
    
    @EnvironmentObject var settings: UserSettings
    
    @ObservedObject var viewModel = SelectCountriesAndCategoriesViewModel()
    @State private var selectedCountry = 0
    @State private var selectedCountryValue:Country? = nil
    @State var selectedCategories: [String] = []
    
    private var categoriesField: some View {
        Text("Please Select 3 Favorite")
            .font(.headline)
            .foregroundColor(Color(UIColor.systemBackground))
            .frame(minWidth: 100, maxWidth: UIScreen.main.bounds.size.width/1.2, minHeight: 50)
            .background(RoundedRectangle(cornerRadius: 15)
                            .shadow( color: Color.gray.opacity(0.35), radius: 15, x: 0, y: 0))
    }
    
    private var gridView: some View {
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
    
    private var countriesField: some View {
        return Text(selectedCountryValue?.name ?? "Please Select Country")
            .font(.headline)
            .foregroundColor(Color(UIColor.systemBackground))
            .frame(minWidth: 100, maxWidth: UIScreen.main.bounds.size.width/1.2, minHeight: 50).background( RoundedRectangle(cornerRadius: 15).shadow( color: Color.gray.opacity(0.35), radius: 15, x: 0, y: 0))
    }
    
    
    private var pickerFooterButton: some  View {
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
    
    private var pickerView: some View {
        return
            Picker("", selection: $selectedCountry) {
                ForEach(0 ..< self.viewModel.countriesList.count) {
                    self.pickerRow(self.viewModel.countriesList[$0])
                }
            }.labelsHidden().frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/4)
    }
    
    private var goNewsPageButton: some View {
        
        return  Button(action: {
            let isSelectedCountry = selectedCountry != 0
            let isSelectedCategory = self.selectedCategories.count == 3

            if isSelectedCategory && isSelectedCountry {
                let userDefaults = UserDefaults.standard
                userDefaults.set(selectedCategories, forKey: "selectedCategories")
                userDefaults.set(self.viewModel.countriesList[selectedCountry].country, forKey: "selectedCountry")
                userDefaults.set(true, forKey: "isSelected")
                UserDefaults.standard.synchronize()
                self.settings.isSelected = true
                
            } else {
                viewModel.isShowAlert = true
            }
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
               categoriesField
               gridView
               countriesField
                VStack{
                  pickerView.padding([.leading, .trailing], 20)
                  pickerFooterButton.padding([.leading, .trailing], 20)
                }.background( RoundedRectangle(cornerRadius: 15)
                                .shadow( color: Color.gray.opacity(0.35), radius: 15, x: 0, y: 0))
                
                goNewsPageButton.padding(8.0)
            }.navigationBarTitle("Selection screen")
        }
        .onAppear {
            
        }.alert(isPresented: $viewModel.isShowAlert) {
            Alert(
                title: Text(""),
                message: Text($viewModel.alertMessage.wrappedValue),
                primaryButton: .destructive(Text("You should select country and 3 Favorite item"), action: {
                    // ok action
                }),
                secondaryButton: .default(Text("Cancel"), action: {
                    // do something
                })
            )
        }
    }
}

struct SelectCountriesAndCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCountriesAndCategoriesView()
    }
}
