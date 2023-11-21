# Bracker

## Bracker is an app designed for readers to keep track of what books they have read and what they thought about those books immediately after finishing them. It allows readers to reference a library to discuss with other readers how they felt about a particular book and be able to reflect back on their initial opinions and how they may have changed after a while.

This app was created as an individual project for CS329 (IOS Development).

To run this project, Xcode version 15.0.1 was used. That would probably be the requirements needes to run, but I believe this project can be run on most Xcodes.

To test this app, using the inbuilt simulator (preferably iPhone 15 as that was the simulator I was using when testing) from Xcode would be for the best as the app in an actual iPhone is buggy and crashes. Portrait mode is also ideal as the formatting of the app looks better. There is no test account with sample data loaded in as a lot of the data from the app in very local to the phone and isn't spread through cloud. Hence it is best to start off with creating your own account for better experience of the app rather than using an account that has been registered in Firebase for now.

## Checklist of each feature:
### Settings:
- [x] Font Size:
  - Users are able to change the font size of their book reviews so if the text is too small, they can make it larger for easier viewing. <br>
- [x] Dark Mode:
  - Users are able to locally change their app to dark mode if they choose to add a book review at night and change it back to light mode if they prefer the lighter version.

### Non-default Fonts and Colors used:
- [x] Fonts: Unica One-Regular is the font used for most of the title information while Josefin Sans-Light is the font used for all of the text containing pertinent information (user information and book reviews). <br>
- [x] Colors: The color schematics of the app was a blue that was easy on the eyes. <br>
  - There were around 5 colors used in total with the following hex codes: <br>
    - Dark Blue: `#1F657C`<br>
    - Medium Blue: `#66B6D0` <br>
    - Blue: `#ADD8E6` <br>
    - Grey Blue: `#C9E2EB` <br>
    - Light Blue: `#DAF4FD` <br>
  - They were coordinated around to make the dark and light styles of the app which can be further examined in the assets folder.

### Two Major Elements Used
- [x] Login/register path with Firebase:
  - The first major element that I used was the login/register path with Firebase. At the beginning of the app, users are able to log in with their own accounts and create new accounts if they choose to. The books saved are local to each phone, unfortunately, so if multiple people want to save their book reviews on one device, this allows for some privacy between user data. <br>
- [x] User Profile path using camera and photo library:
  - The second major element that I used was creating a User Profile path using the camera and photo library in the profile settings of my app. Users are able to update their name and login information as well as add a fun little profile picture if they choose to do so. They can choose to upload a picture from their photo library or take one while they have the app open. <br>

### Minor Elements Used
- [x] Two additional view types: 
  - A switch was used to determine whether dark mode was flipped on or off. This can be found on the app settings page.
  - A slider was used to determine the font size. It slides in discrete values to pick from 3 different font size options: small, medium, and large. This can also be found on the app settings page.
  - Text views were used to write out the summaries and book reviews of the books that users have read as text fields are one line whereas text views can be multiple lines.  <br>
- [x] Collection View:
  - A collection view was used to be able to properly demonstrate the books in a digital bookshelf-like manner. If a user presses and holds onto a book for around 1 second, then they will be given the option to delete the book from their bookshelf. <br>
- [x] Alerts, Popovers, and User Defaults:
  - Alerts were used to ask users if they were sure about deleting a book. When a user long presses on a book in their bookshelf, an alert message will pop up to ask users if they are sure about deleting a review. Furthermore, alert messages are used to alert users when their passwords don't match in their profile settings as they change their password as well as to alert users if they have not completed their book review in its entirety (i.e. if they are missing text in the review section, then an alert will pop up to tell them that they need to finish that before saving their book review). Finally, alerts are used when picking out a profile picture to allow users to decide whether they want to choose a profile picture from their camera roll or their photo library. <br> 
  - A popover was used as a mini menu from the main screen to transition from the bookshelf to the user profile settings, app settings, and the login page upon logging out of the app. <br>
  - User Defaults were used to help set user names and emails to implement them already in the profile settings page so users would have to manually delete and change them just like other profile settings page that have the user information set.
- [x] Core Data and Gesture Recognition:
  - Core Data was used to store the local book review information of users and the user information for saving the profile picture locally to the user's device. Core Data also implemented the functionality of specific books to specific users so one user can only access the books they have read and cannot access the books that another user has read. The downside to this is that the data becomes very local to the device so users see different books across different devices if they don't save the same books across each device they use.
  - Gesture recognition was used so users could tap to select the star rating they would give a book (unfortunately, the stars are in integers so no half stars are allowed) as well as to be able to tap on the screen to dismiss the keyboard. 
    
    
