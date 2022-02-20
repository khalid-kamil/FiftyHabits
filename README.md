# FiftyHabits

## A Simple Habit Tracking App for iOS

#### CS50 Final Project Submission, Khalid Kamil

<img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/main-view.png" width="200">

This app was developed as part of my Final Project in CS50. The project draws on the lessons I learned throughout the course. The app is developed using Swift. The app is still a work in progress which I intend to develop further beyond the course.

### **Overview**

The app helps users track their daily habits. No third party libraries were used to create this project. Since it is common industry practice to move away from storyboards, the views in this app were built in multiple files as opposed to one large storyboard file. This tutorial from Make School was used as a guide for the project. With additional features being developed on top of that. Such as:

- Implementing a search bar in the habits table
- Rearranging the habits using tap and hold instead of the edit button
- Deleting the habits using swipe to delete instead of the edit button

### **Main View**

The Main View consists of a UITableView with the following features:

- "Add New Habit" button

  - Launches the Add Habit View

- Edit button

  - Allows the user to delete and rearrange the order of habits

    <img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/main-view-edit.png" width="200">

- Search bar

  - Allows the user to filter the habit list using keyboard input

    <img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/main-view-search.png" width="200">

- Tap to arrange habits

  - Allows user to rearrange habits without pressing the edit button

    <img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/main-view-tap-arrange.png" width="200">

- Swipe to delete habit

  - Displays a UIAlertController prompting the user to confirm or cancel the habit deletion

    <img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/main-view-delete.png" width="200">
    <img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/main-view-delete-confirm.png" width="200">

### **Add Habit View**

The Add Habit View consists of a Collection View of 16 images representing common habits for the user to choose from. The images are displayed in gray. Once the user selects an image, it displays in its original color.

Once the user is happy with their image selection, they tap the Pick Photo button at the bottom of the screen. Which takes them to the Confirm Habit View.

<img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/habit-creation.png" width="200">
<img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/habit-creation-selected.png" width="200">

### **Confirm Habit View**

The Confirm Habit view displays the users chosen image from the Add Habit View and allows the user to insert a Habit Name in the provided text field.

Once the user is satisfied with their habit name they tap the Create Habit button, which takes them back to the main view and appends the newly created habit to the top of the habits table.

<img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/habit-confirm-input.png" width="200">
<img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/habit-confirm-input2.png" width="200">

### **Habit Detail View**

Tapping on a habit in the main view, displays the Habit Detail View. This view consists of a Stack View containing:

- Habit image
- Current Streak
- Total Number of Completions
- Best Streak Length and
- Streak Starting Date

<img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/habit-detail.png" width="200">
<img src="https://github.com/khalid-kamil/FiftyHabits/blob/main/images/habit-detail2.png" width="200">

At the bottom of the view, exists a button which the user taps to mark the habit as completed each day. Once the habit is marked as complete, the button text displays "Completed for Today!" and a check mark is added to the habit in the main table view.

### **Bugs**

- In the Habit Detail View, the "Created Date" displays the current date as opposed to the date of first completion in the streak.
- In the Confirm Habit View, there is no test or error message to catch and prevent users from creating habits with blank names.

### **Future Plans**

Future developments for this app include:

- An improved visual design
- Allowing the user to upload their own image from the gallery, take a photo using the camera, or select emojis as their chosen image
- Interactive charts that provide more insight into historic streaks and habit information
- Using Firebase for the backend
