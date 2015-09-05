# Ragnarok

This repo provides a docker based dev environment for the developing on an OSX machine.

----------


## Streamlined setup
###Install dependencies
* [VirtualBox][virtualbox] 4.3.10 or greater.


###Clone this project and get it running!
```
git clone https://github.com/OpSitters/ragnarok.git
cd ragnarok
```

###Load environment
``source .profile`` loads the env need for ragnarok (please add to your login profile)

###Initializing Step By Step
This is the step by step commands to bring up ragnarok

####Initialize the Cosmos###
``ragnarok``

####Build containers###
``ragnarok-build``

####Init the application###
Depending on which application(s) you want to run you also need to init them. For example, with the demo app run
``demo-init``

###Initializing Automagicly###
You can just run this single command to do everything from the step by step above ;)
```
ragnarok-init
```


###Run the application###
Run your application services (in this case the demo)
``demo-web`` in one terminal
``demo-api`` in another terminal


## Developing
###Code Editing
Code for all of the applications should be placed in the shared subdirectoy of this repo (as long as your application controller fetches it properly).  You can therefore setup your dev environment however you want on your workstation and never have to worry about whats going on inside the containers that run applications.



---------------------
[virtualbox]: https://www.virtualbox.org/wiki/Downloads  "VirtualBox Downloads"
