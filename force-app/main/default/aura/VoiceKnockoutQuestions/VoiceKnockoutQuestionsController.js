({
	init: function (component, event, helper) {
		var templateName = component.get("v.questionnaireTemplateName");
		helper.knockoutHelper(component, templateName);
	},

	atestationChange: function (component, event) {
		var result = event.getParam("value");
        if(result == "accept"){
            component.set("v.knockoutQuestionResult",true);
			component.set("v.knockoutQuestionResultAccept", true);
		    component.set("v.isCheckBoxOn", true);
		    component.set("v.canSave", false);

        }else{
            component.set("v.knockoutQuestionResult",false);
            component.set("v.knockoutQuestionResultAccept", false);
            component.set("v.isAllClausesSet",false);
		    component.set("v.isCheckBoxOn", false);
		    component.set("v.canSave", true);

        }

	},

	RequireIDPORChange: function (component, event, helper) {
		var globalId = component.getGlobalId();
		var requireIDPOR = document.getElementById(globalId + "_RequireIDPOR");
		component.set(" v.requireIDPORChecked ", requireIDPOR.checked);
		helper.SelectionCallback(component, event);
	},

	CasaClauseChange: function (component, event, helper) {
		var globalId = component.getGlobalId();
		var casaClause = document.getElementById(globalId + "_CasaClause");
		component.set(" v.casaClauseChecked ", casaClause.checked);
		component.set(" v.canSave ", casaClause.checked);

		helper.SelectionCallback(component, event);
	},

	ReadCasaClause: function (component, event, helper) {
		component.set("v.isCheckBoxOn", false);
	},

    // handleNavigate: function(component, event, helper) {
    //     var navigate = component.get("v.navigateFlow");
    //     var actionClicked = event.getParam("action");
	// 	var result = component.get("v.knockoutQuestionResult");

    //     component.set('v.updating', true);
    //     console.log(`KO result : ${result}`);
    //     switch(actionClicked){
    //         case "NEXT":
    //         case "FINISH":
    //             if(result){

    //                 var action = component.get("c.submitKnockoutQuestions");
    //                 // set param to method
    //                 action.setParams({
    //                     templateName: component.get("v.questionnaireTemplateName"),
    //                     opportunityId : component.get("v.recordId"),
    //                     hasClientAgreed : result
    //                 });
    //                 // set a callBack
    //                 action.setCallback(this, function (response) {
    //                     $A.util.removeClass(component.find("mySpinner"), "slds-show");
    //                     var state = response.getState();
    //                     if (state === "SUCCESS") {
    //                         console.log(`DONE... with a result of ${result}`);
    //                     } else {
    //                         console.error(`ERROR...`);
    //                     }
    //                     component.set('v.updating', false);
    //                     navigate(actionClicked);

    //                 });
    //                 //enqueue the Action
    //                 $A.enqueueAction(action);
    //                 console.log(`CONTINUING...`);
    //             }else{
    //                 console.warn(`STOP THE BUS`);
    //                 navigate(actionClicked);

    //             }
       
    //             break;
    //         case "BACK":
    //         case "PAUSE":
    //             component.set('v.updating', false);
    //             navigate(event.getParam("action"));
    //             break;
    //     }
    // },

    save: function(component, event, helper) {
        //var navigate = component.get("v.navigateFlow");
        //var actionClicked = event.getParam("action");
		var result = component.get("v.knockoutQuestionResult");

        if(result){
            var action = component.get("c.submitKnockoutQuestions");
            // set param to method
            action.setParams({
                templateName: component.get("v.questionnaireTemplateName"),
                opportunityId : component.get("v.recordId"),
                hasClientAgreed : result
            });
            // set a callBack
            action.setCallback(this, function (response) {
                $A.util.removeClass(component.find("mySpinner"), "slds-show");
                var state = response.getState();
                if (state === "SUCCESS") {
		            component.set("v.canSave", false);
                    console.log(`DONE... with a result of ${result}`);
                    helper.fireToast("Success", "User answers saved! Please click Next button continue.", "success");

                } else {
                    console.error(`ERROR...`);
				    helper.fireToast("Error", "Something went wrong.", "error");
                }
                component.set('v.updating', false);

            });
            //enqueue the Action
            $A.enqueueAction(action);
            console.log(`CONTINUING...`);
        }else{
            component.set("v.canSave", false);
            console.warn(`STOP THE BUS`);
            helper.fireToast("Flow exiting", "Not all terms were met.", "warning");
        }
    }
})