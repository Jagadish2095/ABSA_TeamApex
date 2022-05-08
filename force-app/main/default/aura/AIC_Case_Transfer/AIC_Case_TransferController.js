({
	doInit: function(component, event, helper) {
               
    },

	openTransferModal : function(component, event, helper) {
		helper.getSelectData(component); 
		component.set("v.openTransfer", true);
		var departmentComment= `
		Dear  <br>
		<br>
		The customer is being referred to you for the reason below.  <br>
		⦁	Uncontactable : Customer is not contactable or reachable  <br>
        ⦁	Invalid number : Invalid number or no contact information on customer profile  <br>
		⦁	Failed Authentication : When customer fails to authenticate during security questions   <br>
		⦁	No documents provided : Is not willing to provide documents  <br>
		
		<br>
		<br>
		Kind regards <br>
		AIC FIC OPS Desk <br>`;
		component.set("v.eamilContent",departmentComment);
	},

	handleChange : function(component, event, helper) {
		let transferTo = component.get("v.transferTo");
		if(transferTo == 'Department'){
			component.set("v.showDepartment", true);
			component.set("v.typeValue","");
			component.find("commentbox").set("v.value","");
		}
		else if(transferTo == 'Queue'){
			component.set("v.showDepartment", false);
			component.find("departmentName").set("v.value","");
			component.find("emailId").set("v.value","");
			component.find("emailContent").set("v.value","");
		}
	},

	closeModal : function(component, event, helper) {
		let transferTo = component.get("v.transferTo");
		if(transferTo == 'Department'){
			component.find("departmentName").set("v.value","");
			component.find("emailId").set("v.value","");
			component.find("commentDepartment").set("v.value","");
			component.find("emailContent").set("v.value","");
			component.set("v.showDepartment", true);
		}else{
			component.set("v.typeValue","");
			component.find("commentbox").set("v.value","");
		}
		component.set("v.openTransfer", false);
	},

	handleTransfer : function(component, event, helper) {
		let transferTo = component.get("v.transferTo");
		if(transferTo == 'Department'){
			let departmentName = component.find("departmentName").get("v.value");
			let emailId = component.find("emailId").get("v.value");
			let commentDepartment = component.find("commentDepartment").get("v.value");
			let emailContent = component.find("emailContent").get("v.value");
			if(departmentName != undefined && emailId != undefined && commentDepartment != undefined && emailContent != undefined && departmentName.trim() != '' && emailId.trim() != '' && commentDepartment.trim() != '' && emailContent.trim() != ''){
				helper.departmentCase(component,event);  
			}else{
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type : 'error',
					mode: 'sticky',
					title: 'Error',
					message: 'Please Fill all value.'
				});
				toastEvent.fire();
			}

		}else{
			let typeValue = component.get("v.typeValue");
			if(typeValue == undefined || typeValue == '' ){
				typeValue = component.get("v.qselectoptions")[0].value;
			}
			console.log(typeValue);
			let commentdata = component.find("commentbox").get("v.value");
			console.log(commentdata);
			if(typeValue != undefined && typeValue != '' && commentdata != undefined && commentdata.trim() != ''){
				helper.transferCase(component,event);  
			}else{
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type : 'error',
					mode: 'sticky',
					title: 'Error',
					message: 'Please Fill all value.'
				});
				toastEvent.fire();
			}

		}
		
	}
})