<h1 align="center">Welcome to invoke-build-tasks 👋</h1>
<p>
</p>

## Purpose

This is a set of various [InvokeBuild](https://github.com/nightroman/Invoke-Build) tasks that do generic task/automation work.

For setting up a project, having some nice tasks setup like this can increase velocity and ease of standardization, formatting, and more.

Tasks can include items such as:

- Formatting go, powershell
- Docker build for codespaces
- build a markdown page containing details on tasks for references
- bootstrap a projects documentation layout
- install powershell module dependencies
- cleanup artifacts
- generic build notifications for github, datadog, teams, slack or whatever else gets added.


## Why InvokeBuild

The short answer is it's a pretty powerful framework for running tasks and has proven to be extremely reliable for me.
It's also relatively easy to quickly extend once you work through understanding how it works.

Long term I probably will explore more, but for now this provides a rapid productivity gain in a project to improve local development workflow.

Add this to your `$PROFILE` file: `New-Alias ib 'invoke-build' -force` and then you can benefit from quickly running commands such as:

Format your code across multiple languages.

```powershell
ib tidy
```

Example worklow that might be created:

```powershell
ib clean, build, s3-upload-directory, notify-slack
```

In addition to easy commands from the terminal, this project uses the VSCode integration so you can have all the tasks show up as VSCode tasks.
If you leverage Task Explorer Extension, you can just hit the run button as well and trigger activities from there.
## Show your support

Give a ⭐️ if this project helped you!

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://www.sheldonhull.com/"><img src="https://avatars.githubusercontent.com/u/3526320?v=4?s=100" width="100px;" alt=""/><br /><sub><b>sheldonhull</b></sub></a><br /><a href="https://github.com/sheldonhull/invoke-build-tasks/commits?author=sheldonhull" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
