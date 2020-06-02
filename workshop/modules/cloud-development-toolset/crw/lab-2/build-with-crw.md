# Exercise: Developing with CodeReady workspaces

In this exercise, you will learn how to use Red Hat CodeReady Workspace covering the following topics:
- Create a workspace from an existing Github repo using the Spring boot stack.
- Use the Eclipse Che - Theia based editor to make code changes.
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

![CodeReady Workspace landing page](../../images/ex-crw-landing-page.png)

### Create a new workspace

Create a new workspace using the Springboot stack. 

![CodeReady remove default project](../../images/ex-crw-remove-default-project.png)


![CodeReady remove default project](../../images/ex-crw-add-gitrepo.png)
Add Git repo and Click `CREATE & OPEN`

`Add or Import Project` , select Git and the repo URL you forked earlier.
```
https://github.com/<username>/rhoar-backend
```



And fill it out something like this.

![Save Build Config](../.gitbook/assets/nodejs-build-save.png)

You will see this will not result in a new build. If you want to start a manual build you can do so by clicking `Start Build`. We will skip this for now and move on to the webhook part.
