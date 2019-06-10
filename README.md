# DynSup

## Description

The purpose of this project is just to show a strange behaviour on DynamicSupervisor.
When all children of such a supervisor suddenly die, the supervisor itself is restarted.

## Use

```
iex -S mix

:observer.start # have a look to DynSup pid
ChildMgr.setup # ok 4 children
ChildMgr.crash_all # ko no more children and DynSup pid change
```