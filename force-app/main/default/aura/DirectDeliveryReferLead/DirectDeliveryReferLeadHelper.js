({
    createLead : function (component,event)
    {
        component.set("v.showSpinner", true);
        var selproudt;
        if(component.get("v.referralLead.Financial_Product__c") != ''){
            selproudt = component.get("v.referralLead.Financial_Product__c");
        }
        else{
            selproudt = null;
        }
        //var action = component.get("c.createReferredLead");
        console.log('testcheck' +component.get("v.recordId"));
        console.log('value of refer a lead '+JSON.stringify(component.get("v.referralLead")));
        var action = component.get('c.createReferredLead');
        action.setParams({
            "salesLead": component.get("v.referralLead"),
            "recId": component.get("v.recordId"),
            "campaignName": component.get("v.selCampaignVal"),
            "selectedFinancialProduct": selproudt
        });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var lead = response.getReturnValue();
                if(lead != null)
                {
                      component.set("v.referralLead",{ 'sobjectType':'Lead' ,'ID_Number__c':''});
                    this.showToast("success", "Success", "Lead Creation was Successful!!");
                    //window.location.reload();

                    /*
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": lead.Id,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                    */
                     component.set("v.isButtonActive",true);

                }
                else
                {
                    this.showToast("error", "Error", "Lead Creation Failed");
                }
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //alert(errors[0].message);
                        this.showToast("error", "Error", errors[0].message);
                    }
                }
            }

            var productLookup = component.find('prodInterest').get('v.body')[0];
            var receiveingLead = component.find('ownersid').get('v.body')[0];
            
            
            if(productLookup){
            productLookup.updateValues();
            }
            if(receiveingLead){
             receiveingLead.updateValues();
            }
            
            component.set("v.showSpinner", false);

        });
        $A.enqueueAction(action);
    },
    showToast : function (type, title, message)
    {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type
            });
            toastEvent.fire();
        } else {
            alert(message);
        }
    },
})