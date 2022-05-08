({
    waitingTimeId: null,
    setStartTimeOnUI: function(component) {
        component.set("v.stopDisplayed", true);
        var currTime = component.get("v.cti.stopWatchTime");
        if (currTime) {
            var ss = currTime.split(":");
            var dt = new Date();
            dt.setHours(ss[0]);
            dt.setMinutes(ss[1]);
            dt.setSeconds(ss[2]);

            var dt2 = new Date(dt.valueOf() + 1000);
            var temp = dt2.toTimeString().split(" ");
            var ts = temp[0].split(":");

            component.set("v.cti.stopWatchTime", ts[0] + ":" + ts[1] + ":" + ts[2]);
            this.waitingTimeId = setTimeout($A.getCallback(() => this.setStartTimeOnUI(component)), 1000);
        }
    },   
    setStopTimeOnUI: function(component) {
        component.set("v.stopDisplayed", false);
        window.clearTimeout(this.waitingTimeId);
    },
    setResetTimeOnUI: function(component) {
        component.set("v.stopDisplayed", false);
        component.set("v.cti.stopWatchTime", "00:00:00");
        window.clearTimeout(this.waitingTimeId);
    },
    ctiSpinner: function(component, cls, msg) {
        component.set("v.ctiSpinner", {
            displayCls: cls,
            msgDisplayed: msg
        });
    },
    loginHelper: function(component, event) {

        this.ctiSpinner(component, '', 'Logging into device...');

        let loggedInUser = component.get("v.loggedInUser2");
        console.log(JSON.stringify(loggedInUser));
        let saveSationId = component.get("v.update_station_id");
        console.log(JSON.stringify(saveSationId));
        //alert('ab number: '+ loggedInUser.ab_number+' -- station id: '+loggedInUser.station_id+' save station id: '+saveSationId); 
        this.checkIfComponentValid(component, event);

        var action = component.get("c.login");
        action.setParams({
            userId: loggedInUser.ab_number,
            stationId: loggedInUser.station_id,
            saveStationId: saveSationId
        });
        action.setCallback(this, function(response) {
            var res = response.getReturnValue();

            var state = response.getState();
            var errors = response.getError();

            this.ctiSpinner(component, 'slds-hide', 'Loading...');

            if (component.isValid() && state === 'SUCCESS') {

                if (res[0] == 'Success') {

                    var statusCode = res[2];
                    var resBody = JSON.parse(res[1]);
                    var resStatusMsg = res[3];

                    if (saveSationId) {
                        component.set("v.update_station_id", false);
                    }

                    if (resStatusMsg == 'OK') {
                        resStatusMsg = 'Success';
                    }

                    if (statusCode < 300) {
                        let theMsg = 'Phone connected';

                        if (resBody.errors) {
                            theMsg = resBody.errorList[0].description;
                            resStatusMsg = 'Error';
                            component.set("v.modalObj", {
                                header: resStatusMsg,
                                isOpen: true,
                                body: theMsg,
                                modalStyle: 'width:30%'
                            });
                            return;
                        }

                        //Set Agent Id 
                        var loggedInUser = component.get("v.loggedInUser");
                        loggedInUser.agent_id = resBody.agentId;
                        component.set("v.loggedInUser", loggedInUser);

                        //open socket
                        this.openChewySocketHelper(component, event); //open socket.

                    }
                    if (statusCode > 300) {
                        component.set("v.modalObj", {
                            header: resStatusMsg,
                            isOpen: true,
                            body: resBody.Message,
                            modalStyle: 'width:30%'
                        });
                    }

                    var cti_status = component.get("v.cti");
                    cti_status.status = 'Connected';
                    cti_status.statusIcon = '/Icons/connected.svg';
                    cti_status.statusCls = 'green';
                    component.set("v.cti", cti_status);
                } else {
                    this.newSearchModal(component, 'Login message', res[1]);
                }

            } else {
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    this.newSearchModal(component, 'Login Error', errors[0].message);
                }
            }

        });
        $A.enqueueAction(action);
    },
    acceptCallHelper: function(component, event) {
        //On call
        component.set("v.cti.oncall", 'On call');
        component.set("v.cti.onCallIcon", '/Icons/greenphone.svg');
        component.set("v.cti.onCallCls", 'td');

        //Transfer
        component.set("v.cti.transferCls", 'td');

        //accept call
        component.set("v.cti.endCallIcon", '/Icons/redphone.svg');
        component.set("v.cti.endCall", 'End call');
        component.set("v.cti.endCallCls", 'td');

        component.set("v.cti.stopWatchTimeCls", 'td');




        //Start timer
        component.set("v.cti.stopWatchTimeCls", 'td');

        let loggedInUser = component.get("v.loggedInUser");

        //this.checkIfComponentValid(component, event);

        var action = component.get("c.acceptContact");
        action.setParams({
            userId: loggedInUser.ab_number,
            agentId: loggedInUser.agent_id
        });
        action.setCallback(this, function(response) {

            var state = response.getState();
            var errors = response.getError();
            var res = response.getReturnValue();
            if (component.isValid() && state === "SUCCESS") {

                if (res[0] == 'Success') {

                    // var statusCode = res[0];
                    //var resBody = res[1];
                    //var getStatus = res[2];

                    var msg = ''; // 'Response body: ' + JSON.stringify(resBody) + '. \n Status code: ' + statusCode + '. \n Status: ' + getStatus;
                    console.log('Accepting call: ' + msg);
                    var json_string = JSON.parse(res[1]);

 
                    if (res[2] > 201) {
                        msg = res[3];
                        component.set("v.modalObj", {
                            isOpen: true,
                            header: 'Accept contact msg',
                            body: res[3]
                        });
                        return;
                    } 
                    if (json_string.errors) {
                        msg = json_string.errorList[0].description;
                        if (!msg) {
                            msg = 'Message blank';
                        }
                        component.set("v.modalObj", {
                            isOpen: true,
                            header: 'Accept contact warning',
                            body: msg
                        });
                    } else {

                        this.setStartTimeOnUI(component);
                    }
                } else {
                    this.newSearchModal(component, 'Accept contact message', res[1]);
                }


            } else {
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    component.set("v.modalObj", {
                        isOpen: true,
                        header: 'Accept contact error',
                        body: errors[0].message
                    });
                }
            }
        });
        $A.enqueueAction(action);
    },
    endCallHelper: function(component, event) {

        var cti = component.get("v.cti");
        if (cti.endCallCls == 'cti_tile_disabled') {
            //return;
        }
        this.setStopTimeOnUI(component);

        var cti_status = component.get("v.cti");
        cti_status.status = 'Connected';
        cti_status.statusIcon = '/Icons/connected.svg';
        cti_status.statusCls = 'green';
        component.set("v.cti", cti_status);
        //Auto accept call
        if (component.get("v.callInprogress")) {
            component.set("v.callInprogress", false);
        }
        this.setStopTimeOnUI(component);

        var cti_status = component.get("v.cti");
        cti_status.status = 'Connected';
        cti_status.statusIcon = '/Icons/connected.svg';
        cti_status.statusCls = 'green';
        component.set("v.cti", cti_status);
        this.resetCTI(component);


        //this.checkIfComponentValid(component, event);
        //open spinner
        component.set("v.ctiSpinner", {
            displayCls: '',
            msgDisplayed: 'Ending Call...'
        });
        let loggedInUser = component.get("v.loggedInUser");
        //this.checkIfComponentValid(component, event);
        var action = component.get("c.closeContact");
        action.setParams({
            userId: loggedInUser.ab_number,
            agentId: loggedInUser.agent_id
        });
        action.setCallback(this, function(response) {

            component.set("v.ctiSpinner", {
                displayCls: 'slds-hide',
                msgDisplayed: 'Closing Call...'
            });

            /*var res = response.getReturnValue();
            var getStatusCode = res[0];
            var getStatus = res[3];
            var getBody = res[1];

            var msg = 'Body: ' + JSON.stringify(getBody) + '\n Status: ' + getStatus + '\n Status code: ' + getStatusCode;

            if (res.Message) {
                msg = res.Message;
            }
 
            var json_string = getBody;

            if (!json_string.errors) {
                msg = 'Call ended';
            }

            //component.set("v.modalObj", {
              //  isOpen: true,
               // header: 'End call',
               // body: msg
            //});*/

            this.resetCTI(component);
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
    startCallHelper: function(component, event, helper) {
        this.acceptCallHelper(component, event);
    },
    resetCTI: function(component) {
        var cti = component.get("v.cti");
        cti.oncall = 'On call';
        cti.onCallIcon = '/Icons/inactivenocall.svg';
        cti.onCallCls = 'cti_tile_disabled';

        cti.connectionId = '';
        cti.ucId = '';
        cti.sessionId = '';
        cti.agentId = '';
        cti.stationId = '';

        component.set("v.cti", cti);
        //window.setTimeout(
        //$A.getCallback(function() {

        cti.oncall = 'On call';
        cti.onCallIcon = '/Icons/inactivenocall.svg';
        cti.onCallCls = 'cti_tile_disabled';

        cti.endCall = 'End call';
        cti.endCallIcon = '/Icons/inactivephonedown.svg';
        cti.endCallCls = 'cti_tile_disabled';

        cti.transfer = 'Transfer';
        cti.transferIcon = '/Icons/inactivetransfer.svg';
        cti.transferCls = 'cti_tile_disabled';

        cti.stopWatchTime = '00:00:00';
        cti.stopWatchTimeCls = 'cti_tile_disabled';

        component.set("v.cti", cti);
        //}), 5000
        //);
        // this.setResetTimeOnUI(component);
        this.setStopTimeOnUI(component);
    },
    onHoldHelper: function(component, event, helper) {
        var cti = component.get("v.cti");

        if (cti.onCallCls == 'cti_tile_disabled') {
            return;
        }

        let loggedInUser = component.get("v.loggedInUser");
        var hold = component.get("v.place_call_onhold");
        if (hold == 'HOLD') {
            this.ctiSpinner(component, '', 'Placing onhold..');
        }

        if (hold == 'UNHOLD') {
            this.ctiSpinner(component, '', 'Resuming call..');
        }



        //this.checkIfComponentValid(component, event);

        var action = component.get("c.onHold");
        action.setParams({
            agentId: loggedInUser.agent_id,
            connectionId: cti.connectionId,
            stationId: cti.stationId,
            toggleInd: hold,
            userId: loggedInUser.ab_number
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            var errors = a.getError();
            var res = a.getReturnValue();
            this.ctiSpinner(component, 'slds-hide', 'Please wait...');

            if (component.isValid() && state === 'SUCCESS') {

                if (res[0] == 'Success') {
                    var getStatusCode = res[2];
                    var getBody = res[1];
                    var getStatus = res[3];

                    var msg = 'Body: ' + JSON.stringify(getBody) + '\n Status: ' + getStatus + '\n Status code: ' + getStatusCode;

                    if (getStatusCode == 405) {
                        component.set("v.modalObj", {
                            isOpen: true,
                            header: 'Call hold exception',
                            body: getStatus
                        });
                        return;
                    }
                    
                    if (getStatusCode > 299) {
                        var jsonB = JSON.parse(getBody);
                        component.set("v.modalObj", {
                            isOpen: true,
                            header: 'Call hold exception: '+jsonB.errorCode,
                            body: jsonB.message
                        });
                        return;
                    }                    

                    if (res.Message) {
                        msg = res.Message;
                    }

                    var json_string = getBody;

                    if (!json_string.errors) {
                        msg = 'Call hold';
                    }
                    if (hold == 'HOLD') {
                        component.set("v.place_call_onhold", 'UNHOLD');
                    }

                    if (hold == 'UNHOLD') {
                        component.set("v.place_call_onhold", 'HOLD');
                    }

                    if (state === 'SUCCESS') {

                        if (cti.toggleInd == 'HOLD') {
                            cti.toggleInd == 'UNHOLD';
                        }
                        if (cti.toggleInd == 'UNHOLD') {
                            cti.toggleInd == 'HOLD';
                        }

                        component.set("v.cti", cti);

                    } else {
                        component.set("v.modalObj", {
                            isOpen: true,
                            header: 'Call hold error',
                            body: msg
                        });
                    }

                } else {
                    this.newSearchModal(component, 'On hold message', res[1]);
                }

            } else {
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    this.newSearchModal(component, 'On hold Error', errors[0].message);
                }
            }

        });
        $A.enqueueAction(action);
    },
    checkIfComponentValid: function(component, event) {
        var cti = component.get("v.cti");
        if (!cti.Offline) {
            return;
        }
    },

})