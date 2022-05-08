({
    doInit: function(component, event, helper) {
        var action = component.get("c.getUserInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();                
            if (component.isValid() && state === "SUCCESS") {
                helper.resetDashboard(component, event);    
                var res = response.getReturnValue();
                var retResponse = res.supportValue;
                var userInfo = res.userInfo;
                
                if(retResponse == 0){                      
                  component.set("v.supportVisible", "slds-show");
                  component.set("v.searchCardVisible", "slds-hide");  
                }
                else if(retResponse == 1){                    
                  component.set("v.supportVisible", "slds-hide");
                  component.set("v.searchCardVisible", "slds-show");    
                }
                var loggedInUser = {
                    username: userInfo.Username,
                    ab_number: userInfo.AB_Number__c,
                    fullname: userInfo.Name,
                    email: userInfo.Email,
                    firstname: userInfo.FirstName,
                    lastname: userInfo.LastName,
                    supportValue:userInfo.supportValue,
                    dbs_dashboard_do_not_show: userInfo.DBS_Dashboard_Do_Not_Show__c                    
                };
                
                var logInObj = component.get("v.data");
                logInObj.loggedInUser = loggedInUser;
                console.log(JSON.stringify(logInObj.loggedInUser));
                component.set("v.data", logInObj); 
                
                if (!userInfo.DBS_Dashboard_Do_Not_Show__c) {
                    component.set("v.showWrapUpModal", true);
                }
                
                //set focus on search field
                document.getElementById("accAccOrIdNum").focus();
            }
        });
        $A.enqueueAction(action);        
    },
    navigationHandler: function(component, event, helper) {
        helper.navigationHelper(component, event);
    },
    anchorCursor: function(component, event, helper) {
        helper.anchorCursorHelper(component, event);
    },     
    handleKeyUp: function(component, event, helper) {

       var isEnterKey = event.keyCode === 13;
       if (isEnterKey) {
           helper.postItemToQueue(component, event);
       }
    },
    beforePost: function(component, event, helper) {
       helper.postItemToQueue(component, event);  
       //helper.getDataFromObjectHelper(component, event);
    },    
    updateIIPsHandler: function(component, event, helper) {
        var iips = event.getParam("updatedIIPsObj");
        var key = event.getParam("key");
 		var IIPHoldAction = component.get("v.IIPHoldAction");  
        if(iips){
            if(key){   
                var statusMsg = iips[key].value.iip_hold_status_message;
                if(statusMsg.includes('successfully')){
                    var notesData = component.get("v.data.notesData");
                    
                    var message = 'No selected action';
                    var errorAction = 'reversal';
                    if(IIPHoldAction=='release'){
                        message = 'Released IIP hold. ';
                    }
                    if(IIPHoldAction=='cancel'){
                        message='Cancelled IIP. '; 
                        errorAction = 'cancellation'; 
                    }
	                    
					var action = {note: message};
                    
					notesData.push({value: action, key});  
                    component.set("v.data.notesData", notesData);                     
                }else if(statusMsg){
                     component.set("v.modalObj", {isOpen: true, header: 'IIP '+errorAction+' error', body: statusMsg});                  
                }       
                //hide notes spinnner
        		component.set("v.data.showSpinner.notes", 'slds-hide');                  
            }
		    helper.enableWrapUpButton(component, event);
            component.set("v.data.iipsData", iips);              
        }      
    },    
    updateReversedDebitOrdersHandler: function(component, event, helper) {
       var debits_data = event.getParam("updatedDebitsObj");
        var key = event.getParam("key");
        console.log('-- reversed outer '+debits_data[key].value.debit_order_transaction_status);
        console.log(JSON.stringify(debits_data));
        if(debits_data){
            if(key){   
                 
                if(debits_data[key].value.debit_order_transaction_status == 'Successfully reversed'){
                    var notesData = component.get("v.data.notesData");
                    
					var action = {note:debits_data[key].value.debit_order_transaction_status +' R'+debits_data[key].value.amount+' debit order.'};
					notesData.push({value: action, key});  
                    component.set("v.data.notesData", notesData);                                                                   
                }else if(debits_data[key].value.debit_order_transaction_status){
                     var errorMsg = debits_data[key].value.debit_order_transaction_status;
                     component.set("v.modalObj", {isOpen: true, header: 'Debit order reversal error', body: errorMsg}); 
                     debits_data[key].value.debit_order_transaction_status = 'Failed to reverse debit order';
                }                
                //hide notes spinnner
        		component.set("v.data.showSpinner.notes", 'slds-hide');                 
            }
            
		    helper.enableWrapUpButton(component, event);
            component.set("v.data.debitsData", debits_data);  
        }
    },
    updateReleasedSimHoldHandler: function(component, event, helper) {
        var sim_holds = event.getParam("updatedHoldsObj");
        var key = event.getParam("key");

        var asterisk = '';
        if (sim_holds[key].value.sim_hold_status == 'Yes' || sim_holds[key].value.sim_hold_status == 'Y') {
            asterisk = '*';
        }
        component.set("v.sim_holds_tab_red_star", asterisk);
        component.set("v.data.simsData", sim_holds);

        

        if (sim_holds[key].value.sim_hold_status == 'No') { 
            var notesData = component.get("v.data.notesData");
            var action = {note: 'User ' + sim_holds[key].value.user_number + ' sim hold successfully released. Number: '+ sim_holds[key].value.sim_hold_number+'.'};
            notesData.push({value: action, key});                                   
            component.set("v.data.notesData", notesData);
        }
        //hide notes spinner
        component.set("v.data.showSpinner.notes", 'slds-hide'); 
                            
        helper.enableWrapUpButton(component, event);
    },
    updateNotesHandler: function(component, event, helper) {
        var notes = event.getParam("additionalNotes");
        var botStatus = event.getParam("botStatus");
        component.set("v.additionalNotes", notes);
		
        helper.enableWrapUpButton(component, event);

        if (botStatus > 1) {
            document.getElementById("accAccOrIdNum").value = "";
            component.set("v.accAccOrIdNum", null);            
            helper.resetDashboard(component, event);
        }
    },
    wrapUpHandler: function(component, event, helper) {
        
        component.set("v.data.wrapUpBtnDisabled", true);
       
        var notesData = component.get("v.data.notesData");
     
        var notes = '';
        var notesFommatedForAbBot = '';
        var notesForAbBot = '';
        var index = 1;

        component.set("v.data.notesData", notesData);

        for (var key in notesData) {
            var keyVal = notesData[key];
            if (!keyVal) {
                break;
            }

            if (notes) {
                notes = notes + '<br/>' + index + '. ' + notesData[key].value.note; 
                notesFommatedForAbBot = notesFommatedForAbBot + ' ' + index + '. ' + notesData[key].value.note;
            } else {
                notes = '<b>Completed actions:</b><br/>' + index + '. ' + notesData[key].value.note;
                notesFommatedForAbBot = index + '. ' + notesData[key].value.note;
            }
            index++;
        }
        var additionalNotes = component.get("v.additionalNotes");
        if (additionalNotes) {
            notes = notes + '<br/><br/><b>Additional notes:</b><br/>' + additionalNotes;
        }

        var loggedInUser = component.get("v.data.loggedInUser");
        notesForAbBot = "User: " + loggedInUser.firstname + " " + loggedInUser.lastname + " Notes: " + notesFommatedForAbBot + " " + additionalNotes;
        component.set("v.formattedNotes", notesForAbBot);
        console.log(notes);

        function listener(e) {
            e.clipboardData.setData("text/html", notes);
            e.preventDefault();
        }
        document.addEventListener("copy", listener);
        document.execCommand("copy");
        document.removeEventListener("copy", listener);

        var showWrapUpModal = component.get("v.showWrapUpModal");
        if (showWrapUpModal) {
            component.set("v.wrapUpModal", true);
        } else {
            helper.navigateToSharePointHelper(component, event);
        } 
    },
})