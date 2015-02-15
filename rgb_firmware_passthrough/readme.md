You either need to move the libraries to your arduino library folder
or use the makefile.

The makefile requires the Arduino software to be installed. So if you have not installed it before, then you have to install it first.

http://hardwarefun.com/tutorials/compiling-arduino-sketches-using-makefile -> Installation


---Submodules---
Submodules are a way of importing code from other git repositories into your source tree, and keeping them up to date after they are imported.

git submodule add *remote repository* *local path*
This will checkout the remote repository into the local path, and records the remote repository in a .gitmodules at the root of your repo.

Then, later on, if a new version of a submodule is released, you can update your copy with

git submodule update
