({
    getSmsHistory : function (component,event) {
        this.showSpinner(component);
        component.set("v.SmsData", '');
        component.set("v.errorMessage", "");
        var datechanges = component.get('v.input1');
        var Date= ($A.localizationService.formatDate(datechanges, "yyyy MM dd")).replace(/-|\s/g,"");
        console.log(Date);
        var Name = component.get('v.UserName');
        var action = component.get('c.getSmsDetails');
        action.setParams({ "personname": Name,
            "dateFrom":Date });

       //Set up the callback
        action.setCallback(this, function(response) {
            var res = response.getReturnValue();
            var state = response.getState();
           console.log("response body =" + res.body);
            if (component.isValid() && state === "SUCCESS") {
                if (res.body !==undefined) {
                    this.hideSpinner(component);
                  component.set("v.SmsData", res.body);

                  this.sendToVF(component);

                }else {
                    this.hideSpinner(component);
                   // this.getToast("Error", " An error Occurred", "error");
                    component.set("v.errorMessage", "No Card Comments Found");
                }

            }else if (state === "ERROR") {
                var errors = res.getError();
                //this.getToast("Error", " An error Occurred", "error");
                component.set("v.errorMessage", "An error Occurred: FPSBUSegment.getRelationshipBanker: " + JSON.stringify(errors));
              }
    });
        $A.enqueueAction(action);

    },
    sendToVF : function(component) {
        var message = component.get("v.SmsData");
        console.log('data to vf' + JSON.stringify(message) );
        var vfOrigin = "https://" + component.get("v.vfHost");
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(JSON.stringify(message), vfOrigin);
    },
    hideSpinner: function (component) {
        component.set("v.showSpinner", false);
      },
    
      showSpinner: function (component) {
        component.set("v.showSpinner", true);
      },

      getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
    
        toastEvent.setParams({
          title: title,
          message: msg,
          type: type
        });
        toastEvent.fire();
      }

})