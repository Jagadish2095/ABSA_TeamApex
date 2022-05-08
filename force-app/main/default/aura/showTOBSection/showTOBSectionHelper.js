({
	setTobFields: function(component, event) {
        var productLabel = component.get("v.prodrec.appProductLabel");
        var productName = '';
        if(productLabel.includes('Overdraft')){
            productName = 'Overdraft';
        }
        else if(productLabel.includes('Overdraft')){
            productName =  'Credit Card'
        }
        else if(productLabel.includes('Term Loan')){
            productName = 'Term Loan';
        }
        component.set("v.productName", productName);
        var action = component.get("c.getfWrapperList");
        action.setParams({
            "productName": productName
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("field wrapper state---"+state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results fieldWrapList---'+JSON.stringify(results));
                component.set("v.fieldWrapList",results);
                
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    },
    
    setshowTobFields: function(component, event) {
        var action = component.get("c.getLimitTypeFields");
        /*action.setParams({
            "oppId": component.get("v.recordId")
        });*/
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("show field wrapper state---"+state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results fieldWrapList---'+JSON.stringify(results));
                component.set("v.showfieldWrapList",results);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    saveFinalTOB : function(component,event){
        
         var action = component.get("c.saveTOB");
        action.setParams({
            "appProdId": component.get("v.prodrec.appProdId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("show field wrapper state---"+state);
            if (state === "SUCCESS") {
                
                component.find('notifLib').showToast({
                                                 "title": "Adjustment Saved!",
                                                 "message": "Adjustment has been saved successfully.",
                                                 "variant": "success"
                                                });
                
                 component.set("v.showSpinner",true);
                
            }
        });
        $A.enqueueAction(action);
     $A.get('e.force:refreshView').fire();
},
    
})