({
    /****************@ Author: Nagpal Singh********************************
 	*****************@ Date: 2021-05-27 ***********************************
 	*****************@ Work Id: W-011441***********************************
 	*****************@ Description: Method to handle init function*********/

    doInit : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userId",userId);
    },

    //Method is  calling for user AB Number
    handleRecordUpdated: function (component, event, helper) {
        var secURL;
        var eventParams = event.getParams();
        if (eventParams.changeType === "LOADED" || eventParams.changeType === "CHANGED") {
            if(component.get("v.userRecord.AB_Number__c")){
                component.set("v.userABNumber",component.get("v.userRecord.AB_Number__c"));
            }else{
                component.set("v.userABNumber",'Salesforce');
            }
            secURL = $A.get("$Label.c.Strategic_Dashboard_Link")+component.get("v.userABNumber")+'?ShowTitleBar=true';
            component.set("v.srcURL",secURL);
        }
    },

    // Method is for the new value display the corresponding tabby updating the value of selected tab
    handleChange: function(component) {
        var secURL;
        var ABNumExtension = component.get("v.userABNumber")+'?ShowTitleBar=true';
        var selected = component.get("v.tabId");
        component.find("tabs").set("v.selectedTabId", selected);
        if(component.find("tabs").get("v.selectedTabId") == 'strategicDashboard'){
            secURL = $A.get("$Label.c.Strategic_Dashboard_Link")+ABNumExtension;
        }
        else if (component.find("tabs").get("v.selectedTabId") == 'teamDashboard'){
            secURL = $A.get("$Label.c.Team_Dashboard_Link")+ABNumExtension;
        }else if (component.find("tabs").get("v.selectedTabId") == 'consultantDashboard'){
            secURL = $A.get("$Label.c.Consultant_Dashboard_Link")+ABNumExtension;
        }
        component.set("v.srcURL",secURL);
    }
})