({
    doInit : function(component, event, helper){
        var param = {};
        helper.component = component ;
        helper.callServer('getChecklistTemplateRecord', param, false, function(resp){
            //console.log('resp',resp);
            if(resp.isSuccess){	
                component.set('v.chkList', resp.objectList);
            }
            else{
                helper.showMsg(component, event, 'Error', 'error', resp.message);
                console.log('message',resp.message);
            } 
            
        });
        
        helper.callServer('getQAtemplateRecord', param, false, function(resp){
            console.log('resp',resp);
            if(resp.isSuccess){	
                component.set('v.qaList', resp.objectList);
                console.log('**HUB**',resp.objectList[0].Business_Area__c);
                if(resp.objectList[0].Business_Area__c == 'Customer Value Management' || resp.objectList[0].Business_Area__c == 'Retail And Business Bank'){
                    component.set('v.retailUser', true);
                }
            }
            else{
                helper.showMsg(component, event, 'Error', 'error', resp.message);
                console.log('message',resp.message);
            } 
            
        });
    }, 
    
    setChkValue: function (component, event, helper) {
        var templateId = component.find("checkSelect").get("v.value");
        var caseId = component.get("v.recordId");
        if(templateId){
        helper.navigateToCaseForm(component, event, 'lscCaseChecklistForm', templateId, caseId);
        }
    },
    setQAValue: function (component, event, helper) {
         var templateId = component.find("qaSelect").get("v.value");
         //component.set("v.qaId", selectedVal);
         var caseId = component.get("v.recordId");
        if(templateId){
            //koketso - load component depending on the user hub
            var qaComponent;
            var isRetailUser = component.get('v.retailUser');
            
            console.log('**isRetailUser**',isRetailUser);
            if(isRetailUser == true){
                qaComponent = 'RetailCaseQaForm';
            }else{
                qaComponent = 'lscCaseQaForm';
            }
            
            helper.navigateToCaseForm(component, event, qaComponent, templateId, caseId);
        }
    },
    
    openTab : function(component, event, pagename) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '/Case_Checklist_Form',
            focus: true
        });
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    
})