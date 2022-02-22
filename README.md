# EmployeeDirectory
This is the employee directory app that makes use of the API at https://github.com/dittmar/employee-directory-api

## Build tools & versions used
- Xcode 13.2.1
- Swift 5
- GitHub Actions for CI/CD

## Steps to run the app
- Run the app through Xcode with the Employee Directory scheme on any iPhone device.  It will have to be an iOS 15 device or later.  I decided to make use of some of the newer stuff.
- The app will load with an error message.  This is expected, because the app starts off by calling the endpoint that returns an empty list.  This is meant to make it easier for the folks who are running my app to test out the three scenarios for the app, which are empty list, malformed response, and successful response.  I wouldn't send the app to the App Store like this :)
- If you tap the button for the "normal" endpoint, you'll see the fairweather path of the app
- The app should fetch all of the employees and load them in a list with their name, e-mail, phone number (if available), and team name.  If no phone is available, "No phone provided" should appear instead
- Pull-to-refresh is implemented on the employee list to allow users to refresh the list of employees.
- There is basic support for Dark Mode, so feel free to take a look on a phone that's in Dark Mode as well as one that's in Light Mode.

## What areas of the app did you focus on?
I focused on modularity, extensibility, and testing.
- Modularity: The API is separated into a Swift Package so that it can be wholly separate from the actual app.  This allows us to test the API client and manage its releases wholly independently from the app.
- Extensibility: Anything that could be modeled as a protocol with conforming implementations was.  The reason for doing this was so that we can easily add new features to the app by either adding to the protocols, creating new protocols that the implementations coudl conform to, or even trading out the existing implementations of components for pretty anything that conforms to the same protocol.  Essentially, I tried to take as much of a protocol-oriented programming approach as possible.  In past projects, this has helped immensely with unit testing and refactoring.
- Testing: I tried to make heavy use of view models so that UIKit view classes were doing as little as possible, since anything touching the view controller life cycle is difficult to test.  I also made sure that the view models supported dependency injection for any of their dependencies (e.g., the API or the image loader) to make it possible to test the view models without needing to test those dependencies at the same time.  That made it easier to test those dependencies separately.

On a separate note, I also made sure to make use of async/await rather than using a more traditional closure-driven asynchronous approach.  I find that async/await makes the code easier to follow, which makes it easier to understand, review, and test.

## What was the reason for your focus? What problems were you trying to solve?
I wanted to create a Model-View-View Model solution that had a separate API and a focus on testing from the start.  In past projects I've worked on, delaying unit testing in the beginning has led to poor code coverage that was very time and labor intensive to fix.  The same can be said for dumping everything related to the app into one target instead of breaking it up into modules.  That's why I broke the API out into its own Swift Package.  Essentially, I was trying to create an employee directory app that serves as a good foundation for iterating on and improving.

## How long did you spend on this project?
About 6 hours on the app portion of the project

## Did you make any trade-offs for this project? What would you have done differently with more time?
I kept the app and the UI pretty simple in favor of focusing on the architecture of the app and testing.  I also tried to focus on CI/CD by setting up GitHub Actions to run unit tests when a branch is updated.  With more time, I'd probably improve the bad network/no network functionality of the app.
I would also try to make the app more compatible supporting a minimum iOS SDK below iOS 15.  In general, I would probably target iOS 13, since that seems to be the oldest version of iOS that still has a decent number of users.  Unfortunately, I didn't have the time to create the fallbacks for iOS 13 for the code that makes use of features only available in iOS 14+, specifically some async/await related features.  However, I think it's important to continue to support older versions of iOS since a sizable minority of the iOS user base tends to be at least a major iOS version or two behind.  This is especially true when considering older phones that can't update to the newest version of iOS.  I find that it's often a balancing act between supporting users who can't or won't upgrade and bumping the minimum iOS SDK up to be able to make use of newer features.  I personally prefer to only bump the minimum iOS SDK when necessary (e.g., for a reason involving security) or when the user impact is very low (e.g, less than 1% of the active user base).

## What do you think is the weakest part of your project?
My project doesn't really consider the case where a user has bad connectivity or no connectivity.  I think it would be better if it provided more helpful error messages in those states.  The design of the UI is also pretty simple and probably not the most appealing.  I think it would be greatly improved if I had some help from a designer.

## Did you copy any code or dependencies? Please make sure to attribute them here!
I didn't copy any code or dependencies.  However, my project has a dependency on SDWebImage for image caching, which is included via Swift Package Manager.  Otherwise, I used the Apple Developer documentation to remind myself of the syntax for things.

## Is there any other information you’d like us to know?
Nothing that wasn't already covered elsewhere