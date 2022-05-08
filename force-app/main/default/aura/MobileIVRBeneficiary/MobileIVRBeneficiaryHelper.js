({
    doInit : function(component, event, helper) {
        console.log('Fetching response for table');
        var action = component.get("c.getNewMobile");
        var pageSize = component.get("v.pageSize");
        action.setParams({CIFKey:component.get("v.CifKey")});
        component.set('v.showSpinner',true);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                if(respObj != null){ 
                    component.set("v.mobileBenList", respObj);
                    component.set("v.totalSize", component.get("v.mobileBenList").length);
                    component.set("v.start",0);
                    component.set("v.end",pageSize-1);
                    var paginationList = [];
                    for(var i=0; i< pageSize; i++){
                        paginationList.push(respObj[i]);
                    }
                }
                component.set('v.showSpinner',false);
                component.set("v.paginationList", paginationList);
            }
        });
        $A.enqueueAction(action);
    },
    
    getToast : function(title, msg, type) {
        
		 var toastEvent = $A.get("e.force:showToast");
        
            toastEvent.setParams({
                "title":title,
                "message":msg,
                "type":type
         });
        
        return toastEvent;
    },

    //Fire Sticky Lightning toast
    fireStickyToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode":"sticky",
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
})