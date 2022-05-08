({
    setUserId : function (component) {
        const selectedUserId = component.find('digitalBankingUserSelect').get('v.value');
        const previousUserId  =  component.get("v.previousUserId");

        component.set("v.selectedUserId", selectedUserId);

        if (previousUserId !== selectedUserId) {
            this.fireSelectedUserEvent(component, selectedUserId, previousUserId);
            component.set("v.previousUserId" , selectedUserId);
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

    setUserOptionsForSelect :function (component) {
        const userOptions = component.get("v.userOptions");
        let selectedUserIds = component.get("v.selectedUserIds");
        const selectedUserId = component.get("v.selectedUserId");

        if (selectedUserIds.length > 0 ) {
            let userOptionsForSelect = userOptions.filter(userOption => (!selectedUserIds.includes(userOption.value) || (userOption.value === selectedUserId)));
            component.set("v.userOptionsForSelect", userOptionsForSelect);
        } else {
            component.set("v.userOptionsForSelect", userOptions)
        }
    }

});