I have containers spread across the following repos:
* https://github.com/iowarp/ppi-jarvis-cd
* https://github.com/iowarp/cte-hermes-shm
* https://github.com/iowarp/iowarp-runtime
* https://github.com/iowarp/content-transfer-engine

Each of these repos has an action named "Build Containers" with a manual workflow trigger.

These containers are inter-dependent among each other. I want to have a single action in this repo
that triggers the actions, in order, from those repos. I want an action to run to completion
before going to the next to ensure the containers build properly.

In addition, this repo has the action iowarp.yml, which I want to run last after all the others complete.

Build a github action called calls the other actions in sequence.
Name it iowarp-most.yaml. Let me know what you need for this to work, 
such as secrets to be created.
