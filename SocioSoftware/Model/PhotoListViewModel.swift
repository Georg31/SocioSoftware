//
//  PhotoListViewModel.swift
//  SocioSoftware
//
//  Created by George Digmelashvili on 9/21/21.
//

import Foundation


struct PhotoListViewModel {

    var photos = [PhotoViewModel]()
    var photosCount: Int {
        return photos.count
    }
    func videoAtIndex(_ index: Int) -> PhotoViewModel {
        return self.photos[index]
    }
}

extension PhotoListViewModel {

    init(data: PhotoData) {
        self.photos = data.hits.map({PhotoViewModel($0)})
    }
}

struct PhotoViewModel {

    private let photo: Hit
}

extension PhotoViewModel {

    init(_ photo: Hit) {
        self.photo = photo
    }

    var imgUrl: String? {
        return photo.largeImageURL
    }

    var imgPreviewUrl: String? {
        return photo.previewURL
    }
}
