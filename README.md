# EmployeeDirectory
This is the employee directory app that makes use of the API at https://github.com/dittmar/employee-directory-api

## Build tools & versions used
- Xcode 13.2.1
- Swift 5
- GitHub Actions for CI/CD

## Steps to run the app
- Run the app through Xcode with the Employee Directory scheme
- The app will load with an error message.  This is expected and meant to make it easier to test out the three scenarios for the app, which are empty list, malformed response, and successful response.
- If you tap the button for the "normal" endpoint, you'll see the fairweather path of the app
- The app should fetch all of the employees and load them in a list with their name, e-mail, phone number (if available), and team name.  If no phone is available, "No phone provided" should appear instead
- Pull-to-refresh is implemented to allow users to refresh the list of employees.

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

## What do you think is the weakest part of your project?
My project doesn't really consider the case where a user has bad connectivity or no connectivity.  I think it would be better if it provided more helpful error messages in those states.  The design of the UI is also pretty simple and probably not the most appealing.  I think it would be greatly improved if I had some help from a designer.

## Did you copy any code or dependencies? Please make sure to attribute them here!
I didn't copy any code or dependencies.  However, my project has a dependency on SDWebImage for image caching, which is included via Swift Package Manager.  Otherwise, I used the Apple Developer documentation to remind myself of the syntax for things.

## Is there any other information you’d like us to know?
Nothing that wasn't already covered elsewhere