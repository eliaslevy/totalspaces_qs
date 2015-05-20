# TotalSpaces QuickSilver Integration

These set of AppleScript scripts and Ruby command line utility allow for the integration of TotalSpaces and QuickSilver.

The scripts provide the following actions:
* `Add Space`
* `Rename Space`
* `Remove Space`
* `Switch Space`
* `Move to Space`

`Remove Space`, and `Switch Space` are two pane actions that take a string in the first pane that represents the space name.

`Add Space`, `Rename Space`, and `Move to Space` are three pane actions.

`Add Space` takes a string as the space name in the first panel and a display in to create the space in as the third panel.

`Rename Space` takes a string as the space name in the first panel and a string as the new space name in the third panel.

`Move to Space` takes the Current Focused Window proxy object in the first panel and a string as the space name in the third panel.

You can pass a partial space name to `Rename Space`, `Remove Space`, `Switch Space` and `Move to Space` and they will find the matching space to operate on. If more than one space matched, they will present an error and abort.

Space names are compared in a case insensitive manner.

`Add Space` will not allow you to create more than one space with the same (case insensitive) name.

## Setup

The `Add Space` action requires `Displays Plugin` to select the display to create the space on.

The `Move to Space` action requires the `User Interface Plugin` to select the Current Focused Window.

* Install the `totalspaces` Ruby gem.  Make sure is available system wide.
* Copy `spaces.rb` to `~/bin` and make it executable.
* Copy `scripts/*.scpt` to `~/Library/Application Support/Quicksilver/Actions`.
* Install and enable the Quicksilver Displays Plugin.
* Install and enable the User Interface Plugin.
* Restart Quicksilver.

