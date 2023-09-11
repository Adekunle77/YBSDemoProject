# YBSDemoProject

**Objective:**
In the YBS take-home project, my primary goal was to create an application that enables users to search for images, display them, and provide additional details about each image or its photographer.

*Disclaimer:*
Upon testing the API, I realized that it couldn't fulfill the original project requirements. The JSON data lacked essential information for listing user IDs, user icons, or fetching more images by the same user. As a result, I pivoted the project's focus to allow users to save their favorite images. The project was created with Swift version 5.5. I have a 2015 Mac, it can't install the latest Xcode update.

**Project Design:**
After reevaluating the project, I structured it into three key components:

1. **Image Caching:** I implemented an image caching mechanism to optimize image loading and improve the user experience.
2. **Persistence Layer:** I introduced a persistence layer for data storage, ensuring the app's ability to store and manage user-favorite images.
3. **Networking:** The networking component handles API requests and data retrieval from external sources.
4. **View:** The view component is responsible for presenting the user interface and interacting with the user.

This revised project design aimed to provide a more practical and user-centric experience by focusing on image caching and the ability to save and manage favorite images.

**Caching Images - Kingfisher SDK**
The KingFisherCache class serves a critical purpose in our project by efficiently managing image caching, contributing to an enhanced user experience. The decision to implement image caching was driven by the aim to prevent the display of missing images in the UI. 

By caching all images immediately after they are downloaded from the initial API request, we ensure that subsequent views load images seamlessly, reducing load times and data usage. This approach significantly enhances the overall user experience, as images are readily available for display without delay.

The choice of the Kingfisher framework aligns perfectly with our project's needs, offering a robust and user-friendly solution for image caching. Its versatility and ease of integration empower us to manage image caching effortlessly, ensuring our app delivers a smoother and more reliable visual experience.

In essence, the KingFisherCache class, with its image caching capabilities, aligns with our project's user-centric approach, contributing to faster and more reliable image rendering, ultimately improving the app's usability and user satisfaction.

**The Persisteance Layer** 
I implemented the PersistenceFactory and the CoreDataProvider class, both adhering to the Persistable protocol, to bring several benefits to my project, both in terms of current functionality and future scalability.

1. **Abstraction and Modularity:** 
With the PersistenceFactory, I can abstract the selection of storage mechanisms, like CoreData or potentially other storage options in the future. This modularity allows me to switch or expand data storage strategies without altering other parts of my codebase.

2. **Ease of Testing:*** 
By separating the data persistence logic into the CoreDataProvider class, I enable easier testing of this critical component. I can create mock implementations of the Persistable protocol to facilitate unit testing of other project components that depend on data storage.

3. **Scalability and Future-Proofing:** 
As my project evolves, I may need to incorporate additional data storage solutions or optimize existing ones. The PersistenceFactory and Persistable protocol provide a structured foundation to seamlessly integrate new storage options or improve existing ones, ensuring my project remains adaptable and maintainable.

4. **Consistency and Code Quality:** 
The implementation of data persistence in the CoreDataProvider class ensures consistency in how data is saved, retrieved, updated, and deleted. This consistency enhances my code quality, reduces the likelihood of bugs, and simplifies maintenance.

5. **Separation of Concerns:** 
The use of the Persistable protocol and related classes adheres to the principle of separation of concerns. It isolates data storage operations from other parts of my application, making my codebase more organized, understandable, and maintainable.

**The Network Layer** 
I created the NetworkManager class using Combine to simplify networking in our app. It encapsulates network complexities, offering an abstracted interface for other parts of the code. By returning an AnyPublisher, it aligns well with async operations, improving code readability. Combine's mapError and eraseToAnyPublisher streamline error handling. In essence, this design choice enhances code modularity, making our app more maintainable and readable while efficiently managing network-related tasks.

**The View - MVVM** 
The adoption of the MVVM (Model-View-ViewModel) design pattern in our project, embodied by the PhotosViewModel, is crucial. MVVM enhances code organization and maintainability by separating UI logic (View) from data (Model) into the ViewModel. This pattern streamlines the development process, promoting a clear separation of concerns and facilitating testing. The ViewModel's @Published properties enable automatic UI updates, ensuring a responsive user interface. Additionally, dependency injection makes the ViewModel flexible and testable. In summary, MVVM with the PhotosViewModel enhances code structure, fosters reactivity, and simplifies development, resulting in a more maintainable and user-friendly application.

**Overall Summary:**
In developing my project, I made several crucial decisions to enhance its structure, maintainability, and overall user experience. If I were to embark on the project again, I would reaffirm these decisions and potentially expand on certain aspects given more time and resources.

Firstly, I embraced the MVVM (Model-View-ViewModel) design pattern, which helped separate concerns, making the code more organized and maintainable. I would unquestionably stick with this decision if I had to start over, as it greatly simplifies UI logic and data management.

Given more time, I would allocate additional resources to testing. Testing is paramount in ensuring the robustness and reliability of the codebase. Extensive testing not only helps catch and rectify potential issues but also aids in maintaining code quality over time.

Furthermore, with extra time at my disposal, I would consider creating a central repository object responsible for persisting and caching each fetched element, thereby optimizing data retrieval and enhancing the overall app performance. Here's an example of how such a central repository might look in code:

```swift
class CentralRepository {
    static let shared = CentralRepository()
    
    private var cachedData: [String: Any] = [:]
    
    func cacheData<T>(key: String, data: T) {
        cachedData[key] = data
    }
    
    func retrieveCachedData<T>(key: String) -> T? {
        return cachedData[key] as? T
    }
    
    func clearCache() {
        cachedData.removeAll()
    }
}
```

This centralized approach streamlines data access and ensures consistency throughout the application.

In terms of the technical aspects of the code, let's take the PhotosViewModel class as an example. This ViewModel effectively abstracts and manages network requests, data caching, and error handling. Its use of Combine for reactive programming ensures responsiveness and a smooth user experience. It adheres to best practices, promoting code modularity and separation of concerns, and encapsulates complex operations, such as image caching, in a clean and organized manner.
In summary, the decisions made in the project, including MVVM adoption, the emphasis on testing, and the concept of a central repository, have been instrumental in creating a well-structured and maintainable codebase. These choices underscore the importance of thoughtful design and coding practices in delivering a high-quality and user-friendly application.
