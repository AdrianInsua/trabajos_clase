RING MODULE
===========
Codified in Erlang
--------------------

In this exercice we are going to code a module that will create a bunch of processes connected to each other in **ring topology**

The ring will catch exit exceptions coming from the processes, and repair the ring connections.
It will handle hot code swapping, and multiple node comunication.

The documentation was created with eDoc.

The exported api includes:
    - start(NProcess::integer())
    - stop()
    - msg(NTimes::integer, Message::any()) -> sends any kind of data through the ring for NTimes rounds
    - get_proccess(ProcessNumber::integer()) -> retuns the process PID
