({
	doInit : function(component, event, helper) {

        helper.showSpinner(component);

        component.set('v.columns', [
            {label: 'Surname', fieldName: 'surname', type: 'text'},
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'Initials', fieldName: 'initials', type: 'text'},
            {label: 'Identity Number', fieldName: 'idNbr', type: 'text'},
            {label: 'Compulsory', fieldName: 'compulsorySign', type: 'text'},
            {label: 'Date Issued', fieldName: 'dateIssued', type: 'text'},
            {label: 'Designation', fieldName: 'designation', type: 'text'},
            {label: 'Email', fieldName: 'emailAddress', type: 'text'},
            {label: 'Mobile Number', fieldName: 'homeTelephone', type: 'text'}

        ]);

        var action = component.get('c.getMandate');
		var accNumber = component.get('v.accountNumber');

        action.setParams({
            "accNr" : accNumber
		});

        action.setCallback(this, $A.getCallback(function (response) {

			var state = response.getState();
			console.log('State ******** ' +  state)
            if (state === "SUCCESS") {

                var result = JSON.parse(response.getReturnValue());
                console.log('Results -----------> ' + result);
                if(result != null){
                    component.set("v.listResults" , result);
                	helper.hideSpinner(component);
                }else{
                    var toast = helper.getToast("Error", "Mandate not found for this Account", "error");
                	toast.fire();
                    helper.hideSpinner(component);
                }


            } else if (state === "ERROR") {

				var toast = helper.getToast("Error", "There was an error retrieving the Mandate for this Account", "error");

				helper.hideSpinner(component);

				toast.fire();
            }
        }));

        $A.enqueueAction(action);

    },

    setSelectedMandate: function(component, event, helper) {
        var selectedRows = event.getParam("selectedRows")[0];
        component.set("v.surname" , selectedRows.surname);
        component.set("v.idNumber" , selectedRows.idNbr);
        component.set("v.mundateEmail" , selectedRows.emailAddress);
        component.set("v.mandateMobile" , selectedRows.homeTelephone);
        component.set("v.showXDSVerification" , true);
    },

    initComp: function(component, event, helper) {
        //Get Questions and Answer From XDS
       helper.getQnA(component);
    },

    handleChange: function(component, event, helper) {
         helper.showSpinner(component);
        var question = event.getSource().get("v.name");
        var selectedValue = event.getSource().get("v.value");

        if(selectedValue == '-Please Select-'){
            var toastEvent = helper.getToast("Error", "Please select proper answer", "error");
            toastEvent.fire();
        }
        var requestBeanForVerification1 = component.get("v.requestBeanForVerification");
        if(!requestBeanForVerification1){

            requestBeanForVerification1 = component.get("v.responseBean");
        }
        requestBeanForVerification1.questions.questionDocument.forEach(function(quest){

            if(quest.question == question){

                quest.answers.answerDocument.forEach(function (ans){

                    if(ans.answer == selectedValue && ans.isEnteredAnswerYN == false){

                        ans.isEnteredAnswerYN = true;
                    }
                    else{
                        ans.isEnteredAnswerYN = false;
                    }
                });
            }
        });

        component.set("v.requestBeanForVerification",requestBeanForVerification1);
        helper.hideSpinner(component);
    },
    sendAnswers: function(component, event, helper) {
        helper.showSpinner(component);
        helper.setAnswers(component);

    },
    handleXDSbyPass: function (component, event) {

        var xdsBypassChecked = component.get("v.byPassXDS");

        var action = component.get("c.logXDSBypass");

        action.setParams({
            caseRecId : component.get("v.caseId"),
            bypassChecked : xdsBypassChecked
        });

        action.setCallback(this, function(response) {

            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {

                var result = response.getReturnValue();

                if(xdsBypassChecked == true){

                    component.set("v.byPassXDSBy", result.xdsBypassBy);
                    component.set("v.byPassXDSDate", result.xdsBypassDate);
                    component.set("v.showVerifyButton", false);
                    component.set("v.xdsDecision", true);
                    component.set("v.isshowError", false);
                    component.set("v.xdsMessage",'User authenticated! Please click Next button continue.');

                }else{

                    component.set("v.byPassXDSBy", null);
                    component.set("v.byPassXDSDate", null);
                    component.set("v.showVerifyButton", true);
                    component.set("v.xdsDecision", false);
                }
            }

        });

        $A.enqueueAction(action);

    }
})