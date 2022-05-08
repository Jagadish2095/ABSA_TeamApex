({
    fetchPaymentDetails : function(component,event) {
        this.showSpinner(component);
        var uniqueEFT= component.get('v.value');
        var inputCmp = component.find("UniqueCode");
        if (uniqueEFT == null || uniqueEFT == undefined) {
            this.hideSpinner(component);
            component.set("v.isModalOpen", false);
            inputCmp.setCustomValidity("Enter valid reference number");
            inputCmp.reportValidity();
		}
        var action = component.get('c.getPaymentDetails');
        action.setParams({ uniqueEft : uniqueEFT });

        action.setCallback(this, function(actionResult) {
            var res=actionResult.getReturnValue();
            var state = actionResult.getState();

        if (state == "SUCCESS") {
            if (res.statusCode == 200) {
            if (res.MBgetPaymentDetailV3Response != undefined){
            var response= res.MBgetPaymentDetailV3Response.mbp323o.payment[0];
            var date= response.actDate;
            var formattedDate= date.slice(0,4)+'/'+date.slice(4,6)+'/'+date.slice(6,8);
            var time = response.paymTime;
            var formattedtime = time.slice(0,2)+':'+time.slice(2,4)+':'+time.slice(4,8);
            if (res.MBgetPaymentDetailV3Response.mbp323o.respDesc === "SUCCESSFUL PROCESS") {
                this.hideSpinner(component);
                inputCmp.setCustomValidity("");
                    inputCmp.reportValidity();
                component.set("v.isModalOpen", true);
                component.set('v.timeandDate',formattedtime+ " " +formattedDate);
                component.set('v.creditOrDebitAccount', response.srcAccType);
                component.set('v.transactionAmount','R'+ response.paymProcessAmnt);
                component.set('v.paymentStatus',response.paymStatus);
                component.set('v.paymentChannel',response.sbu);
                component.set('v.paymentReferenceNumber',response.busRef);

                }else if(res.MBgetPaymentDetailV3Response.mbp323o.respDesc ==="REQUESTED DATA NOT FOUND" ) {

                    this.hideSpinner(component);
                    component.set("v.isModalOpen", false);
                    inputCmp.setCustomValidity("Enter a valid reference number");
                    inputCmp.reportValidity();

                }
            }else{

                    this.hideSpinner(component);
                    component.set("v.isModalOpen", false);
                    inputCmp.setCustomValidity("Enter a valid reference number");
                    inputCmp.reportValidity();
                }

            } else {
                //Fire Error Toast
                this.hideSpinner(component);
                    component.set("v.isModalOpen", false);
                    inputCmp.setCustomValidity("Enter a valid reference number");
                    inputCmp.reportValidity();
                this.getToast("Error", "Error while validating Payment "  , "error");
                
            }
            }else if (state === "ERROR") {
                var errors = res.getError();
                this.getToast("Error", " An error Occurred", "error");
				component.set("v.errorMessage", "Apex error MBGetPaymentDetailsCntrl.getPaymentDetails: " + JSON.stringify(errors));
                
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
                 this.hideSpinner(component);

        });
        $A.enqueueAction(action);
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