({

init: function(component, event, helper)
{
    component.set('v.validate', function() {
    });
    var processType =component.get("v.processType");
    if(processType ==='Voice Sales Product Onboarding'){
        var productType=component.get('v.ProductTypeList')
        console.log('productType'+JSON.stringify(productType));
        component.set('v.ProductTypeList',[{'label': 'Transactional Savings', 'value': 'TRANSACTIONAL_SAVINGS_VOICE'},
                                            {'label': 'Transactional Cheque', 'value': 'TRANSACTIONAL_CHEQUE_VOICE'}
                                            ]);
    }
    //Added by Diksha 16/09/2021
    //For Voice only few product list to show hence moving default product list to init.
    else{
        component.set('v.ProductTypeList',[{'label': 'Package', 'value': 'PACKAGES'},
                                            {'label': 'Savings And Investments', 'value': 'SAVINGS_OR_INVESTMENT'},
                                            {'label': 'Transactional Savings', 'value': 'TRANSACTIONAL_SAVINGS'},
                                            {'label': 'Transactional Cheque', 'value': 'TRANSACTIONAL_CHEQUE'},
                                            {'label': 'Credit Card', 'value': 'CREDIT_CARD'},
                                            {'label': 'Loan', 'value': 'LOANS'},
                                            {'label': 'Estate Late Cheque', 'value': 'ESTATE_LATE_CHEQUE'},
                                            {'label': 'Estate Late Savings', 'value': 'ESTATE_LATE_SAVINGS'},
                                            {'label': 'Insurance', 'value': 'INSURANCE_WIMI'},
                                            {'label': 'Wills', 'value': 'WILLS'},
                                            {'label': 'Credit Life', 'value': 'CREDIT_LIFE'},
                                            {'label': 'Credit Life Mandatory', 'value': 'CREDIT_LIFE_MANDATORY'}
                                            ]);

    }
},

handleNavigate: function(component, event, helper) {
    var navigate = component.get("v.navigateFlow");
    var actionClicked = event.getParam("action");
    component.set('v.updating', true);
    switch(actionClicked){
        case "NEXT":
        case "FINISH":
            var selectedProductType = component.get("{!v.SelectedProduct}");
            if(selectedProductType == null || selectedProductType.toLowerCase() == "undefined")
            {
                component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                component.find('branchFlowFooter').set('v.message', 'Product type is required');
                component.find('branchFlowFooter').set('v.showDialog', true);
                component.set('v.updating', false);
                return null;
            }
            var initialAnswer = component.get("{!v.roaInitialAnswerId}");

            switch(selectedProductType){
                case 'PACKAGES':
                case 'CREDIT_CARD':
                case 'LOANS':
                    component.set("{!v.isNoneScoredProduct}", false);
                    break;
                case 'SAVINGS_OR_INVESTMENT':
                case 'TRANSACTIONAL_SAVINGS':
                case 'TRANSACTIONAL_CHEQUE':
                case 'ESTATE_LATE_CHEQUE':
                case 'ESTATE_LATE_SAVINGS':
                case 'INSURANCE_WIMI':
                case 'WILLS':
                case 'CREDIT_LIFE':
                case 'CREDIT_LIFE_MANDATORY':
                case 'TRANSACTIONAL_SAVINGS_VOICE':
                case 'TRANSACTIONAL_CHEQUE_VOICE':
                    component.set("{!v.isNoneScoredProduct}", true);
                    break;
            }

            var KnockoutQuestionsResponse = component.get("{!v.KnockoutQuestionResponse}")
            if(selectedProductType =='PACKAGES' ) {
                if (KnockoutQuestionsResponse == "accept")
                {
                    var promise = helper.CallCTFSPreScreen(component, helper)
                    .then(
                        $A.getCallback(function(result){
                            component.set('v.updating', false);
                            navigate(actionClicked);
                        }),
                        $A.getCallback(function(error){
                            component.set('v.updating', false);
                            component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                            component.find('branchFlowFooter').set('v.message', error.errorMessage);
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        })
                    )
                    }else{
                        component.find('branchFlowFooter').set('v.heading', 'Please note');
                        component.find('branchFlowFooter').set('v.message', 'Please accept all the attestations to continue');
                        component.find('branchFlowFooter').set('v.showDialog', true);
                        component.set('v.updating', false);
                    }
            }
            else{
                if (KnockoutQuestionsResponse == "NotSelected" && selectedProductType == 'SAVINGS_OR_INVESTMENT')
                {
                    component.find('branchFlowFooter').set('v.heading', 'Please note');
                    component.find('branchFlowFooter').set('v.message', 'Please select the attestations to continue');
                    component.find('branchFlowFooter').set('v.showDialog', true);
                    component.set('v.updating', false);
                }
                else
                {
                    component.set("v.knockoutQuestionResult",KnockoutQuestionsResponse);
                    //  component.set("{!v.knockoutQuestionResult}", KnockoutQuestionsResponse);
                    navigate(actionClicked);
                    component.set('v.updating', false);
                }
            }
            break;
        case "BACK":
        case "PAUSE":
            component.set('v.updating', false);
            navigate(event.getParam("action"));
            break;
    }
},

OnProductSelectionChange : function(component, event, helper)
{
    var selectedOptionValue = event.getParam("value");
    component.set("{!v.SelectedProduct}",selectedOptionValue);
    component.set("{!v.roaInitialAnswerId}", selectedOptionValue);
    component.set("{!v.KnockoutQuestionResponse}","NotSelected");
},

handleBranchProductSelectionEvent : function(component, event, helper) {
    var selectedAnswer = event.getParam("QuestionResponse");
    component.set("{!v.KnockoutQuestionResponse}",selectedAnswer);
},

showError: function(component, event, helper) {
    component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
    component.find('branchFlowFooter').set('v.message', '');
    component.find('branchFlowFooter').set('v.showDialog', true);
},


})