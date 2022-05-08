({
    /****************@ Author: Nagpal Singh***************************
 	*****************@ Date: 2021-05-17*******************************
 	*****************@ Work Id: W-011446******************************
 	*****************@ Description: Method to handle **/

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
            secURL = $A.get("$Label.c.Performance_Dashboard_Link")+component.get("v.userABNumber")+'?ShowTitleBar=true&TLSelect=true';
            component.set("v.srcURL",secURL);
        }
    }
})