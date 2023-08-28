# Group ToDo List
A beginner level smart contract assignment for a simple group to-do list.

# Description
Each ToDo will have:
- Assignee <br>
  only asignee can change the status of the task to done
- Assigner <br>
  only the contract deployer (group leader) can assign task <br>
  assigner may reassign the task if it HAS NOT been completed by the current assignee
- Task <br>
  the name of the task
- Status <br>
  to indicate complete/incompleted, initially the status should be incompleted

<b>Only addresses that are part of the group (the group leader/assigner and those who are assigned a task can view the ToDo List.</b>

Challenge:
- Add deadline date to the ToDo property (Clue: Unix Timestamp)
- Assignee cannot change status to complete if the date has passed the deadline
- Assigner can refresh the ToDo list to check if there are unfinished tasks that has passed the deadline, 
if there is, the status should change to failed. (Clue: loop)

# Test Cases - Expected Result:
- Add task with assigner address - Success
- Add task with non assignes address - Failed
</br>

- Complete task with assignee address - Success
- Complete task with non-assignee address - Failed
</br>

- View task with member address - Success
- View task with non-member address - Failed
</br>

- Reassign incomplete task by assigner - Success
- Reassign completed task by assigner - Failed
- Reassign task by non-assigner - Failed
</br>

<b>Challenge</b>
- Refresh task by assigner (opt) - Success
- Refresh task by non-assigner (opt) - Failed
- Complete task with assignee address before deadline (opt) - Success
- Complete task with assignee address after deadline (opt) - Failed
