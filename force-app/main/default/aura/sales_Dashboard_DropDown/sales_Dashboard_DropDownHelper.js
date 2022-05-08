({
    changeStatusHelper: function(component, event) {
        component.set("v.ctiSpinner", {
            displayCls: '',
            msgDisplayed: 'Changing Status...'
        });
        let loggedInUser = component.get("v.loggedInUser");
        let selected_row = component.get("v.selected_row");

        var action = component.get("c.changeAgentStatus");
        action.setParams({
            userId: loggedInUser.ab_number,
            stationId: loggedInUser.station_id,
            agentId: loggedInUser.agent_id,
            auxCode: selected_row.auxCode,
            agentStatus: selected_row.value
        });
        action.setCallback(this, function(a) {

            var res = a.getReturnValue();

            var state = a.getState();
            var errors = a.getError();

            if (component.isValid() && state === 'SUCCESS') {
                if (res[0] == 'Success') {

                    var statusCode = res[2];
                    var resBody = JSON.parse(res[1]);

                    var msg = 'Response body: ' + resBody + '. \n Status code: ' + statusCode;
                    var header = 'Status change';

                    component.set("v.ctiSpinner", {
                        displayCls: 'slds-hide',
                        msgDisplayed: 'Change Status...'
                    });

                    if (statusCode < 300) {
                        msg = 'Success';

                        if (resBody.errors) {
                            msg = resBody.errorList[0].description;
                            header = 'Error';
                            var modalObj = component.get("v.modalObj");
                            modalObj.header = header;
                            modalObj.isOpen = true;
                            modalObj.body = msg;
                            component.set("v.modalObj", modalObj);
                        }
                    }

                    if (statusCode > 300) {
                        component.set("v.modalObj", {
                            header: header,
                            isOpen: true,
                            body: resBody.Message,
                            modalStyle: 'width:30%'
                        });
                    }

                } else {
                    this.newSearchModal(component, 'Change status message', res[1]);
                }

            } else {
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    this.newSearchModal(component, 'Change status Error', errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    logoutHelper: function(component, event, helper) {

        let loggedInUser = component.get("v.loggedInUser");
        component.set("v.ctiSpinner", {
            displayCls: '',
            msgDisplayed: 'Logging out...'
        });

        var action = component.get("c.logout");
        action.setParams({
            userId: loggedInUser.ab_number,
            stationId: loggedInUser.station_id,
            agentPin: loggedInUser.agent_id
        });
        action.setCallback(this, function(response) {
            component.set("v.ctiSpinner", {
                displayCls: 'slds-hide',
                msgDisplayed: 'Loading...'
            });

            //Reset dropdown 
            component.set("v.selected_row", {
                'label': 'Not Ready',
                'value': 'NOT_READY',
                'auxCode': '10',
                'selected': true
            });
            component.set("v.selected_value", 'Not Ready');
            component.set("v.selected_value_class", "");
            var pick_list = component.get("v.agentStatus");
            for (let key in pick_list) {
                pick_list[key].selected = false;
            }
            pick_list[10].selected = true;
            component.set("v.agentStatus", pick_list);

            var state = response.getState();
            var errors = response.getError();

            var res = response.getReturnValue();

            if (state === "SUCCESS") {
                var cti = component.get("v.cti");
                cti.status = 'Offline';
                cti.statusIcon = '/Icons/disconnected.svg';
                cti.statusCls = 'cursor';
                component.set("v.cti", cti);


                var statusCode = res[0];
                var resBody = JSON.parse(res[1]);
                var msg = 'Logged out succesfully';
                var header = 'Logout';
                if (resBody.Message) {
                    msg = resBody.Message;
                }
                if (resBody.errors) {
                    //msg = resBody.errorList[0].description;
                    header = 'Error';
                    msg = '';
                    for (const element of resBody.errorList) {
                        msg = msg + ' ' + element.description + '. ';
                    }
                    let modalObj = component.get("v.modalObj");
                    modalObj.header = header;
                    modalObj.isOpen = true;
                    modalObj.body = msg;
                    component.set("v.modalObj", modalObj);
                }
            } else {
                if (errors && Array.isArray(errors) && errors.length > 0) {

                    let modalObj = component.get("v.modalObj");
                    modalObj.header = 'Logout message.';
                    modalObj.isOpen = true;
                    modalObj.body = errors[0].message;
                    component.set("v.modalObj", modalObj);
                }
            }
        });
        $A.enqueueAction(action);
    },
    newSearchModal: function(component, headerMsg, bodyMsg) {
        component.set("v.modalObj", {
            isOpen: true,
            header: headerMsg,
            body: bodyMsg
        });
        return;
    },
})