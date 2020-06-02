# Exercise: Developing with CodeReady workspaces

In this exercise, you will learn how to use Red Hat CodeReady Workspace covering the following topics:

- Create a workspace from an existing Github repo using the Spring boot runtime.
- Explore the Che-Theia editor.
- Define and exectue commands from the workspace.
- Run the project in the debug mode.
- Push the code changes back in the Git repo.
- Customize workspace to meet your project requirements.
- Use of factory to share workspaces with your development team.
  
### Create your CodeReady Workspace

Fork this Git repo into your priate account.
```
  https://github.com/rojanjose/rhoar-backend
```

Note: This repository was created using the [Red Hat Developer Launcher tool](./exercise-codeready-launcher.md). 

Access your CodeReady Workspace using the link provied by the instrcutor. You should see a screen as shown below:

![CodeReady Workspace landing page](images/ex-crw-landing-page.png)

### Create a new workspace

Create a new workspace using the Springboot stack.
Enter the name of the your wortspace: `userXX-springboot`
Select `Java Spring Boot` from the list of available stacks. Click the `Remove` button to delete the default project.

![CodeReady remove default project](images/ex-crw-remove-default-project.png)


`Add or Import Project` , select the `Git` tab and then add the repo URL you forked earlier.
```
https://github.com/<username>/rhoar-backend
```
![CodeReady remove default project](images/ex-crw-add-gitrepo.png)

`Add` the project and Click `CREATE & OPEN`. The workspace should open once its created: (takes about 2-5 minutes to startup)

![CodeReady Workspace Installed](images/ex-crw-workspace-ready.png)
TODO: show the pod that runs the workspace.
### Explore Che-Theia editor

Click on the `Explorer: /Projects ` icon to view the files under `spring-boot-http-booster` project. Navigate and open the java file:

```
src/main/java/dev/snowdrop/exmaple/service/ExampleApplication.java
```
![CodeReady Workspace Installed](images/ex-crw-open-project.png)

Notice that the Che Theia editor has idenfitifed the project as a  java project and the syntax highlighting is already in place. More about how to use the Theia workspace can be found [here](https://eclipsesource.com/blogs/2019/10/04/how-to-use-eclipse-theia-as-an-ide/)


To view the installed plugins select `View > Plugins` and apply filter by selecting `Show Installed Plugins` from the seach bar.

![CodeReady Workspace Installed](images/ex-crw-installed-plugins.png)
 

### Define and exectue commands from the workspace

The [Devfile](https://www.eclipse.org/che/docs/che-7/configuring-a-workspace-using-a-devfile/) defines the configuration of the workspace including the command definitions. 

![CodeReady Devfile](images/ex-crw-devfile.png)
 
Note the commands are defined for `build, run, debug, test, dependency-anaysis, deploy to OpenShift`.

Let's start with the build. Click in `View > Workspace` to view the list of available runtime commands.

![CodeReady Runtime commands](images/ex-crw-workspace-commands.png)

Click on build under `User Runtimes > maven > build`

![CodeReady Bbuild project](images/ex-crw-project-build.png)

Run the project by clicking `run` from the workspace. Click `Open link` when the dialog pops up asking confirmation to luanch the preview pane. Click on `8080/tcp` from the User Runtimes to open the application in a new tab.

![CodeReady run and preview](images/ex-crw-run-preview.png)

Open the static resource file index.html file and update the text. Change the greetings by adding the text `CodeReady workspaces`, save the file and refresh the preview page to see the changes.

```
src/main/resources/static/index.html
```

![CodeReady test code changes](images/ex-crw-code-change.png)

### Run the project in the debug mode

Open the file ExampleApplication.java
```
src/main/java/dev/snowdrop/exmaple/service/ExampleApplication.java
```
Insert a print statement in the method jsonProvider() and set a breakpoint by click next to the line number as show in the picture below:
```
System.out.println("Testing break point...");
```
![CodeReady set breakpoint](images/ex-crw-set-breakpoint.png)

Open the `Output` console by selecting `View > Output` from the menu.
Start the application in debug mode by selecting `debug` from the `My Workspace` pane on the right.

![CodeReady start debugging](images/ex-crw-start-debug.png)

Start the debugger by selecting `Debug > Start Debugging` from the menu. This should open the `Debug` view and flow will stop at the set break point.

![CodeReady reach breakpoint](images/ex-crw-reach-breakpoint.png)

Step over the code using the controls available in the debug page. 
![CodeReady debug panel](images/ex-crw-debug-panel.png)

Open the link to launch the preview of the UI.

### Push the code changes back in the Git repo

Commit changes
![CodeReady commit changes](images/ex-crw-git-commit.png)

Push changes

![CodeReady commit changes](images/ex-crw-git-push.png)

### Customize workspace to meet your project requirements



### Use of factory to share workspaces with your development team


