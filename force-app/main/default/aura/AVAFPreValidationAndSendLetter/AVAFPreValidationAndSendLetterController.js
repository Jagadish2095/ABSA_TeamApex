({
	/****************@ Author: Chandra**********************************
	 ****************@ Date: 17/11/2020*********************************
	 ****************@ Work Id: W-006962********************************
	 ***@ Description: Method Added by chandra to handle init function*/
	doInit: function (component, event, helper) {
		helper.preValidateAccountNumber(component, event, helper);
	},

	/****************@ Author: Chandra**********************************
	 ****************@ Date: 17/11/2020*********************************
	 ****************@ Work Id: W-006962********************************
	 ***@ Description: Method Added by chandra to close the case*******/
	caseClose: function (component, event, helper) {
		helper.caseCloseHelper(component, event, helper);
	}
});