({
    doInit : function(component, event, helper) {
        helper.getDocumentTypes(component,component.get("v.DocTypes"));
    },
    
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        helper.saveDocs(component);
    },
    
    callCheckboxMethod: function(component, event, helper) {
        var capturedCheckboxName = event.getSource().get("v.value");
        var checkAll = component.find("selectAll");
        var checkTypes = component.find("selectDocType");
        var count = 0;
        for(var i=0; i<checkTypes.length; i++){
            if(checkTypes[i].get("v.checked")){
                count +=1;
            }
        }
        if(count === checkTypes.length){
            checkAll.set("v.checked",true);
        }
        else{
            checkAll.set("v.checked",false);
        }
    },
    selectAll: function(component, event, helper) {
        var allSelected = event.getSource().get("v.checked");
        var checkTypes = component.find("selectDocType"); 
        if(allSelected == true){
            for(var i=0; i<checkTypes.length; i++){
                checkTypes[i].set("v.checked",true);
            }
        }
        else{ 
            for(var i=0; i<checkTypes.length; i++){
                checkTypes[i].set("v.checked",false);
            }
        }
    }
})