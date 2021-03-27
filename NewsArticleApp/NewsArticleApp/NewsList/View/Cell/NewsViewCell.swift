import SwiftUI

struct NewsViewCell: View {
    var item: NewsModel
    var body: some View {
        VStack(alignment: .center,spacing: 8, content: {
            UrlImageView(urlString: item.urlToImage)
                .frame(width: UIScreen.main.bounds.size.width/1.2, height:200)
            .cornerRadius(15).onTapGesture {
                guard let url = URL(string: item.url ?? "") else {
                  return //be safe
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title ?? "").bold().padding(4)
            Text(item.description ?? "" )
            Divider()
            HStack(alignment: .center){
                Text(item.source?.name ?? "")
                Spacer()
                Text("\(item.publishedAt ?? "") ")
            }
        }
    }).padding(.all,2.0)
    }
}

struct NewsViewCell_Previews: PreviewProvider {
    static var previews: some View {
        NewsViewCell(item: NewsModel(title: "", description: "", source: nil, url: "", urlToImage: "", publishedAt: "", content: ""))
    }
}
