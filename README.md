Requirements

App navigation based on tabbar with 3 tabs: topics, tasks, bookmarks; tabs include navigation controllers
Universal app, supports orientation change on iPad, portrait only on iPhone.
Dark theme support

Stage 1: online only
Stage 2: online + offline cache (core data)
?

Screen 1.1: Topics list
Title: Topics
Displays list of topics in table view, option to add new topic.
Future: add sorting (created, due date, status, name), add search by title
Cell contains: 
- topic name
- topic status (unstarted, on_hold - grey, in_progress - blue, done - green)
- due date (show if not "done"; before due date - "due in X day(s)"; on due date - "today", orange; after due date - "X day(s) overdue", red)
Cell supports swipe to delete.
Advanced: swipe to change status
Tap on cell - push Screen 1.3

Button "+" in navigation bar - navigate to add new topic - push Screen 2.
Advanced: Display Screen 1.2 in modal or popover.



Screen 1.2 (2): Create/Edit Topic
Title: corresponds to current state - Create or Edit Topic
Sets up main topic's properties.
Buttons Cancel and Save in navigation bar.
Fields:
- Title - required
- Due date (calendar) - required, default value - +7 days from now
- Status - required, default - unstarted
Cancel - confirms if there were changes made, resets changes, closes current screen
Save - validates input, saves on BE, if successful - close screen, show success message; if error - show error, stay on screen.


Screen 1.3: Topic details
Title: topic name
Edit button in navigation - opens Screen 1.2.
Once screen opened - load list of question for the topic and update number on Questions button bellow.

Top half of the screen: text view for notes. Notes not editable by default. Edit button near textview. Edit button allows to edit text, brings focus into textfield. button changes to Save. On save - submits change, ends editing
Free space: list of links (table). "+" button to add link (figure out UI). Swipe to delete link.
Bottom part: status (string), due date (string) - not editable, "Questions (n) > " button - switch to Screen 4, shows spinner and disabled while loading. 


Screen 1.4: Questions
Title: Questions
"+" in nav bar to add question - Screen 1.5
Collection view with list of questions (cards). Adjust number of cells in row to screen width. Cells display full info of the questions
Cell:
- question text
- answer text if provided
- checkmark if done
Tap on cell - open editing (Screen 1.5)
Swipe to delete question.


Screen 1.5: Add/Edit question
Title: corresponds current state: Add or Edit Question
Cancel and Save buttons in nav bar (similar to Screen 1.2)
On screen:
- question Text View - required
- answer Text View - optional
- done - Switch
Handle keyboard properly


Screen 2.1
Title: Tasks
"+" button in nav bar to add task, presents Screen 2.2 (popover)
Table list of tasks.
Cell:
- description text (cross out text when progress == 1)
- background fill green from left to right according to percentage complete, but clean when complete
- checkmark - shown when complete
Swipe to delete
Tap - present editing popover Screen 2.2
Long tap to complete


Screen 2.2
No navigationhow 
Description - text field - required
Progress - slider 0-100%, step - 5%
Save button - validates, sands changes, dismisses screen on success.
Tap outside popover to cancel


Screen 3.1
Title: Bookmarks
"+" in nav bar to add
table list of bookmarks.
Cell
- name (if exists, otherwise text)
- text (in smaller font, if there is name)
Swipe to delete
Tap to copy text to clipboard, or open in Safari if text is valid link
Long tap to edit.
Adding/Editing - alert with 2 textfields.
Alert message: Add or Edit bookmark
Textfield1: placeholder "name" (optional)
Textfield2: placeholder "text" (required)
