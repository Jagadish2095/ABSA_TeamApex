({
    doInit: function (component, event, helper) {
        helper.getAppPrdctCpfRec(component, event, helper);
        helper.getAppTeamMemberRec(component, event, helper);
        //helper.getAppOtherFeesRec(component, event, helper);
        
    },
    
    addTeamMember:function(component, event, helper) {
        var teamMemberdetails = component.get("v.newProfessionalTeamMember");
        teamMemberdetails.push({
            'sobjectType' : 'Application_Team_Member__c',
        });
        component.set("v.newProfessionalTeamMember",teamMemberdetails); 
    },
    handleteamMemberAppEvent: function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var teamMemberlst=component.get("v.newProfessionalTeamMember");
        teamMemberlst.splice(rowinex,1);
        component.set("v.newProfessionalTeamMember",teamMemberlst);
    },
    
    handleSubmit : function(component, event, helper) {
        helper.updateAppPrdctcpf(component, event, helper);
        
    }
    
    
})