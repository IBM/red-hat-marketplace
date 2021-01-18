# Exercise: Developing with CodeReady workspaces

In this exercise, you will learn how to use Red Hat CodeReady Workspace covering the following topics:

- Create a workspace from an existing Github repo using a NodeJS application.
- Explore the Che-Theia editor.
- Execute build and run commands from the workspace.
- Run the project in the debug mode.
- Test code changes.
- Check-in the code changes back in into the git project.

## Create your CodeReady Workspace

Fork this Git repo from the Git repo link given below into your private Git account. A complete set of Che samples projects can be found [here](https://github.com/che-samples).

```bash
https://github.com/redhatmarketplace/nodejs-mongodb-sample.git
```

Access your CodeReady Workspace using the link provided by the instructor. You should see a screen as shown below:

![CodeReady Workspace landing page](images/ex-crw-landing-page.png)

### Create a new workspace

Create a new workspace using the NodeJS MongoDB sample application stack.
Click on `Add Workspace`.

Enter the name of the wortspace: `node-mongo-webapp`.
Select `NodeJS MongoDB Web Application` from the list of available stacks.

![Create new workspace](images/ex-crw-node-mongodb-project.png)

Click the `Remove` button to delete the default project.

![Remove default project](images/ex-crw-remove-default-project.png)

`Add or Import Project` , select the `Git` tab and then add the repo URL you forked earlier.

```bash
https://github.com/<username>/nodejs-mongodb-sample.git
```

![Add git project](images/ex-crw-add-gitrepo.png)

`Add` the project and Click `CREATE & OPEN`. The workspace should open once
it is created.
[Note:

- Images for the workspaces (plugin broker, plugin artifacts) are pulled and containers are created.
- Plugin extensions are downloaded and installed.
- Images required for the configured stack (JWT proxy, MongoDB, NodeJS) is pulled.
- The workspace can about 2-5 minutes to startup.]

![CodeReady Workspace Installed](images/ex-crw-workspace-ready.png)

### Explore Che-Theia editor

Click on the `Explorer: /Projects` icon to view the files under the `nodejs-mongodb-sample` project. Navigate and open the `app.js` file:

![Open project](images/ex-crw-open-project.png)

Notice that the Che Theia editor identifies the project as a NodeJS project and the syntax highlighting is already in place. More about how to use the Theia workspace can be found [here](https://eclipsesource.com/blogs/2019/10/04/how-to-use-eclipse-theia-as-an-ide/)

To view the installed plugins select `View > Plugins` and apply filter by selecting `Show Installed Plugins` from the search bar.

![CodeReady Workspace Installed](images/ex-crw-installed-plugins.png)

#### Workspace and commands

Click on `My Workspace: Workspace` icon (cube) on the right of the editor to view the list of available runtime and plugin commands. [Also available via menu: `View > Open View > Workspace` ]

![CodeReady Runtime commands](images/ex-crw-workspace-commands.png)

#### Using the terminal

Note that there are three commands are available under `nodejs`.  Click on `>_ New terminal` to open a command terminal build into the editor. Run the commands as shown below:

```bash
cd nodejs-mongodb-sample
ls -al
node --version
```

![CodeReady Runtime Terminal](images/ex-crw-workspace-nodejs-terminal.png)

You could run an `npm install` from the command terminal to build the application, however, let's build and run the application using the workspace command.

#### Install and run the application

Open the file `routes > messages.js` and replace the `#SERVERNAME#` with the pod id address from the previous step.

![MongoDB Credentials](images/ex-crw-workspace-mongodb-creds.png)

Run the guestbook application by clicking on `run the application` from the list of workspace commands. This triggers a build with the `npm install` command.
Click `Open link` when the dialog pops up asking confirmation to launch the preview pane.

![Build project](images/ex-crw-project-preview-launch.png)

This opens the Guestbook application in the preview panel. Enter data to see the messages show up in the guesbook. Note that the data entered here is being persisted in the MongoDB database. Click on the `Open in a new window` icon next to the URL field to view the guestbook app in a new browser tab.

![Run and preview](images/ex-crw-run-preview.png)

### Verify data in MongoDB database

Data can viewed using the MongoDB client CLI or a UI tool such as MongoDB Compass.

Open the mongo terminal in the workspace by clicking the `>_ New terminal` under `mongo`.
Run the following commands:

- Get the mongo shell version `mongo --version`
- Connect to the database: `mongo "mongodb://user:password@localhost:27017/guestbook"`
- Show database collections: `show collections`
- View data in the collection: `db.messages.find({})`

![Verify data](images/ex-crw-mongo-verify-data.png)

### Run the project in the debug mode

Open the file app.js and set the break-point at line 48 as shown below in the `router.post` function.

![Set breakpoint](images/ex-crw-set-breakpoint.png)

Selecting `Debug > Start Debuggin` from the menu. This switches the editor in debug mode by opening all the associated views.

![Start debugging](images/ex-crw-start-debug.png)

Enter test data in the guestbook app and submit the form. The debugger should pause at the set breakpoint. Add the variable `"name"` as the watch expression and click on `Set over` icon in the debug panel. The screen below shows the outcome of the above steps.

![Debug panel](images/ex-crw-debug-panel.png)

Finally, click on the continue icon and then to stop icon to finish debugging.

### Make code changes

Open the file `views > home.pug` and change the title header `My Guestbook` to `My Guestbook with CRW`.

![Edit Source](images/ex-crw-edit-view.png)

Rerun the application to view the changes in the preview panel.

![Preview changes](images/ex-crw-preview-changes.png)

### Git Operations

The Git features in the Theia editor works the same way as it does in the VSCode editor.
Git commands can be run from the UI or builtin command palette or the nodejs terminal. We will use the UI for this exercise.

Swith to the git view by selecting the git icon from the left navigation. The change list should show two files.

![Git view](images/ex-crw-change-list.png)

Hover over the messages.js file and click on the `discard changes` icon. Confirm to discard changes. This leaves with one file with code changes.

Hover over the file `home.pug` and click on the `+` icon to stage changes.

Click on the `Commit` icon, type in a commit message and press enter.

![Commit changes](images/ex-crw-code-commit.png)

Use the drop down menu to select `Push to` and select the branch `origin`.
Enter your git userid and password. Verify the changes in the git repository.

![Push changes](images/ex-crw-code-push.png)

#### Setup Git configuration

Open `File > Settings > Open Preferences > Git` from the menu.  Right click on the properties `user.email` and `user.name` and select `Add value`. Enter the email id and name used by your git account. These settings take effect at global level and will apply to all the new workspaces.

![CodeReady file changes](images/ex-crw-git-preferences.png)

### Summary

Thislab demonstrated how CodeReady workspaces can be an alternate development environtment for enterprises.
