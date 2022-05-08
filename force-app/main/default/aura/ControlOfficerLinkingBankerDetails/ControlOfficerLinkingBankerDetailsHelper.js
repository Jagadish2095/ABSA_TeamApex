({
    LinkBanker: function(component, event, helper) {
        var action = component.get("c.LinkBanker");
        action.setParams({oppId:component.get("v.recordId") });
        action.setCallback(this, function(response) {
            this.hideSpinner(component); //hide the spinner
            var state = response.getState();
            var message;
            if (state === "SUCCESS") {
                var CMSResponse = response.getReturnValue();
                console.log('returnValue' + JSON.stringify(CMSResponse));
                
                //TdB change - CAPTURED meanssuccess with no errors
                if(CMSResponse == 'CAPTURED'){
                    this.fireToast('Success!', 'Banker is linked to the Account', 'success');
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.fireToast('CMS Linking Error!', CMSResponse, 'error');
                }
                
            } else if(state === "ERROR")
            {
                var errors = response.getError();                
                this.fireToast('CMS Linking Error!', errors, 'error');
            } else {
                this.fireToast('CMS Linking Error!', response, 'error');
            }
        });
        $A.enqueueAction(action);
    },

    //Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("ltngSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("ltngSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
})