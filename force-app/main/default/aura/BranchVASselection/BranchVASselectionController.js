({
    init: function(component, event, helper) {
        let internetBankingUserIdNumbers =  component.get("v.internetBankingUserIdNumbers");
        let CCApplicationNumber =  component.get("v.CCApplicationNumber");
        let recordId =  component.get("v.recordId");
        helper.getMarkgConsCreditPicklist(component, event, helper);
        helper.getMarkgConsNonCreditPicklist(component, event, helper);
        helper.getContactDetails(component, event, helper);
    },
    handleNewProductsGroup: function(component, event, helper){
        var newProductsValueAnswer = event.getSource().get('v.value');
        component.set('v.newProductsValue',newProductsValueAnswer);
        console.log('answer'+newProductsValueAnswer);

            if(newProductsValueAnswer == "no"){
                component.set('v.newProductsAnswerIsNo',true); 
            }
            else{
                component.set('v.newProductsAnswerIsNo',false);
            }
        },

    handleQualifyFutureGroup: function(component,event,helper){
        var qualifyFutureAnswer = event.getSource().get('v.value');
        component.set('v.qualifyFutureValue',qualifyFutureAnswer);
        console.log('answer:'+qualifyFutureAnswer);

        if(qualifyFutureAnswer == "yes"){
            component.set('v.qualifyFutureAnswerIsYes',true);
        }
        else{
            component.set('v.qualifyFutureAnswerIsYes',false);
        }
    },

    setCheckBoxValue: function(component,event) {
        var val = event.currentTarget.value;

        component.set("v.cons2.PicklistValue",val);
    },
    
    onCheck: function(component,event) {
        var checkbox = component.find('AnswerYesCheckBoxGroup').get('v.value');  
        console.log('checkin:'+checkbox);
        component.set("v.cons2.PicklistValue",checkbox);

    },
    editContactDetails: function(component, event){
        component.set("v.isOpen", true);
    },

    cancelContactEdit: function(component, event) {
        component.set("v.isOpen", false);
    },
    handlevasFulfilmentEvent: function (component, event, helper) {
        var digitalBankingInd = event.getParam("digitalBankingInd");
        var notifyMeInd = event.getParam("notifyMeInd");
        var eStatementInd = event.getParam("eStatementInd");
        var rewardsInd = event.getParam("v.rewardsInd");

        if (digitalBankingInd != null)
            component.set("v.digitalBankingInd", digitalBankingInd);

        if (notifyMeInd != null)
            component.set("v.notifyMeInd", notifyMeInd);

        if (eStatementInd != null)
            component.set("v.eStatementInd", eStatementInd);

        if (rewardsInd != null)
            component.set("v.rewardsInd", rewardsInd);
    },

    saveContactDetails: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var recordId = component.get("v.recordId");
        var email = component.get("v.emailAddress");
        var cellphone = component.get("v.cellphone");
        var alternativeNumber = component.get("v.alternativeNumber");

        var contactObj = {
            recordId : recordId,
            email : email,
            cellphone : cellphone,
            alternativeNumber : alternativeNumber
        }
        var action = component.get("c.updateContactDetails");
            action.setParams({
                contactObj: JSON.stringify(contactObj)
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var result = response.getReturnValue();
                    if (result == 'Success') {
                        component.set("v.isOpen", false);
                    } else {
                        component.find('branchFlowFooter').set('v.heading', 'Failed to update contact details');
                        component.find('branchFlowFooter').set('v.message', result);
                        component.find('branchFlowFooter').set('v.showDialog', true);
                    }
                    component.set("v.showSpinner", false);
                } else if(state === "ERROR"){
                    component.set("v.showSpinner", false);
                    var errors = response.getError();
                    if(errors) {
                        if(errors[0] && errors[0].message){
                            component.find('branchFlowFooter').set('v.heading', 'Failed to update contact details');
                            component.find('branchFlowFooter').set('v.message', errors[0].message);
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        }
                        else{
                            component.find('branchFlowFooter').set('v.heading', 'Failed to update contact details');
                            component.find('branchFlowFooter').set('v.message', 'unknown error');
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        }
                    }
                }
                else if(state === "INCOMPLETE"){
                    component.set("v.showSpinner", false);
                    component.find('branchFlowFooter').set('v.heading', 'Failed to update contact details');
                    component.find('branchFlowFooter').set('v.message', 'Incomplete action. The server might be down or the client might be offline.');
                    component.find('branchFlowFooter').set('v.showDialog', true);
                }
            });
        $A.enqueueAction(action);
    },
    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');

        switch(actionClicked)
        {
            case 'NEXT':
            case 'FINISH':
                {
                    if (helper.checkMarketingConsentSelected(component)) {
                        var promise = helper.onSubmit(component, helper)
                        .then(
                            // resolve handler
                               $A.getCallback(function(result) {
                                    var promise = helper.updateCIF(component, helper)
                                    .then(
                                        // resolve handler
                                        $A.getCallback(function(result) {
                                            navigate(actionClicked);
                                        }),
                                        // reject handler
                                        $A.getCallback(function(error) {
                                            //add error code
                                        })
                                    )
                                }),
                                // reject handler
                                $A.getCallback(function(error) {
                                    //add error code
                                })
                            )
                    }
                    break;
                }
            case 'BACK':
                {
                    navigate(actionClicked);
                    break;
                }
            case 'PAUSE':
                {
                    navigate(actionClicked);
                    break;
                }
        }
    },

    handleSetUpSelectedUsersEvent : function (component, event, helper) {
        const selectedUserIds = event.getParam("selectedUserIds");
        component.set("v.internetBankingUserIdNumbers", selectedUserIds);
    }
})