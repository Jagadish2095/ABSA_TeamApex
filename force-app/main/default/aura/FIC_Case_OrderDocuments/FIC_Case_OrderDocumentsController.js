({
    doInit: function(component, event, helper) {
        //alert('Document Id -->' + component.get('v.documentId'));
        helper.isUnassignedQueue(component);
        helper.getDocuments(component);
        helper.getCase(component, event, helper , "Account application");

    },


    handleChange: function(component, event, helper) {
        let changeValue = event.getParam("value");
        if (changeValue === 'false') {
            component.set("v.ReasonIsMandatory", false);
            // helper.updateInOrder(component, changeValue);
        } else {
            component.set("v.ReasonIsMandatory", true);
            // helper.updateInOrder(component, changeValue);
        }
    },

    handleSubmit : function(component, event, helper){
        let reason = component.get("v.reasonValue");
        if(component.get("v.inOrder") == 'false' && reason == ''){
            alert('Failed Reason Required');
            return false;
        }else{
            helper.submitChanges(component, event, helper);
            let e2 = $A.get("e.c:RefreshPassKYC");
            e2.fire();
        }
        
    },

    backToDocumentsList : function(component, event, helper){
        component.set('v.editMode', false);
        component.set('v.isAllDocs', true);
        let e2 = $A.get("e.c:RefreshPassKYC");
        e2.fire();
    },
    
    onDocumentTypeChange : function(component, event, helper){
        var temeReasons = helper.getReasonsList(component, event, helper,component.find("select1").get("v.value"));
        component.set("v.reasons" ,temeReasons);       
    },
    
    onDocumentFailChange : function(component, event, helper){
        component.set("v.reasonValue" ,component.find("select2").get("v.value"));
    }


})