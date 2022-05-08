({
    setUserId : function (component) {
        const selectedUserId = component.find('digitalBankingUserSelect').get('v.value');
        const previousUserId  =  component.get("v.previousUserId");

        component.set("v.selectedUserId", selectedUserId);

        if (previousUserId !== selectedUserId) {
            this.fireSelectedUserEvent(component, selectedUserId, previousUserId);
            component.set("v.previousUserId" , selectedUserId);
            this.populateUserData(component, selectedUserId);
        }
    },

    fireSelectedUserEvent : function (component, selectedUser, previousUser) {
        var cmpEvent = component.getEvent("selectUserStokvelEvent");
        cmpEvent.setParams({
            "previousUserId" : previousUser,
            "selectedUserId" : selectedUser
        });
        cmpEvent.fire();
    },

    populateUserData : function(component, selectedUserId) {
        const userOptions = component.get("v.userOptions");
        let selectedUserOption = userOptions.find(userOption =>  userOption.value === selectedUserId);
        let userData = component.get("v.user");
        userData.userName = selectedUserOption.label;
        userData.userId = selectedUserOption.value;
        userData.cellphoneNumber = selectedUserOption.cellphoneNumber;
        component.set("v.rvnCellphone", selectedUserOption.cellphoneNumber);
        component.set("v.user", userData);
        this.fireGetDataEvent(component);
    },

    setUserOptionsForSelect : function (component) {
        const userOptions = component.get("v.userOptions");
        let selectedUserIds = component.get("v.selectedUserIds");
        const selectedUserId = component.get("v.selectedUserId");

        if (selectedUserIds.length > 0 ) {
            let userOptionsForSelect = userOptions.filter(userOption => (!selectedUserIds.includes(userOption.value) || (userOption.value === selectedUserId)));
            component.set("v.userOptionsForSelect", userOptionsForSelect);
        } else {
            component.set("v.userOptionsForSelect", userOptions)
        }
    },

    validateFields : function (component) {
        let rvnNumberIsValid  = this.validateCellphone(component);
        let userIsValid = this.validateUser(component);
        return rvnNumberIsValid && userIsValid;
    },

    validateCellphone : function (component) {
        const rvnCellphone = component.find("rvnCellphone");
        const cellphonePattern = new RegExp("^[0-9]{10}$");
        let rvnCellphoneValue = rvnCellphone.get("v.value");

        if (rvnCellphoneValue == null) {
            rvnCellphoneValue = "";
        }

        let isCellPhoneValid = rvnCellphoneValue.match(cellphonePattern);
        if (isCellPhoneValid) {
            $A.util.removeClass(rvnCellphone, "slds-has-error");
            rvnCellphone.setCustomValidity("");
            rvnCellphone.reportValidity();
        } else {
            $A.util.addClass(rvnCellphone, "slds-has-error");
            rvnCellphone.setCustomValidity("Please enter a valid cellphone number.");
            rvnCellphone.reportValidity();
        }

        return isCellPhoneValid;
    },

    validateUser : function (component) {
        let user = component.get("v.user");
        return (user.userName) && (user.userId);
    },

    populateUserName : function (component) {
        let userName = component.get("v.userName");
        let user = component.get("v.user");
        user.userName = userName;
        component.set("v.user", user);
        this.fireGetDataEvent(component);
    },

    populateUserId : function (component) {
        let isStokvel = component.get("v.isStokvel");
        if (!isStokvel) {
            let userId = component.get("v.selectedUserId");
            let user = component.get("v.user");
            user.userId = userId;
            component.set("v.user", user);
            this.fireGetDataEvent(component);
        }
    },

    populateCellphone : function (component) {
        let cellphoneNumber = component.get("v.rvnCellphone");
        let user = component.get("v.user");
        user.cellphoneNumber = cellphoneNumber;
        component.set("v.user", user);
        this.fireGetDataEvent(component);
    },

     fireGetDataEvent : function (component) {
         let isValid = this.validateFields(component);
         if (isValid) {
             let user = component.get("v.user");
             var cmpEvent = component.getEvent("getUserData");
             cmpEvent.setParams({
                 "userData" : JSON.stringify(user)
             });
             cmpEvent.fire();
         }
     },

    setUserNumber : function (component) {
        const userNumber = component.get("v.userNumber");
        let userData = {
            userNumber : userNumber
        }
        component.set("v.user", userData);
    }

    // fireSetPinEvent : function (component) {
    //     var cmpEvent = component.getEvent("setPin");
    //     const  user = component.get("v.user");
    //     cmpEvent.setParams({
    //         "userId" : user.userId,
    //         "userNumber" : user.userNumber
    //     });
    //     cmpEvent.fire();
    //     component.set("v.isMaintainSuccess", true);
    // }

});