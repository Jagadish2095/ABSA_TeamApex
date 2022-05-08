({
    testSock: function(component, event, helper) {
        helper.openChewySocketHelper(component, event);
    },
    updateLoginCredsHandler: function(component, event, helper) {
        var station_id = event.getParam("station_id");
        component.set("v.update_station_id", true);
        helper.loginHelper(component, event);
    },
    onHoldHandler: function(component, event, helper) {        
        helper.onHoldHelper(component, event);
    },
    invokeDashboard: function(component, event, helper) {
        var obj = event.getParam("sockObj");
        if (obj) {
            console.log(JSON.stringify(obj));
            if (obj.eventType == 'connectionDisconnected') {
                component.set("v.modalObj", {
                    header: 'Call Dropped',
                    isOpen: true,
                    body: 'Call cut',
                    modalStyle: 'width:30%'
                });

                var cti = component.get("v.cti");
                cti.status = 'Connected';
                cti.statusIcon = '/Icons/connected.svg';
                cti.statusCls = '';
                component.set("v.cti", cti);

                helper.setResetTimeOnUI(component);                
                helper.resetCTI(component); 
                helper.setStopTimeOnUI(component);  
                return;
            } else {
                helper.acceptCallHelper(component, event);
            }
        }
    },
    startCall: function(component, event, helper) {
      /*  var obj = component.get("v.obj");
        obj.id_number = '9112055078087';

        //component.set('v.today', today);
        var dob = new Date(1991, 12, 5);
        obj.date_of_birth = $A.localizationService.formatDate(dob, "YYYY-MM-DD");
        obj.title = 'Mr';
        obj.name = 'Vikesh Niresh';
		obj.surname = 'Reddy';
        obj.gender = 'Male';
        
        window.setTimeout(
            $A.getCallback(function() {                
                obj.initials = 'VN';                
                obj.cell_number = '072948758';
                component.set("v.obj", obj);
            }), 1000
        )
        obj.applicant_risk = 'Low';
        obj.final_offer_amount = 'R 100,000.00';
        obj.application_number = '#appl0001';

        obj.residential_status = 'Permanent';
 
        obj.current_emp_since = '2015';
        obj.avrg_net_sal_income = 'R 30 000.00';
        obj.employment_name = 'Naspers';

        component.set("v.obj", obj);




        window.setTimeout(
            $A.getCallback(function() {
                obj.interest_rate = '20.00%';
                obj.tenure = '36 months';
                obj.monthly_installment = 'R 2.777,00';

                obj.country_of_birth = 'South Africa';
                obj.marital_status = 'Single';
                obj.res_address = '9 Fife Street, Sandton';
                obj.employment_status = 'Full time';
                obj.sa_income_tax_no = '987654321';

                obj.customer_qual = 'Honors degree';
                obj.occupation_status = 'Manager';
                component.set("v.obj", obj);
            }), 2000
        );*/


        helper.acceptCallHelper(component, event);

    },
    endCallHandler: function(component, event, helper) {
        helper.endCallHelper(component, event);
    },
    afterScriptsLoaded: function(component, event, helper) {
        console.log('Scripts have loaded');
    },
    authenticateHandler: function(component, event, helper) {
	
        let sel_value = component.get("v.selected_value");
        let cti = component.get("v.cti");

        if (cti.status == 'Offline') {
            component.set("v.isLoginModalOpen", "true");
            //component.set("v.selValTempHolder", selected_id);
            return;
        } else { // (sel_value != 'Not Ready') 
            component.set("v.isLogoutModalOpen", true);
            return;
        }
    },
    incomingCallHandler: function(component, event, helper) {
        component.set("v.cti.status", 'Ringing');
        component.set("v.cti.statusIcon", '/Icons/blackphone.svg');

        component.set("v.cti.onCallIcon", '/Icons/greenphone.svg');
        component.set("v.cti.oncall", 'Accept');
        component.set("v.cti.onCallCls", 'td');
    },
    acceptCallHandler: function(component, event, helper) {
        //alert('Accept Call: '+component.get("v.callInprogress")); 
        if (component.get("v.callInprogress")) {
            //alert('Call the accept call method here '); 
        }
        // helper.acceptCallHelper(component, event);

        //Inprogress call
        //component.set("v.cti.status", '0732738946');

        //On call
        //component.set("v.cti.oncall", 'On call');

        //Transfer
        //component.set("v.cti.transferCls", 'td');

        //End call
        //component.set("v.cti.endCallIcon", '/Icons/redphone.svg');
        //component.set("v.cti.endCall", 'End call');
        //component.set("v.cti.endCallCls", 'td');

        //Start timer
        //component.set("v.cti.stopWatchTimeCls", 'td');
        //helper.setStartTimeOnUI(component);
    },
    endCallHandler1: function(component, event, helper) {
        let call = {
            status: 'Connected',
            statusIcon: '/Icons/connected.svg',
            statusCls: '',

            oncall: 'On call',
            onCallIcon: '/Icons/inactivenocall.svg',
            onCallCls: 'cti_tile_disabled',

            endCall: 'End call',
            endCallIcon: '/Icons/inactivephonedown.svg',
            endCallCls: 'cti_tile_disabled',

            transfer: 'Transfer',
            transferIcon: '/Icons/inactivetransfer.svg',
            transferCls: 'cti_tile_disabled',

            stopWatchTime: '00:00:00',
            stopWatchTimeCls: 'cti_tile_disabled',

            hideCTI: ''
        };
        component.set("v.cti", call);
        component.set("v.callInprogress", false);

        helper.setStopTimeOnUI(component);
    },
    handleStartClick: function(component, event, helper) {
        console.log("start button clicked!!");
        helper.setStartTimeOnUI(component);
    },
    handleStopClick: function(component, event, helper) {
        console.log("stop button clicked!!");
        helper.setStopTimeOnUI(component);
    },
    handleResetClick: function(component, event, helper) {
        console.log("Reset button clicked!!");
        helper.setResetTimeOnUI(component);
    },
    loginHandler: function(component, event, helper) {
        var args = event.getParam("arguments");
        var loggedInUser = args.loggedInUser;
        console.log(JSON.stringify(loggedInUser));
        if (loggedInUser) {
            window.setTimeout(
                $A.getCallback(function() {

                    component.set("v.loggedInUser", loggedInUser);

                    var station_id = loggedInUser.station_id;
                    var last_login_date = new Date(loggedInUser.last_login_date);
                    var todays_date = new Date();

                    var login_day = last_login_date.getDay();
                    var todays_day = todays_date.getDay();
                    component.set("v.selected_value_class","black"); 

                    if (station_id) {
                        if (login_day === todays_day) {
                            //component.set("v.isLoginModalOpen", "true");  
                            helper.loginHelper(component, event);
                        } else {
                            component.set("v.isLoginModalOpen", "true");
                        }
                    } else {
                        let new_value = component.get("v.loggedInUser");
                        component.set("v.isLoginModalOpen", "true");

                    }
                }), 100
            );
        }
    },
    doInit: function(component, event, helper) {
    var loginCreds = component.get("v.loginCreds");
    //alert('test: '+JSON.stringify(loginCreds));
    },
    putOnHoldToggle: function(component, event, helper) {
        
        
    }
})