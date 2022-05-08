({  
    generatePDF: function(component, event, helper) { 
        helper.generatePDFHelper(component, event);    	
    },
    doInit: function(component, event, helper) {  
		var action = component.get("c.loadStaticResource");

            action.setParams({
                
            });
            action.setCallback(this, function(response) {
                
                var val = response.getReturnValue();
                
                helper.getClientObject(component, event,val);
                
                helper.getUserInfor(component, event);
                
                        
            });
            $A.enqueueAction(action);          
    },
     /* Trigger dashboard upon clicking enter on keyboard*/
    openDashboardOnKeyUp: function(component, event, helper) {
        var isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            helper.fetchClientData(component, event);
        }
    },
    /*Trigger dashobard upon clicking search icon button*/
    openDashboardOnClick: function(component, event, helper) {
        helper.fetchClientData(component, event);  
    },
    
    /* CTI */ 
    invokeDashboard: function(component, event, helper) {
		var obj = event.getParam("sockObj"); 
        if(obj){ 
            console.log(JSON.stringify(obj));
     
            var conLen = obj.activeConnections.length;
            
            if(obj.eventType == 'connectionDisconnected'){                
                component.set("v.IdNumber", null);
                return;
            }
             
            var activeConnection = '';
            if(conLen > 0){
                activeConnection = obj.activeConnections[0];
            }else{
                return;
            }     
          
            //console.log(JSON.stringify.activeConnection('activeConnection: '+activeConnection));
            if(activeConnection){
                component.set("v.activeCall", activeConnection);    
                if(obj.activeConnections[0].cellNumber == 'UNKNOWN'){ 
                    return;
                }    
                component.set("v.IdNumber", obj.activeConnections[0].customerId);
          
            }else{
                component.set("v.activeCall", "");
                return;
            } 
            if(!component.get("v.IdNumber")){
                return;
            }
            var self = helper;
            window.setTimeout(
                $A.getCallback(function() {
                    helper.fetchClientData(component, event);
                }), 100
            );
        }        
        
    },    
    /* Navigation*/
    hyperlinkNavController: function(component, event, helper) {
       var clickedTab = event.currentTarget.id;
        
       var navLink = component.get("v.navLink");    
       var currindex = navLink[clickedTab];
                 
	   helper.navigationHelper(component, event, currindex);          
    },       
    navigationHandler: function(component, event, helper) {
        helper.navigationHelper(component, event, null);
    },    
    goForward: function(component, event, helper) {
        
        if(component.get('v.validate_update_obj') && (component.get("v.exception_API_Name").includes("CASA screening") || component.get("v.exception_API_Name").includes("Risk profile"))){
            let exception_API_Name =  component.get('v.exception_API_Name');
            let validate_update_obj =  component.get('v.validate_update_obj');
            let exceptionType = component.get('v.validate_update_err_exceptionType');
            helper.errorMessagesHelper(component, event, exception_API_Name,validate_update_obj, exceptionType);
            return;
        }
        
        if(component.get('v.validate_update_obj') && component.get("v.currentTab") =="productSelection"){
            let exception_API_Name =  component.get('v.exception_API_Name');
            let validate_update_obj =  component.get('v.validate_update_obj');
            let exceptionType = component.get('v.validate_update_err_exceptionType');
            helper.errorMessagesHelper(component, event, exception_API_Name,validate_update_obj, exceptionType);
            return;
        } 
        
        
        if(component.get('v.validate_update_obj') && component.get("v.currentTab") =="loanApplication"){
            let exception_API_Name =  component.get('v.exception_API_Name');
            let validate_update_obj =  component.get('v.validate_update_obj');
            let exceptionType = component.get('v.validate_update_err_exceptionType');
            helper.errorMessagesHelper(component, event, exception_API_Name,validate_update_obj, exceptionType);
            return;
        }
        
        if(component.get('v.validate_update_obj') && component.get("v.currentTab") =="livingExpenses"){
            let exception_API_Name =  component.get('v.exception_API_Name');
            let validate_update_obj =  component.get('v.validate_update_obj');
            let exceptionType = component.get('v.validate_update_err_exceptionType');
            helper.errorMessagesHelper(component, event, exception_API_Name,validate_update_obj, exceptionType);
            return;
        } 
        
        var theMap = component.get("v.tabMap");
        var tabMapRev = component.get("v.tabMapRev");
        var selTabId = component.get("v.selTabId");
        
        let currentTab = component.get("v.currentTab");
        var currindex = theMap[currentTab];
        var nextTab = tabMapRev[currindex + 1];    
        
        var client = component.get("v.client");       
        helper.navigationHelper(component, event, nextTab);
    },
    goBackward: function(component, event, helper) {
        component.set('v.validate_update_obj','');
        var theMap = component.get("v.tabMap");
        var tabMapRev = component.get("v.tabMapRev");
        var selTabId = component.get("v.selTabId");
        var currindex = theMap[selTabId];
		var nextTab = tabMapRev[currindex - 1];    
        component.set("v.selTabId", nextTab);
        helper.navigationHelper(component, event, nextTab);
    },    
    cancelApplication: function(component, event,helper){
        
       helper.resetDashboard(component, event);         
    }    ,
    securityQuestionController: function(component, event,helper){
        var securityResult= component.get("v.client.securityQuestionsResult");
        if(securityResult == 'Passed'){
            //populate the client object
             
        }
        if(securityResult == 'Failed'){ 
             helper.resetDashboard(component, event);            
            //var cancelApplication = component.get('c.cancelApplication');
            //$A.enqueueAction(cancelApplication);        
        }
    },
    finalizeApplicationController: function(component, event,helper){
        
        helper.finalizeApplication(component, event);
        
    }
    
})