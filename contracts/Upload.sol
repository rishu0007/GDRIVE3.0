// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 < 0.9.0;

contract Upload {
    // 0xqwerty is an address(suppose) and inside access we are writing the address of 
    // the user to whom 0xqwerty wants to share the images
    struct Access {
        address user;
        bool access; // true or false
    }

    mapping(address=>string[]) value; // through this variable we are just mapping each address whith the images stored by them on the cloud
                                      // the value is of string type because the data we will get of each image stored on the cloud will be of string type

    mapping(address=>mapping(address=>bool)) ownership; // nested mapping is like a 2d array, through this nested mapping we are just 
                                                        // storing that, which addresses have given access to which addresses

    mapping(address=>Access[]) accessList; // through this we are storing the list of all the addresses which are given acceess by every particular addresses

    mapping(address=>mapping(address=>bool)) previousData; // through this we are storing information of our prvious state as we are not using any database and nodeJS

    function add(address _user, string memory url) external {
        value[_user].push(url);
    }

    // below function allow krega ki maine kisi dushre address to allow kiya h ki nhi
    function allow(address user) external {
        ownership[msg.sender][user] = true;
        if(previousData[msg.sender][user]) {
            for(uint i = 0; i < accessList[msg.sender].length; i++) {
                if(accessList[msg.sender][i].user == user) {
                    accessList[msg.sender][i].access = true;
                }
            }
        } else {
            accessList[msg.sender].push(Access(user,true));
            previousData[msg.sender][user] = true;
        }
    }

    function disallow(address user) public {
        ownership[msg.sender][user] = false;
        for(uint i = 0; i < accessList[msg.sender].length; i++) {
            if(accessList[msg.sender][i].user == user) {
                accessList[msg.sender][i].access = false;
            }
        }
    }

    function display(address _user) external view returns (string[] memory) {
        require(_user == msg.sender || ownership[_user][msg.sender],"you don't have access");
        return value[_user];
    }

    //below function for :- jiske sath bhi image shared hai us list ko fetch krne k liye
    function shareAccess() public view returns(Access[] memory) {
        return accessList[msg.sender];
    }


}