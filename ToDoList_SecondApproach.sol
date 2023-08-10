/*
Note: this version use addressToTaskCount to check membership, if address does not have
any task, that mean the address is not a member
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract ToDoList{
    address public assigner;
    ToDo[] toDos;
    mapping (address => uint) public addressToTaskCount; // check number of task

    enum STATUS{
        INCOMPLETE,
        COMPLETE,
        FAILED
    }

    struct ToDo{
        uint32 taskId; // optional, just helper property
        uint32 deadline; // unix time
        address assignee;
        string task;
        STATUS status;
    }

    event TaskAdded(ToDo);
    event LogCurrentUnixTime(uint unixTime);

    constructor(){
        assigner = msg.sender;
        addressToTaskCount[msg.sender] = 1; // can be set to any number just to make the assigner a member by default and never have 0 task even when assigner doesn't have a task
    }

    function assignTask(uint32 _deadline, address _assignee, string memory _task) external onlyAssigner {
        ToDo memory newTask = ToDo(uint32(toDos.length),
            _deadline,
            _assignee,
            _task,
            STATUS.INCOMPLETE);

        toDos.push(newTask); // add new task to the array

        // add member's task count
        addressToTaskCount[_assignee]++;
        
        emit TaskAdded(newTask);
    }

    function reassignTask(uint32 _taskId, address _assignee) public onlyAssigner{
		require(toDos[_taskId].status == STATUS.INCOMPLETE, "Only incomplete task can be reassigned.");
		require(toDos[_taskId].assignee != _assignee, "New assignee is the same as the current assigne.");
		
        addressToTaskCount[toDos[_taskId].assignee]--;
        toDos[_taskId].assignee = _assignee;
        addressToTaskCount[_assignee]++;
	}

    // challenge: to check task validity
    function checkDealineValid(uint _deadline, uint currentUnixTime) public pure returns (bool){
        if(currentUnixTime < _deadline){
            return true;
        }
        
        return false; // if current time has passed deadline
    }

    // to check if there are unfinished tasks that has passed the deadline
    function refreshTask() external onlyAssigner(){
        emit LogCurrentUnixTime(block.timestamp);
        for(uint i = 0; i < toDos.length; i++){
            // only incomplete tasks' status can be updated to failed if passed the deadline
            if(toDos[i].status == STATUS.INCOMPLETE && !checkDealineValid(toDos[i].deadline, block.timestamp)){
                toDos[i].status = STATUS.FAILED;
            }
        }
    }

    function completeTask(uint32 _taskId) external onlyMembers{
        // check if the caller is the assignee of the task
        require(toDos[_taskId].assignee == msg.sender, "Address is not the assignee of the task.");
        require(toDos[_taskId].status == STATUS.INCOMPLETE, "Task has been completed."); // prevent completed task become failed

        bool isDeadlineValid = checkDealineValid(toDos[_taskId].deadline, block.timestamp);
        if(!isDeadlineValid){
            toDos[_taskId].status = STATUS.FAILED;
        }
        require(isDeadlineValid, "Task has passed the deadline.");
        toDos[_taskId].status = STATUS.COMPLETE;
        
    }

    function viewAllTasks() public view onlyMembers returns(ToDo[] memory){
        return toDos;
    }

    // modifiers
    modifier onlyMembers{
        require(addressToTaskCount[msg.sender] != 0, "Address is not a member of the group.");
        _;
    }

    modifier onlyAssigner(){
        require(msg.sender == assigner, "Address is not the assigner of the group.");
        _;
    }
}