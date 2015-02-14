Submodules are a way of importing code from other git repositories into your source tree, and keeping them up to date after they are imported.

cd my_git_repo_root
git submodule add *remote repository* *local path*
This will checkout the remote repository into the local path, and records the remote repository in a .gitmodules at the root of your repo.

Then, later on, if a new version of a submodule is released, you can update your copy with

git submodule update
