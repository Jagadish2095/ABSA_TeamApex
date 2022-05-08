({
	getSelectData : function (component) {
        let action = component.get("c.getSelectListData");        
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
			console.log(responseData);
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
					let selectlistData = JSON.parse(responseData);
					if(selectlistData.Queue != undefined){
						component.set("v.qselectoptions",selectlistData.Queue);
					}
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},

	transferCase : function (component, event) {
		let typeValue = component.get("v.typeValue");
        if(typeValue == undefined || typeValue == '' ){
            typeValue = component.get("v.qselectoptions")[0].value;
        }
		let commentdata = component.find("commentbox").get("v.value");

        let action = component.get("c.transferCase");     
		action.setParams({
            "transfertype": typeValue,
            "commentmsg": commentdata,
            "caseId": component.get("v.recordId")
        });   
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
			console.log(responseData);
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
					console.log(responseData);
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						type : 'success',
						title: 'Success',
						message: 'Case Transfer Successfully.'
					});
					toastEvent.fire();
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							type : 'error',
							mode: 'sticky',
							title: 'Error:'  + errors[0].message,
							message: 'Please Fill all value.'
						});
						toastEvent.fire();
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
        component.set("v.openTransfer", false);
        setTimeout(function(){ $A.get('e.force:refreshView').fire(); }, 3000);
        
	},

    departmentCase : function (component, event) {
        let departmentName = component.find("departmentName").get("v.value").trim();
        let emailId = component.find("emailId").get("v.value").trim();
        let commentDepartment = component.find("commentDepartment").get("v.value").trim();
        let emailContent = component.find("emailContent").get("v.value").trim();
        
        let action = component.get("c.departmentCase");     
		action.setParams({
            "departmentName": departmentName,
            "emailId": emailId,
            "commentDepartment": commentDepartment,
            "emailContent": emailContent,
            "caseId": component.get("v.recordId")
        });   
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
			console.log(responseData);
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
					console.log(responseData);
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						type : 'success',
						title: 'Success',
						message: 'Department Emaill sent Successfully.'
					});
					toastEvent.fire();
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							type : 'error',
							mode: 'sticky',
							title: 'Error:'  + errors[0].message,
							message: 'Please Fill all value.'
						});
						toastEvent.fire();
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
        component.set("v.openTransfer", false);
        setTimeout(function(){ $A.get('e.force:refreshView').fire(); }, 3000);
    }
})