## Intro
This repo aims to provide a containerised environment for submitting changes to OpenStack projects.

## Before you begin
You'll need an [Ubuntu One](https://login.ubuntu.com/) account, which you use to log into [Gerrit](https://review.opendev.org). Here, you need to add a public SSH key to your profile and then use the private key when pushing your changes.

## Build
When building an image, you need to specify arguments for configuring `git`:

```sh
$ docker build . \
--build-arg GIT_USERNAME="Firstname Lastname" \
--build-arg GIT_EMAIL=your_email@youremail.com \
--build-arg GERRIT_USERNAME=yourgerritusername \
-t openstack-contrib:latest
```

All of the arguments are required and omitting any one of them will result in an error message like this one:

```
The command '/bin/sh -c git config --global user.name $GIT_USERNAME' returned a non-zero code: 1
```

You can bake an existing git config into the image by placing it in `gitconfig` in this directory.

## Usage
Most projects will want you to create a bug report on [Launchpad](https://launchpad.net/openstack) first. Use your Ubuntu One account to log in here and head to the "Bugs" tab on the project's subpage.

Once you're ready to submit your change, run the following commands:

```sh
git clone https://opendev.org/openstack/<project-name>
cd <project-name>
# Create your feature branch (call it something like "bug-<bug-number>") and modify the files but don't commit yet
docker run -dit --name openstack-contrib -v <private-SSH-key>:/root/.ssh/id_rsa:ro -v <public-SSH-key>:/root/.ssh/id_rsa.pub:ro -v $(pwd):/repo openstack-contrib:latest bash
git-review -s
# git add, git commit, ...
reno new <some-name>
# Some projects, like kolla-ansible, may ask to use a template when submitting bug fixes. See:
# https://docs.openstack.org/kolla-ansible/latest/contributor/release-notes.html#fixes
# reno new --from-template releasenotes/templates/fix.yml bug-<bug-number>
git add changelog/*
git commit -a
git show
# Finally, when the change is ready, push it out:
git-review
```
Note that you only need to run `git-review -s` once per repo but `git-review` - every time you push your change.

Do not remove the auto-generated `Change-Id:` line from the commit message.

In your commit message include a reference to the bug report with either `Closes-Bug: <bug-number>`, `Partial-Bug: <bug-number>` or `Related-Bug: <bug-number>`.

For more information, read [Developer’s Guide](https://docs.openstack.org/infra/manual/developers.html).

## References

1. https://docs.openstack.org/infra/manual/developers.html
1. https://superuser.com/questions/887712/how-do-i-change-the-highlighted-length-of-git-commit-messages-in-vim
1. https://stackoverflow.com/questions/31528384/conditional-copy-add-in-dockerfile
