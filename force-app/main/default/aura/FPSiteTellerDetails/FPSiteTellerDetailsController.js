({
    handleEvent : function(component, event, helper){
        var selectedRecord = event.getParam("record_event");           
        component.set( "v.selectedRecord", selectedRecord); 
        console.log('selectedRecord new***'+ JSON.stringify(selectedRecord));
        console.log('Id first 3***'+ selectedRecord.Id.substring(0, 3));

        if(selectedRecord.Id.substring(0, 3)=="a0f"){
            helper.getSiteDetailsHelper(component, event, helper, selectedRecord.Site_Code__c);
        
        }else if(selectedRecord.Id.substring(0, 3)=="005"){
            var tellerBranchCode = selectedRecord.SiteCode__c.substr(selectedRecord.SiteCode__c.length - 4);
            component.set("v.tellerBranchCode",tellerBranchCode);
            
        }
    },

    getBranchDetails: function(component, event, helper){
        component.set("v.showBranchDetails", true);
        helper.getSiteDetailsHelper(component, event, helper, component.get("v.tellerBranchCode"));
    }

})