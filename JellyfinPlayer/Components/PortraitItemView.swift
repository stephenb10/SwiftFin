//
 /* 
  * SwiftFin is subject to the terms of the Mozilla Public
  * License, v2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at https://mozilla.org/MPL/2.0/.
  *
  * Copyright 2021 Aiden Vigue & Jellyfin Contributors
  */

import SwiftUI
import JellyfinAPI
struct PortraitItemView: View {
    var item: BaseItemDto

    var body: some View {
        NavigationLink(destination: LazyView { ItemView(item: item) }) {
            VStack(alignment: .leading) {
                ImageView(src: item.type != "Episode" ? item.getPrimaryImage(maxWidth: 100) : item.getSeriesPrimaryImage(maxWidth: 100), bh: item.type != "Episode" ? item.getPrimaryImageBlurHash() : item.getSeriesPrimaryImageBlurHash())
                    .frame(width: 100, height: 150)
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    .overlay(
                        Rectangle()
                            .fill(Color(red: 172/255, green: 92/255, blue: 195/255))
                            .mask(ProgressBar())
                            .frame(width: CGFloat(item.userData?.playedPercentage ?? 0), height: 7)
                            .padding(0), alignment: .bottomLeading
                    )
                    .overlay(
                        ZStack {
                            if item.userData?.isFavorite ?? false {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.white)
                                    .opacity(0.6)
                                Image(systemName: "heart.fill")
                                    .foregroundColor(Color(.systemRed))
                                    .font(.system(size: 10))
                            }
                        }
                        .padding(.leading, 2)
                        .padding(.bottom, item.userData?.playedPercentage == nil ? 2 : 9)
                        .opacity(1), alignment: .bottomLeading)
                    .overlay(
                        ZStack {
                            if item.userData?.played ?? false {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.white)
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(.systemBlue))
                            } else {
                                if item.userData?.unplayedItemCount != nil {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color(.systemBlue))
                                    Text(String(item.userData!.unplayedItemCount ?? 0))
                                        .foregroundColor(.white)
                                        .font(.caption2)
                                }
                            }
                        }.padding(2)
                        .opacity(1), alignment: .topTrailing).opacity(1)
                Text(item.seriesName ?? item.name ?? "")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                if item.type == "Movie" || item.type == "Series" {
                    Text("\(String(item.productionYear ?? 0)) • \(item.officialRating ?? "N/A")")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .fontWeight(.medium)
                } else if item.type == "Season" {
                    Text("\(item.name ?? "") • \(String(item.productionYear ?? 0))")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .fontWeight(.medium)
                } else {
                    Text("S\(String(item.parentIndexNumber ?? 0)):E\(String(item.indexNumber ?? 0))")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }.frame(width: 100)
        }
    }
}
