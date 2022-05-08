({  
    
    saveAppRecord :function (component, event, helper){
       var descriptionString = $A.get("$Label.c.ProductUsageDescription"); //Load the Static string from Backend
        //replace the static fields with user entered data
        
        
        var applicationid  = component.get("v.productRecordId");
        var action = component.get("c.saveApplicationDetails");
        var productPurpose = component.find("purposeOfAcc").get("v.value");
        var productPurposeText = component.find("purposeOfAcctText").get("v.value");
                
         action.setParams({
				value1: productPurpose,
				value2: component.get("v.application.Expected_number_of_credits_per_month__c"),
				value3: component.get("v.application.Rand_value_of_credits_per_month__c"),
				value4: component.get("v.application.Credits_received_via__c"),
				value5: component.get("v.application.Where_will_the_credits_be_coming_from__c"),
				value6: component.get("v.application.Number_of_staff_members__c"),
				value7: component.get("v.application.Payment_date_of_staff__c"),
				value8: component.get("v.application.Number_of_debits_per_month__c"),
				value9: component.get("v.application.Number_of_supplier_payments_per_month__c"),
				value10: component.get("v.application.Where_are_the_suppliers_located__c"),
				value11: component.get("v.application.Rand_value_of_debits_per_month__c"),
				value12: component.get("v.application.Reason_for_debit_orders__c"),
				value13: component.get("v.application.Account_Activity_Calculator__c"),
				/* W-13221 "value15" : component.get("v.application.Charge_Type__c"),
                          "value16" : component.get("v.application.Charge_Capitalization_Type__c"),
                          "value17" : component.get("v.application.Charge_Capitalization_Frequency__c"),
                          "value18" : component.get("v.application.Charge_Capitalization_Date__c"), */
				productPurposeText: component.find("purposeOfAcctText").get("v.value"),
				value14: applicationid
			});

			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var applicationDetails = response.getReturnValue();
				} else if (state === "INCOMPLETE") {
					//cmp.set('v.showSpinner', true);
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
						}
					} else {
						//   console.log("Unknown error");
					}
				}
			});
          $A.enqueueAction(action);
         },
    fetchRelatedParty: function (component) {
        var oppId;
        if(component.get("v.recordId") == undefined) {
            oppId = component.get("v.accRecId"); //when the component is on the NTB form
        } else {
            oppId = component.get("v.recordId") //when the component is on the Account form
        }
        
        var action = component.get("c.getRelatedParties");
        console.log("Opp Id " + oppId);
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var relatedParties = response.getReturnValue();
                
                component.set("v.relatedParty", relatedParties[0]);
                component.set("v.relatedParties", relatedParties);
                
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    selectPrincipal: function(component, event, helper){
        
        var inputs = component.get("v.fileShares");
        //var numberOfRelatedParty = component.get("v.relatedParties").length;
        var id = inputs.length;
        
        //console.log("Count Party " + component.get("v.relatedParties").length + " input id " + id);
        
        //var obj = {'id' : id, 'auraId': 'relatedParty' + id};
        
        //inputs.push(obj);
        //component.set("v.fileShares", inputs);
        //console.log("Result Id " + JSON.stringify(component.get("v.fileShares")));
		
        //var rowIndex = event.getSource().get("v.name");
        //var relatedPartyPopulated = component.find("relatedParties").get('v.name');
        var principalNumber = component.get("v.relatedParties").length;
        console.log("principalNumber " + JSON.stringify(component.get("v.relatedParties").length));
        
        var action = component.get("c.getRelatedParties");

		action.setParams({
			acrId: component.find("relatedParties").get("v.value")
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("Result data 114 " + JSON.stringify(data) + ' Input=  ' + JSON.stringify(inputs));
                
                if(component.get("v.relatedParties").length > inputs.length){
                    if(inputs.length == 0){
                        //var id = inputs.length+1;
                        //inputs.push(obj);
                        //component.set("v.fileShares", inputs);
                        component.set('v.showMainUser', true);
                        console.log('select value ' + JSON.stringify(inputs));
                        component.set('v.fileShares', {'data': data,'id': 1});
                    } else{
                        var exist = false;
                        for(var i = 0; i < inputs.length; i++){
                            console.log('Checking ' + inputs[i].data.Id == data.Id);
                            if(inputs[i].data.Id == data.Id){
                                exist = true;
                                break;
                            }
                        }
                        console.log('Exist State ' + exist);
                        if(!exist){
                            var obj = {'data': data,'id': inputs.length+1};
                            inputs.push(obj);
                            component.set("v.fileShares", inputs);
                        } else{
                            console.log('shareholder exist');
                        }
                        //component.set('v.fileShares', {'label': 'Enter Path', 'data': data,'id': 1});
                    }
                } else{
                    console.log('exist shareholder number');
                }

                console.log(" fileShares 130 " + JSON.stringify(component.get("v.fileShares")));
            }
            else {
                console.log("49 Failed with state: " + response.getState());
            }
        });
        $A.enqueueAction(action);
    },
    handleShowEmpcarePlan : function(component, event, helper){
        var action = component.get("c.updateProductInterest");
        console.log(component.get('v.showEmployeeCarePanel'));
        action.setParams({
            ParentId : component.get('v.recordId'),
            flag    : component.get('v.showEmployeeCarePanel')
        } );
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('inside success');
                var applicationDetails = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Product Interest  Application updated Successfully"
                });
                toastEvent.fire();
            }
            else if (state === "INCOMPLETE") { 
                //cmp.set('v.showSpinner', true);
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                        }
                    }else{
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    ///////////////// End Product Usage /////////////////
        updateApplication : function(component, event, helper) {
      // alert("charge date value :" +component.get("v.application.Charge_Capitalization_Date__c"));
       var chargedatenum = component.get("v.application.Charge_Capitalization_Date__c");
      // var sourceOfFunds = component.get("v.application.Source_of_Funds_Savings__c");
      
        // W-013221 : Anka Changes : hide charge details
      /*console.log("charge date : " +chargedatenum);
        
        if(chargedatenum < 1 || chargedatenum > 31){
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": "Please enter Date between 1 to 31"
            });
            toastEvent.fire();
        } */
            
      //  console.log('selectedSourceOfFunds: '+sourceOfFunds);
        
        var applicationRecid  = component.get("v.productRecordId");
        var action = component.get("c.updateApplicationDetails");
        
        ///// testing the params
      /*  var chequeReq = component.find("requireChequeCard").get("v.value");
        if(chequeReq == null)
          chequeReq = false;
        console.log('chequeReq'+chequeReq);*/

        var deliveryIns;
        var duplicateStatementOption = component.get("v.oppRec");
        if(duplicateStatementOption == "Y") {
            deliveryIns = component.find("deliveryInstruction").get("v.value");
        } else {
            deliveryIns = null;
        }

        //Changes Start for W-004995 by Chandra dated 12/06/2020
        var transferCreditInterestToAccount, transferAdminFeeToAccount, transferCashDepositFeeToAccount,
            transferCommitmentFeeToAccount, transferDebitInterestToAccount, transferServiceFeeToAccount,
            transferTaxLevyToAccount, transferTransactionFeeToAccount, transferIncomingUnpaidItemsToAccount;
        
        if(component.find("transferCreditInterestToAccount") == undefined){
            transferCreditInterestToAccount=null;
        }else{
            transferCreditInterestToAccount = component.find("transferCreditInterestToAccount").get("v.value");
        }
        
        if(component.find("transferAdminFeeToAccount") == undefined){
            transferAdminFeeToAccount=null;
        }else{
            transferAdminFeeToAccount = component.find("transferAdminFeeToAccount").get("v.value");
        }
        
        if(component.find("transferCashDepositFeeToAccount") == undefined){
            transferCashDepositFeeToAccount=null;
        }else{
            transferCashDepositFeeToAccount = component.find("transferCashDepositFeeToAccount").get("v.value");
        }
        
        if(component.find("transferCommitmentFeeToAccount") == undefined){
            transferCommitmentFeeToAccount=null;
        }else{
            transferCommitmentFeeToAccount = component.find("transferCommitmentFeeToAccount").get("v.value");
        }
        
        if(component.find("transferDebitInterestToAccount") == undefined){
            transferDebitInterestToAccount=null;
        }else{
            transferDebitInterestToAccount = component.find("transferDebitInterestToAccount").get("v.value");
        }
        
        if(component.find("transferServiceFeeToAccount") == undefined){
            transferServiceFeeToAccount=null;
        }else{
            transferServiceFeeToAccount = component.find("transferServiceFeeToAccount").get("v.value");
        }
        
        if(component.find("transferTaxLevyToAccount") == undefined){
            transferTaxLevyToAccount=null;
        }else{
            transferTaxLevyToAccount = component.find("transferTaxLevyToAccount").get("v.value");
        }
        
        if(component.find("transferTransactionFeeToAccount") == undefined){
            transferTransactionFeeToAccount=null;
        }else{
            transferTransactionFeeToAccount = component.find("transferTransactionFeeToAccount").get("v.value");
        }
        
        if(component.find("transferIncomingUnpaidItemsToAccount") == undefined){
            transferIncomingUnpaidItemsToAccount=null;
        }else{
            transferIncomingUnpaidItemsToAccount = component.find("transferIncomingUnpaidItemsToAccount").get("v.value");
        }
        //Changes end for W-004995 by Chandra dated 12/06/2020
        
        
        //alert('deleivery'+deliveryIns);
        /*
        Boolean requireChequeCard,Boolean requireDepositBook, String deliveryMethod, String statementFrequency, 
                                                  String statementDayOfMonth, String accountStream, String deliveryInstruction,String accrualDayOfMonth,
                                                  String capitilisationDayOfWeek, String capitilisationDayOfMonth,String accrualDayOfWeek,Id applicationId
        deliveryInstruction
        */
        
         action.setParams({ 
                             //"requireChequeCard" : chequeReq ,
                             //"requireDepositBook" : component.find("requireDepositBook").get("v.value"),
                             "sourceOfFunds" : component.find("sourceOfFunds").get("v.value"), //sourceOfFunds ,
                             
            //Changes Start for W-004995 by Chandra dated 12/06/2020
            "redirectFees" : component.find("redirectFees").get("v.value"),
            "transferCreditInterestToAccount" : transferCreditInterestToAccount,
            "transferAdminFeeToAccount" : transferAdminFeeToAccount,
            "transferCashDepositFeeToAccount" : transferCashDepositFeeToAccount,
            "transferCommitmentFeeToAccount" : transferCommitmentFeeToAccount,
            "transferDebitInterestToAccount" : transferDebitInterestToAccount,
            "transferServiceFeeToAccount" : transferServiceFeeToAccount,
            "transferTaxLevyToAccount" : transferTaxLevyToAccount,
            "transferTransactionFeeToAccount" : transferTransactionFeeToAccount,
            "transferIncomingUnpaidItemsToAccount" : transferIncomingUnpaidItemsToAccount,
            //Changes end for W-004995 by Chandra dated 12/06/2020
            
                             "deliveryMethod" : component.find("deliveryMethod").get("v.value"),
                             "statementFrequency" : component.find("statementFrequency").get("v.value"),
							"statementDayOfMonth" :component.find("statementDayOfMonth").get("v.value"),
							"accountStream" : component.find("accountStream").get("v.value"),
							"deliveryInstruction" : deliveryIns,
                            //W-013221 : Anka Changes
							/*"accrualDayOfMonth" : component.find("accrualDayOfMonth").get("v.value"),
							"capitilisationDayOfWeek" : component.find("capitilisationDayOfWeek").get("v.value"),
							"capitilisationDayOfMonth" : component.find("capitilisationDayOfMonth").get("v.value"),
							"accrualDayOfWeek" : component.find("accrualDayOfWeek").get("v.value"),*/
            
            //Changes for W-004989 by Gopi dated 16/06/2020
             //W-013221 : Anka Changes
            /*"chargeType": component.find("chargeType").get("v.value"),
            "chargeCapitalType" : component.find("chargeCapitalType").get("v.value"),
            "chargeFreq" : component.find("chargeFreq").get("v.value"),
            "chargeCapDate" :component.find("chargeCapDate").get("v.value"),*/
                            "applicationId" : applicationRecid});  
        
         action.setCallback(this,function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                var applicationDetails = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application updated Successfully"
                });
                toastEvent.fire();
                 
             }
             else if (state === "INCOMPLETE") {
                 //cmp.set('v.showSpinner', true);
             }
                 else if (state === "ERROR") {
                     var errors = response.getError();
                     if (errors) {
                         if (errors[0] && errors[0].message) {
                         console.log("Error message: " +errors[0].message);
                         }
                     }else{
                      console.log("Unknown error");
                     }
                 }
             
         });
          $A.enqueueAction(action);
     },
    
        //update savings details
        updateSavings : function(component, event, helper) {
      
        var applicationRecid  = component.get("v.productRecordId");
        var action = component.get("c.updateSavingsAccountGeneral");
            
            action.setParams({ 
                sourceOfFunds: component.find("SourceofFundssavings") != undefined ? component.find("SourceofFundssavings").get("v.value") : null,
                MeetingHeldAt: component.find("MeetingheldAt") != undefined ? component.find("MeetingheldAt").get("v.value") : null,
                MeetingOf: component.find("MeetingOf") != undefined ? component.find("MeetingOf").get("v.value") : null,
                MeetingDate: component.find("MeetingDate") != undefined ? component.find("MeetingDate").get("v.value") : null,
                Extractsigneddate: component.find("ExtractsignedDate") != undefined ? component.find("ExtractsignedDate").get("v.value") : null,
                Totalnumofaccountstobeopened: component.find("Totalnmbrofaccstoopen") != undefined ? component.find("Totalnmbrofaccstoopen").get("v.value") : null,
                Requirednumberofsignatoriestoopencloseaccounts: null, //component.find("numberofsignsaccts").get("v.value"),
                Requirednumofsignatoriestogiveinstructions: null, //component.find("numberofsignstogiveinstructions").get("v.value"),
                CommentsonexplanationgivenforSourceoffunds: component.find("cmmntsgivenforsourcefunds").get("v.value"),
                applicationId : applicationRecid});  
                
         action.setCallback(this,function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                var applicationDetails = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application updated Successfully"
                });
                toastEvent.fire();
                 
             }
             else if (state === "INCOMPLETE") {
                 //cmp.set('v.showSpinner', true);
             }
                 else if (state === "ERROR") {
                     var errors = response.getError();
                     if (errors) {
                         if (errors[0] && errors[0].message) {
                         console.log("Error message: " +errors[0].message);
                         }
                     }else{
                      console.log("Unknown error");
                     }
                 }
             
         });
          $A.enqueueAction(action);
     },

    
    getsavingsaccdetails : function(component, event, helper) {
        
        var obj = new Object();
        obj.Id=component.get("v.productRecordId");
        obj.MeetingOf = component.find("MeetingOf") != undefined ? component.find("MeetingOf").get("v.value") : null;
		obj.MeetingHeldAt = component.find("MeetingheldAt") != undefined ? component.find("MeetingheldAt").get("v.value") : null;
		obj.MeetingDate = component.find("MeetingDate") != undefined ? component.find("MeetingDate").get("v.value") : null;
		obj.Extractsigneddate = component.find("ExtractsignedDate") != undefined ? component.find("ExtractsignedDate").get("v.value") : null;
		obj.Totalnumofaccountstobeopened = component.find("Totalnmbrofaccstoopen") != undefined ? component.find("Totalnmbrofaccstoopen").get("v.value") : null;
		//obj.Requirednumberofsignatoriestoopencloseaccounts = component.find("numberofsignsaccts").get("v.value");
        //obj.Requirednumofsignatoriestogiveinstructions = component.find("numberofsignstogiveinstructions").get("v.value");
        obj.SourceofFundssavings = component.find("SourceofFundssavings") != undefined ? component.find("SourceofFundssavings").get("v.value") : null;
		console.log("obj.SourceofFundssavings " + obj.SourceofFundssavings);
		obj.CommentsonexplanationgivenforSourceoffunds = component.find("cmmntsgivenforsourcefunds").get("v.value");
		obj.CustomerRegion = component.find("customerRegion") != undefined ? component.find("customerRegion").get("v.value") : '';// added by Manish for W-010115
        obj.IsThereAnyTPFTP = component.find("isThereAnyTPFTP") != undefined ? component.find("isThereAnyTPFTP").get("v.value") : '';//added by Manish for W-010115
       
        
       var applctnInfo = JSON.stringify(obj);
        console.log('applctnInfo >> ' + applctnInfo);
                              var action = component.get("c.updateSavingsAccountGeneral");
        action.setParams({"oppid": component.get("v.recordId"),
                          "applicationRecord" : applctnInfo
                         });
      // set a callBack                        
        action.setCallback(this, function(response) {                              
            var state = response.getState();                    
            if (state === "SUCCESS") {               
                 if(response.getReturnValue()=='SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "The record has been updated successfully."
                    });
                    toastEvent.fire();
                } else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": "Something went wrong Please contact Administrator."
                    });
                    toastEvent.fire();
                }
            }
                              });
        // enqueue the Action
        $A.enqueueAction(action);
               },

      updateROAInformation : function(component, event, helper) {
        var applicationRecid  = component.get("v.productRecordId");
        var replaceProductValue = component.get("v.isReplacingProductBol");
        var adviseGiven = component.get("v.isAdviseGivenBol");
        var delegatesMeetingDate = null;
        var delegatesAtMeeting = null;
        var netAssetValue = null;
        var currentSituation = null;
        var currentProductXP = null;
        var needsOrObjectives = null;
        var typicalmacroOrSectorial = null;
        var othermacroOrSectorial = null;
        var generalNotes = null;
        var priorProduct = null;
        var productConsidered = null;
        var productRecommended = null;
        var reasonNotRecommended = null;
        var presentationName = null;
        var presentationGroupName = null;
        var presentationDate = null;
        var presentationLocation = null;
        var presentationFolioNo = null;
        var firstName = null;
        var surname = null;
        var designation = null;
        var dateVal = null;
        var isReplacingProduct = null;
        if(replaceProductValue == 'Y' || adviseGiven == "Y") {
            delegatesMeetingDate = component.find("delegatesMeetingDate") != undefined ?  component.find("delegatesMeetingDate").get("v.value") : null;
            delegatesAtMeeting = component.find("delegatesAtMeeting") != undefined ? component.find("delegatesAtMeeting").get("v.value") : null;
            netAssetValue = component.find("netAssetValue") != undefined ? component.find("netAssetValue").get("v.value") : 0.0;
            currentSituation = component.find("currentSituation") != undefined ? component.find("currentSituation").get("v.value")  : null;
            currentProductXP = component.find("currentProductXP") != undefined ? component.find("currentProductXP").get("v.value") : null;
            needsOrObjectives = component.find("needsOrObjectives") != undefined ? component.find("needsOrObjectives").get("v.value") : null;
            typicalmacroOrSectorial = component.find("typicalmacroOrSectorial") != undefined ? component.find("typicalmacroOrSectorial").get("v.value") : null;
            othermacroOrSectorial = component.find("othermacroOrSectorial") != undefined ? component.find("othermacroOrSectorial").get("v.value") : null;
            generalNotes = component.get("v.generalNotes");
            priorProduct = component.find("priorProduct") != undefined ? component.find("priorProduct").get("v.value") : null;
            productConsidered =  component.find("productConsidered") != undefined ? component.find("productConsidered").get("v.value") : null;
            productRecommended = component.find("productRecommended") != undefined ? component.find("productRecommended").get("v.value") : null;
            reasonNotRecommended = component.find("reasonNotRecommended") != undefined ? component.find("reasonNotRecommended").get("v.value") : null;
            presentationName = component.get("v.presentationName");
            presentationGroupName = component.get("v.presentationGrpName");
            presentationDate = component.get("v.presentationDate") != undefined ? component.get("v.presentationDate") : null;
            presentationLocation = component.get("v.presentationLocation");
            presentationFolioNo = component.get("v.presentaitonFolioNo");
            firstName = component.find("firstName") != undefined ? component.find("firstName").get("v.value") : null;
            surname = component.find("surname") != undefined ? component.find("surname").get("v.value") : null;
            designation = component.find("designation") != undefined ? component.find("designation").get("v.value") : null;
            dateVal = component.find("dateVal") != undefined ? component.find("dateVal").get("v.value") : null;
        }
        if (adviseGiven == "N") {
            isReplacingProduct = component.find("productReplacement") != undefined ? component.find("productReplacement").get("v.value") : null;
        }

        var action = component.get("c.updateApplicationROADetails");
        action.setParams({
            "delegatesMeetingDate" : delegatesMeetingDate,
            "delegatesAtMeeting" : delegatesAtMeeting,
            "netAssetValue" : netAssetValue,
            "currentSituation" : currentSituation,
            "currentProductXP" : currentProductXP,
            "needsOrObjectives" : needsOrObjectives,
            "typicalmacroOrSectorial" : typicalmacroOrSectorial,
            "othermacroOrSectorial" : othermacroOrSectorial,
            "generalNotes" : generalNotes,
            "priorProduct" : priorProduct,
            "productConsidered" : productConsidered,
            "productRecommended" : productRecommended,
            "reasonNotRecommended" : reasonNotRecommended,
            "presentationName" : presentationName,
            "presentationGroupName" : presentationGroupName,
            "presentationDate" : presentationDate,
            "presentationLocation" : presentationLocation,
            "presentationFolioNo" : presentationFolioNo,
            "firstName" : firstName,
            "surname" : surname,
            "designation" : designation,
            "dateVal" : dateVal,
            "adviseGiven" : component.get("v.adviseGiven"),
            "underSupervision" : component.get("v.underSupervision"),
            "isReplacingProduct" : isReplacingProduct,
            "applicationId" : applicationRecid});
			action.setCallback(this,function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                var applicationDetails = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "ROA Application updated Successfully"
                });
                toastEvent.fire();
             }
             else if (state === "INCOMPLETE") {
                 //cmp.set('v.showSpinner', true);
             }
                 else if (state === "ERROR") {
                     var errors = response.getError();
                     if (errors) {
                         if (errors[0] && errors[0].message) {
                         console.log("Error message: " +errors[0].message);
                         }
                     }else{
                      console.log("Unknown error");
                     }
                 }
         });
          $A.enqueueAction(action);
      },

    updateNotifyMe : function(component, event, helper) {

       component.set('v.showSpinner', true); 
       console.log("updateNotifyMe  " + component.get("v.productRecordId"));
        var action = component.get("c.updateNotifyMe");
        var oppId  = component.get("v.recordId");
        console.log("Record Id : " + oppId);
       
        
        var Name				= component.get("v.Name");	
        var Surname				= component.get("v.Surname");
        var ActiveEmail			= component.get("v.ActiveEmail");
        var PreferredContact	= component.find("PreferredContact").get("v.value");// W-13694:component.get("v.PreferredContact");
        var PreferredLanguage	= component.find("PreferredLanguage").get("v.value");
        var AllTransactionType	= component.find("AllTransactionType").get("v.PreferredLanguage");
        var Payment				= component.find("Payment").get("v.value");
        var Withdrawal			= component.find("Withdrawal").get("v.value");
        var Deposit				= component.find("Deposit").get("v.value");
        var ReturnedTransactions= component.find("ReturnedTransactions").get("v.value");
        var ScheduledTransaction= component.find("ScheduledTransaction").get("v.value");//15225
        var NotificationTime	= component.find("NotificationTime").get("v.value");
        var MinimumAmount		= component.find("MinimumAmount").get("v.value");
        var MinimumAmount1		= component.find("MinimumAmount1").get("v.value");
        var BalanceUpdate		= component.find("BalanceUpdate").get("v.value");
        var SpecificDay			= component.find("SpecificDay").get("v.value");
        var Purchases			= component.find("Purchases").get("v.value");//15225
        var oppId= oppId;
            
        action.setParams({
            "Name" : Name,	
            "Surname" : Surname,
            "ActiveEmail" : ActiveEmail,
            "PreferredContact" : PreferredContact,
            "PreferredLanguage" : PreferredLanguage,
            "AllTransactionType" : AllTransactionType,
            "Payment" : Payment,
            "Withdrawal" : Withdrawal,
            "Deposit" : Deposit,
            "ReturnedTransactions" : ReturnedTransactions,
            "ScheduledTransaction" : ScheduledTransaction,
            "NotificationTime" : NotificationTime,
            "MinimumAmount" : MinimumAmount,
            "MinimumAmount1" : MinimumAmount1,
            "BalanceUpdate" : BalanceUpdate,
            "SpecificDay" : SpecificDay,
            "Purchases" : Purchases,//15225
            "oppId" : oppId
          });

          action.setCallback(this,function(response) {
              component.set('v.showSpinner', false);
              var state = response.getState();
              if (state === "SUCCESS") {
                  
                  var response = response.getReturnValue();
                  //var errVal = response.match(/\d+/g);
                  //console.log("err value " + errVal);
                  //Defect : W-007700 : 2020-11-16:Anka Ganta: updated if condition
                  if(response == 'Updated the application record' || response == 'Inserted the application record' || response.includes('Updated successfully')){
                      var toastEvent = $A.get("e.force:showToast");
                      toastEvent.setParams({
                          "title": "Success!",
                          "type":"success",
                          "message": "Application updated Successfully"
                      });
                      toastEvent.fire();
                  }else{
                      var toastEvent = $A.get("e.force:showToast");
                      toastEvent.setParams({
                          "type": "error",
                          "title": "Error!",
                          "message": response
                      });
                      toastEvent.fire();
                      
                  }
                 
                 
             }
             else if (state === "INCOMPLETE") {
                 console.log("Error message: " +errors[0].message);
             }
                 else if (state === "ERROR") {
                     var errors = response.getError();
                     if (errors) {
                         if (errors[0] && errors[0].message) {
                             console.log("Error message: " +errors[0].message);
                         }
                     }else{
                         console.log("Unknown error");
                     }
                 }
              
          });
          
          $A.enqueueAction(action);
      },
    
    updateInternetBanking : function(component, event, helper) {
        console.log("updateInternetBanking  " + component.get("v.recordId"));
        var action = component.get("c.updateInternetBanking");
        var oppID  = component.get("v.recordId");
        
        console.log("Notifyme " +  component.find("Notifyme").get("v.value") + " CombiRecordNumber " + component.find("CombiRecordNumber").get("v.value"));
        
        action.setParams({
            "AccountToBeDebitedMonthlyWithTheCost" : component.find("AccountToBeDebitedMonthlyWithTheCost").get("v.value"),
            "CombiRecordNumber" : component.find("CombiRecordNumber").get("v.value"),
            "NumberOfAuthorisations" : component.find("NumberOfAuthorisations").get("v.value"),
            "NumberOfMainUsers" : component.find("NumberOfMainUsers").get("v.value"),
            "FeeStructureCode" : component.find("FeeStructureCode").get("v.value"),
            "AbsaOnlineForBusiness" : component.find("AbsaOnlineForBusiness").get("v.value"),
            "CellPhoneBanking" : component.find("CellPhoneBanking").get("v.value"),
            "TelephoneBanking" : component.find("TelephoneBanking").get("v.value"),
            "Notifyme" : component.find("Notifyme").get("v.value"),
            "FundsTransfer" : component.find("FundsTransfer").get("v.value"),
            "BillPayments" : component.find("BillPayments").get("v.value"),
            "OwnDefinedPayments" : component.find("OwnDefinedPayments").get("v.value"),
            "FutureDatedPayments" : component.find("FutureDatedPayments").get("v.value"),
            "StopOrderPayments" : component.find("StopOrderPayments").get("v.value"),
            "oppID" : oppID
          });
          
          action.setCallback(this,function(response) {
              var state = response.getState();
              if (state === "SUCCESS") {
                  console.log("Resoponse " + JSON.stringify(response.getReturnValue()));
                  if(response.getReturnValue() === 'Updated the application record' || response.getReturnValue() === 'Inserted the application record'){
                      var toastEvent = $A.get("e.force:showToast");
                      toastEvent.setParams({
                          "title": "Success!",
                          "type":"success",
                          "message": "Application updated Successfully"
                      });
                      toastEvent.fire();
                  }
                 
             }
             else if (state === "INCOMPLETE") {
                 console.log("Error message: " +errors[0].message);
             }
                 else if (state === "ERROR") {
                     var errors = response.getError();
                     if (errors) {
                         if (errors[0] && errors[0].message) {
                             console.log("Error message: " +errors[0].message);
                         }
                     }else{
                         console.log("Unknown error");
                     }
                 }
          });
          
          $A.enqueueAction(action);
      },

      /// @Haritha    
      //  Sending welcome package to customer
      //  
       sendwelcmepckg : function(component, event, helper) {
      //  this.showSpinner(component);
		component.set('v.showSpinner', true);
                        //To Call GenreateCQAcctNumber Components
                this.selectOpportunity(component, event, helper);
             // W-010665 - Anka Ganta
           /*
            var action = component.get("c.sendWelcomePackage");

        action.setParams({oppid: component.get("v.recordId")
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var returnValue =response.getReturnValue();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Congratulations! This Opportunity is now complete."
                });
                component.set('v.isHide', true); 
                component.set('v.showSpinner', false);

                toastEvent.fire(); 

            }
                
       else{
		 var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": "Something went wrong."
                    });
                    toastEvent.fire();
       }
        });

		
         $A.enqueueAction(action); */
            
    },
 //Function to show spinner when loading
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Function to hide spinner after loading
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    /////////// helpers for Product usage /////////////
    loadProductData : function(component, event, helper){
		component.set('v.showSpinner', false);
         var action = component.get("c.getApplicationDetails");
         action.setParams({ oppId : component.get("v.recordId")});
         action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationDetails = response.getReturnValue();
                if(applicationDetails != null){
                    if (component.get("v.roaLoaded") != true) {
						component.set("v.productRecordId", applicationDetails.Id);
						component.set("v.underSupervision", applicationDetails.Client_Under_Supervision__c);
						component.set("v.adviseGiven", applicationDetails.Advice_Given__c);
						component.set("v.replacingProduct", applicationDetails.Replacing_an_Existing_Product__c);
						component.set("v.isAdviseGivenBol", applicationDetails.Advice_Given__c);
						component.set("v.isReplacingProductBol", applicationDetails.Replacing_an_Existing_Product__c);
						component.set("v.generalNotes", applicationDetails.General_Notes__c);
						var confirmationOFRecCompletion =
							applicationDetails.Confirmation_of_Record_Completion__c != "" &&
							applicationDetails.Confirmation_of_Record_Completion__c != undefined
								? JSON.parse(applicationDetails.Confirmation_of_Record_Completion__c)
								: null;
						if (applicationDetails.ROA_SectionC_Table_Value__c != undefined) {
							this.setSectionCData(component, event, helper);
							component.set("v.sectionCTabledata", JSON.parse(applicationDetails.ROA_SectionC_Table_Value__c));
						} else {
							this.setSectionCData(component, event, helper);
						}
						if (applicationDetails.ROA_SectionD_Table_Value__c != undefined) {
							this.setSectionDTableData(component, event, helper);
							component.set("v.sectionDTabledata", JSON.parse(applicationDetails.ROA_SectionD_Table_Value__c));
						} else {
							this.setSectionDTableData(component, event, helper);
						}
						component.set("v.confirmationOFRecCompletion", confirmationOFRecCompletion);
						component.set("v.application", response.getReturnValue());
						component.set("v.roaLoaded", true);
					}
                console.log('Application Id loaded'+applicationDetails.Id);
                }
            }
            else if (state === "INCOMPLETE") {
                //cmp.set('v.showSpinner', true);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                     console.log("Error message: " +errors[0].message);
                    }
                }else{
                 console.log("Unknown error in Load Product");
                }
            }
         
         });
          $A.enqueueAction(action);
	},
    

   
        getUserDetails : function(component, event, helper) {
         var action = component.get("c.getCurrentUserDetail");                   
      // set a callBack                        
        action.setCallback(this, function(response) {                              
            var state = response.getState();                    
            if (state === "SUCCESS") {               
                var response = response.getReturnValue();
                console.log('response----'+response[0]);
                if(response[0].Id != undefined){
                    component.set("v.currentUserId", response[0].Id);
                }
                if(response[0].AB_Number__c != undefined){
                    component.set("v.abNumber", response[0].AB_Number__c);
                }
                if(response[0].FirstName != undefined){
                   component.set("v.userFirstName", response[0].FirstName); 
                }
                 if(response[0].LastName != undefined){
                    component.set("v.usersurname", response[0].LastName);
                }
                if(response[0].MobilePhone != undefined){
                    component.set("v.userPhone", response[0].MobilePhone);
                }
                 if(response[0].Email != undefined){
                    component.set("v.userEmail", response[0].Email);
                }
                
                    if(response[0].SiteCode__c != undefined){
                    component.set("v.sitecode", response[0].SiteCode__c); //added by diksha
                }

            }                
                             });                          
        // enqueue the Action                         
        $A.enqueueAction(action);
    },
    
    
        //Function to show toast for Errors/Warning/Success
    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },
   //helper method to show acc number 
        selectOpportunity: function(component, event, helper) {
        component.set('v.showSpinner', true);
        var selScheme = component.get("v.selectedScheme"); 
        console.log("selScheme+++"+selScheme);    
        var action = component.get("c.getOppData");
     
        action.setParams({oppId:component.get("v.recordId"),     //accountRecId
                           PriceSchemeCode:component.get("v.selectedScheme")
                          });
             action.setCallback(this, function(response) {
            var state = response.getState();
                 if (state === "SUCCESS") {
						var respObj = response.getReturnValue();
						console.log("respObj" + respObj);
						console.log("respObj---->" + JSON.stringify(respObj));
						var respObjAfter = JSON.stringify(respObj);
						var accNumber = respObj[0].AccountNumber;
						component.set("v.policynumber", accNumber);
						console.log("AccNumber " + accNumber);

						component.set("v.respData", respObj);
						component.set("v.columns", [
							{ label: "Client", fieldName: "Client", type: "text" },
							{ label: "Account", fieldName: "Account", type: "text" },
							{ label: "Account Number", fieldName: "AccountNumber", type: "text" }
						]);
						console.log("within the service call");
						component.set("v.showSpinner", false);
					}else if(state === "ERROR"){
                     var errors = action.getError();
                     if (errors) {
                         if (errors[0] && errors[0].message) {
                             var toast = this.getToast("Error", errors[0].message, "error");
                             
                             toast.fire();
                             
                             component.set('v.showSpinner', false);
                         }
                     }
                     
                     
                 }
                 else{
                     var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                         "type": "error",
                         "title": "Error",
                         "message": "Something went wrong Please contact Administrator."
                     });
                     toastEvent.fire();
                 }
             });
        $A.enqueueAction(action);
    },
    getAccountDetails: function(component, event, accId) {
        //alert(accId);
        var action = component.get("c.fetchAccountDetails");
        action.setParams({ accountId : accId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accountDetail = response.getReturnValue();
                component.set("v.accountDetail",response.getReturnValue());
                component.find("idNumberExAcc").set("v.value",accountDetail.ID_Number__pc);
                component.find("phoneExAcc").set("v.value",accountDetail.Phone);
                component.find("emailExAcc").set("v.value",accountDetail.PersonEmail);
                console.log("From server: " + JSON.stringify(response.getReturnValue()));
                component.find("firstNameExAcc").set("v.value",accountDetail.FirstName);
                component.find("LastNameExAcc").set("v.value",accountDetail.LastName);
                
            }
            else if (state === "INCOMPLETE") {
                
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
     showSelectedProduct : function(component, event, helper) {
        
         var action = component.get("c.showopplineitem");
         var recordId = component.get("v.recordId");
         action.setParams({oppid: recordId });
        //action.setParams({oppid: component.get("v.recordId"),
                        //  productid: product.Id
                        // });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValueofProduct =response.getReturnValue();
                console.log('retrunValue'+JSON.stringify(returnValueofProduct));
                console.log('retrunValueName'+JSON.stringify(returnValueofProduct.Name));
                component.set("v.SelectedProduct",returnValueofProduct.Name);
                component.set('v.selectedSchemeCode',returnValueofProduct.Fee_Structure_code__c);
                
                var productNameArray = ['Saving Call Account','LIQUIDITY PLUS','Islamic Savings','Islamic Target Save','ABSA WEALTH FIXED DEPOSITS','DYNAMIC FIXED DEPOSIT','Islamic Dynamic Deposit','Notice Plus','NOTICE SELECT','ABSA Investment Tracker','Absa Wealth Islamic Cheque','Call Account','Section 86 (4)','Islamic Cheque Call','BIZSTART'];
                if(productNameArray.includes(returnValueofProduct.Product2.Name)){
                    component.set("v.isProductAvail",true);
                }
                
            }
                
        });
      
        $A.enqueueAction(action);
    },
     //W-004843 : Anka Ganta : 2020-07-13
    showPricingSchemes : function(component, event, helper) {
        
        var action = component.get("c.getPricingSchemesByProduct");
        action.setParams({
            oppId: component.get("v.recordId")
        });
       action.setCallback(this, function(response) {
           var state = response.getState();
           if (state === "SUCCESS"){
            console.log("test1++" + response.getReturnValue());
            component.set('v.PricingSchemes',response.getReturnValue());
           }else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
      
        $A.enqueueAction(action);
    },

    productPriceScheme: function(component, event, helper){
        
        var selectedSchemeCode 	= event.getSource().get("v.value");
        var oppId 				= component.get("v.recordId");
        component.set("v.selectedScheme", selectedSchemeCode);
        var action = component.get("c.updateProductPriceScheme");
        
        
            action.setParams({'oppId': oppId, 'selectedSchemeCode': selectedSchemeCode});
            
            action.setCallback(this, function (response) {
        
                let title = '';
                let type = '';
                let message = '';
                
                var responseMsg = response.getReturnValue();
                var state		= response.getState();
                
                if(state === 'SUCCESS'){
                    const value = response.getReturnValue();
                    title = 'Success';
                    type = 'success';
                    message = responseMsg;
                    
                } else {
                    title = 'Error';
                    type = 'error';
                    
                    const errors = response.getError();
                    const error = responseMsg;
                    message = responseMsg;
                }
                
                const toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": title,
                    "type": type,
                    "message": message
                });
                toastEvent.fire();
                
                 component.set("v.hideSpinner", true);
            });
            
            $A.enqueueAction(action);           
        
	},
     // W-8562 - Closed opportunity validation
    closedOpportunityValidation : function(component, event, helper) {
        
       var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": "You are not allowed to update application record as it is associated with closed opportunity"
            });
       toastEvent.fire();
    },    
    setSectionCData: function (component, event, helper) {
		component.set("v.sectionCColumns", [
			{
				label: "Financial Products Considered to achieve the financial Objectives stated above",
				fieldName: "achiveFfinancialObjectives",
				type: "text",
				editable: true
			},
			{
				label: "Products recommended to client or entity (Mark recommended or not recommended)",
				fieldName: "reommendedNotRecommended",
				type: "text",
				editable: true
			},
			{ label: "Reason recommnended or not recommended", fieldName: "reason", type: "text", editable: true }
		]);
		var sectionCTabledata = [
			{ id: 1, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" },
			{ id: 2, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" },
			{ id: 3, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" },
			{ id: 4, achiveFfinancialObjectives: "", reommendedNotRecommended: "", reason: "" }
		];
		component.set("v.sectionCTabledata", sectionCTabledata);
	},
	setSectionDTableData: function (component, event, helper) {
		component.set("v.sectionDColumns", [
			{
				label: "Comparative item",
				fieldName: "comparativeItem",
				type: "text"
			},
			{
				label: "Existing Product",
				fieldName: "existingProduct",
				type: "text",
				editable: true
			},
			{ label: "Newly Proposed Product", fieldName: "newlyProposedPorduct", type: "text", editable: true }
		]);
		var feesAndCharges = "Fees and Charges : Fees and charges in respect of the replacement product compared to those in respect of the terminated product";
		feesAndCharges =
			feesAndCharges +
			"Any incentive, remuneration, consideration, commission, fee or brokerages received, directly or indirectly, by the provider on the terminated product";
		feesAndCharges =
			feesAndCharges +
			"and any incentive, remuneration, consideration, commission, fee or brokerages payable, directly or indirectly, by the provider on the replacement product";
		feesAndCharges = feesAndCharges + "where the provider rendered financial services on both the terminated and replacement product";
		var sectionDTabledata = [
			{ id: 1, comparativeItem: feesAndCharges, existingProduct: "", newlyProposedPorduct: "" },
			{
				id: 2,
				comparativeItem:
					"Consequences of replacement: Special terms and conditions, penalty fees, restriction of circumstances in which benefits will not be provided, which may be applicable to the replacement product compared to those applicable to the terminated product",
				existingProduct: "",
				newlyProposedPorduct: ""
			},
			{ id: 3, comparativeItem: "Tax Implications", existingProduct: "", newlyProposedPorduct: "" },
			{ id: 4, comparativeItem: "Investment Risk Comparison", existingProduct: "", newlyProposedPorduct: "" },
			{ id: 5, comparativeItem: "Liquidity Comparison", existingProduct: "", newlyProposedPorduct: "" },
			{
				id: 6,
				comparativeItem:
					"Vested rights, minimum guranteed benefits or other gurantees/benifits, as well as investment perfomance gurantees that might differ",
				existingProduct: "",
				newlyProposedPorduct: ""
			},
			{
				id: 7,
				comparativeItem:
					"Did you establish whether the existing/terminated product could be amended to provide similar benefits to the replacement policy ?",
				existingProduct: "",
				newlyProposedPorduct: ""
			},
			{
				id: 8,
				comparativeItem:
					"If such amendment is/was possible, why do you regard it as the appropriate that the terminated product be replaced by the replacement product ?",
				existingProduct: "",
				newlyProposedPorduct: ""
			},
			{
				id: 9,
				comparativeItem: "Cooling-off rights offered and if so, the procedure to exercise such rights",
				existingProduct: "",
				newlyProposedPorduct: ""
			}
		];
		component.set("v.sectionDTabledata", sectionDTabledata);
	},
	fetchQuestionnaireRecordlist: function (component, event, helper) {
		var action = component.get("c.getQuestionnaireRecordlist");
		action.setParams({
			oppId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rec = response.getReturnValue();
				var item;
				for (var i = 0; i < rec.length; i++) {
					item = rec[i];
					console.log("question" + item.Question__c);
					if (item.Question__c == "Meeting date") {
						component.set("v.meetingDateROA", item.Answer__c);
					}
					if (item.Question__c == "Advisor or Intermediary") {
						component.set("v.advisor", item.Answer__c);
					}
					if (item.Question__c == "FAIS Classification") {
						component.set("v.faisClassification", item.Answer__c);
					}
					if (item.Question__c == "Role") {
						component.set("v.role", item.Answer__c);
					}
					if (item.Question__c == "Delegates at the Meeting") {
						component.set("v.delegatesAtMeeting", item.Answer__c);
					}
					if (item.Question__c == "Net Asset Value of Entity") {
						component.set("v.netAssetValue", item.Answer__c);
					}
					if (item.Question__c == "Current Financial Situation") {
						component.set("v.currentSituationROA", item.Answer__c);
					}
					if (item.Question__c == "Current Financial Product Experience change/Investment Risk Profile") {
						component.set("v.financialProdExp", item.Answer__c);
					}
					if (item.Question__c == "Needs or Objectives") {
						component.set("v.needsOrObjectives", item.Answer__c);
					}
					if (item.Question__c == "Introductory Meeting") {
						component.set("v.introductoryMeeting", item.Answer__c);
					}
					if (item.Question__c == "Specific product requested") {
						component.set("v.prodRequested", item.Answer__c);
					}
					if (item.Question__c == "Follow-up Meeting") {
						component.set("v.followUpMeeting", item.Answer__c);
					}
					if (item.Question__c == "Other") {
						component.set("v.other", item.Answer__c);
					}
					if (item.Question__c == "Presentation") {
						component.set("v.presentation", item.Answer__c);
					}
					if (item.Question__c == "Name of Presentation") {
						component.set("v.presentationName", item.Answer__c);
					}
					if (item.Question__c == "Details of Group Name") {
						component.set("v.presentationGrpName", item.Answer__c);
					}
					if (item.Question__c == "Date") {
						component.set("v.presentationDate", item.Answer__c);
					}
					if (item.Question__c == "Location") {
						component.set("v.presentationLocation", item.Answer__c);
					}
					if (item.Question__c == "Folio Number of Presentation") {
						component.set("v.presentaitonFolioNo", item.Answer__c);
					}
					if (item.Question__c == "Was the client advised of the risk involved?") {
						component.set("v.clientAdvicedOfRisk", item.Answer__c);
					}
					if (item.Question__c == "The financial position was considered by completing a Financial Needs Analysis") {
						component.set("v.financialQuestion1", item.Answer__c == "true" ? true : false);
					}
					if (item.Question__c == "The client opted not to provide the full facts in relation to his/her financial situation") {
						component.set("v.financialQuestion2", item.Answer__c == "true" ? true : false);
					}
					if (item.Question__c == "Makro (Sectoral ) – Industry") {
						component.set("v.sectoralIndustry", item.Answer__c);
					}
					if (item.Question__c == "Makro (Sectoral) – Typical firm or Business Profile") {
						component.set("v.sectoralBusinessProfile", item.Answer__c);
					}
					if (item.Question__c == "Makro (Sectoral ) – Other") {
						component.set("v.sectoralOther", item.Answer__c);
					}
					if (item.Question__c == "Did you select a product prior to receiving the information you provided?") {
						component.set("v.productSelectedPrior", item.Answer__c);
					}
					if (item.Question__c == "will address the needs partially or fully replacing an existing financial product") {
						component.set("v.partiallyOrFullyReplace", item.Answer__c);
					}
					if (item.Question__c == "your needs have an investment or investment component?") {
						component.set("v.haveInvestementorInvestedComponent", item.Answer__c);
					}
					if (item.Question__c == "valueOfInvestmentDetermined") {
						component.set("v.valueOfInvestmentDetermined", item.Answer__c);
					}
					if (item.Question__c == "feesToLevied") {
						component.set("v.feesToLevied", item.Answer__c);
					}
					if (item.Question__c == "indicativeOfFuturePerformances") {
						component.set("v.indicativeOfFuturePerformances", item.Answer__c);
					}
					if (item.Question__c == "monetaryObligations") {
						component.set("v.monetaryObligations", item.Answer__c);
					}
					if (item.Question__c == "anyIncentives") {
						component.set("v.anyIncentives", item.Answer__c);
					}
					if (item.Question__c == "penalties") {
						component.set("v.penalties", item.Answer__c);
					}
					if (item.Question__c == "specialTermsConditions") {
						component.set("v.specialTermsConditions", item.Answer__c);
					}
					if (item.Question__c == "productReadilyAccessible") {
						component.set("v.productReadilyAccessible", item.Answer__c);
					}
					if (item.Question__c == "collingOffRights") {
						component.set("v.CollingOffRights", item.Answer__c);
					}
					if (item.Question__c == "riskswithProducts") {
						component.set("v.riskswithProducts", item.Answer__c);
					}
					if (item.Question__c == "Is this a replacement product?") {
						component.set("v.replacementProduct", item.Answer__c);
					}

					if (
						component.get("v.currentSituationROA") != undefined &&
						component.get("v.financialProdExp") != undefined &&
						component.get("v.needsOrObjectives") != undefined
					) {
						component.set("v.showSubSectionB", false);
					} else {
						component.set("v.showSubSectionB", true);
					}

					if (component.get("v.partiallyOrFullyReplace") == "Yes" || component.get("v.haveInvestementorInvestedComponent") == "Yes") {
						component.set("v.showYesNoNASeciton", true);
					} else {
						component.set("v.showYesNoNASeciton", false);
					}

					if (component.get("v.partiallyOrFullyReplace") == "Yes") {
						component.set("v.showSectionD", true);
					} else {
						component.set("v.showSectionD", false);
					}
					if (component.get("v.replacementProduct") == "Yes") {
						component.set("v.showSectionDTable", true);
					} else {
						component.set("v.showSectionDTable", false);
					}
				}
			} else {
				console.log("Failed with state: " + JSON.stringify(response.getReturnValue()));
			}
		});
		$A.enqueueAction(action);
	},
	setROAFields: function (component, event, helper) {
		var q1 = component.find("meetingDtROA").get("v.value");
		var q2 = component.find("advisor").get("v.value") != undefined ? component.find("advisor").get("v.value") : "";
		var q3 = component.find("fais").get("v.value") != undefined ? component.find("fais").get("v.value") : "";
		var q4 = component.find("role").get("v.value") != undefined ? component.find("role").get("v.value") : "";
		var q5 = component.find("delegatesMeeting").get("v.value") != undefined ? component.find("delegatesMeeting").get("v.value") : "";
		var q6 = component.find("netAssetValue").get("v.value") != undefined ? component.find("netAssetValue").get("v.value") : "";
		var q7 = component.find("currentSituation").get("v.value") != undefined ? component.find("currentSituation").get("v.value") : "";
		var q8 = component.find("financialProdExp").get("v.value") != undefined ? component.find("financialProdExp").get("v.value") : "";
		var q9 = component.find("needsOrObjectives").get("v.value") != undefined ? component.find("needsOrObjectives").get("v.value") : "";
		var q10 =
			component.find("introductoryMeeting") != undefined && component.find("introductoryMeeting").get("v.value") != undefined
				? component.find("introductoryMeeting").get("v.value")
				: "";
		var q11 =
			component.find("prodRequested") != undefined && component.find("prodRequested").get("v.value") != undefined
				? component.find("prodRequested").get("v.value")
				: "";
		var q12 =
			component.find("followUpMeeting") != undefined && component.find("followUpMeeting").get("v.value") != undefined
				? component.find("followUpMeeting").get("v.value")
				: "";
		var q13 = component.find("other") != undefined && component.find("other").get("v.value") != undefined ? component.find("other").get("v.value") : "";
		var q14 =
			component.find("presentation") != undefined && component.find("presentation").get("v.value") != undefined
				? component.find("presentation").get("v.value")
				: "";
		var q15 =
			component.find("presentationName") != undefined && component.find("presentationName").get("v.value") != undefined
				? component.find("presentationName").get("v.value")
				: "";
		var q16 =
			component.find("presentationGrpName") != undefined && component.find("presentationGrpName").get("v.value") != undefined
				? component.find("presentationGrpName").get("v.value")
				: "";
		var q17 =
			component.find("presentationDate") != undefined && component.find("presentationDate").get("v.value") != undefined
				? component.find("presentationDate").get("v.value")
				: "";
		var q18 =
			component.find("presentationLocation") != undefined && component.find("presentationLocation").get("v.value") != undefined
				? component.find("presentationLocation").get("v.value")
				: "";
		var q19 =
			component.find("presentationFolioNo") != undefined && component.find("presentationFolioNo").get("v.value") != undefined
				? component.find("presentationFolioNo").get("v.value")
				: "";
		var q20 =
			component.find("clientAdvicedOfRisk") != undefined && component.find("clientAdvicedOfRisk").get("v.value") != undefined
				? component.find("clientAdvicedOfRisk").get("v.value")
				: "";
		var q21 =
			component.find("financialQuestion1") != undefined && component.find("financialQuestion1").get("v.checked") != undefined
				? component.find("financialQuestion1").get("v.checked")
				: "";
		var q22 =
			component.find("financialQuestion2") != undefined && component.find("financialQuestion2").get("v.checked") != undefined
				? component.find("financialQuestion2").get("v.checked")
				: "";
		var q23 =
			component.find("sectoralIndustry") != undefined && component.find("sectoralIndustry").get("v.value") != undefined
				? component.find("sectoralIndustry").get("v.value")
				: "";
		var q24 =
			component.find("sectoralBusinessProfile") != undefined && component.find("sectoralBusinessProfile").get("v.value") != undefined
				? component.find("sectoralBusinessProfile").get("v.value")
				: "";
		var q25 =
			component.find("sectoralOther") != undefined && component.find("sectoralOther").get("v.value") != undefined
				? component.find("sectoralOther").get("v.value")
				: "";
		var q27 =
			component.find("productSelectedPrior") != undefined && component.find("productSelectedPrior").get("v.value") != undefined
				? component.find("productSelectedPrior").get("v.value")
				: "";
		var q28 =
			component.find("partiallyOrFullyReplace") != undefined && component.find("partiallyOrFullyReplace").get("v.value") != undefined
				? component.find("partiallyOrFullyReplace").get("v.value")
				: "";
		var q29 =
			component.find("haveInvestementorInvestedComponent") != undefined &&
			component.find("haveInvestementorInvestedComponent").get("v.value") != undefined
				? component.find("haveInvestementorInvestedComponent").get("v.value")
				: "";
		var q30 =
			component.find("valueOfInvestmentDetermined") != undefined && component.find("valueOfInvestmentDetermined").get("v.value") != undefined
				? component.find("valueOfInvestmentDetermined").get("v.value")
				: "";
		var q31 =
			component.find("feesToLevied") != undefined && component.find("feesToLevied").get("v.value") != undefined
				? component.find("feesToLevied").get("v.value")
				: "";
		var q32 =
			component.find("indicativeOfFuturePerformances") != undefined && component.find("indicativeOfFuturePerformances").get("v.value") != undefined
				? component.find("indicativeOfFuturePerformances").get("v.value")
				: "";
		var q33 =
			component.find("monetaryObligations") != undefined && component.find("monetaryObligations").get("v.value") != undefined
				? component.find("monetaryObligations").get("v.value")
				: "";
		var q34 =
			component.find("anyIncentives") != undefined && component.find("anyIncentives").get("v.value") != undefined
				? component.find("anyIncentives").get("v.value")
				: "";
		var q35 =
			component.find("penalties") != undefined && component.find("penalties").get("v.value") != undefined
				? component.find("penalties").get("v.value")
				: "";
		var q36 =
			component.find("specialTermsConditions") != undefined && component.find("specialTermsConditions").get("v.value") != undefined
				? component.find("specialTermsConditions").get("v.value")
				: "";
		var q37 =
			component.find("productReadilyAccessible") != undefined && component.find("productReadilyAccessible").get("v.value") != undefined
				? component.find("productReadilyAccessible").get("v.value")
				: "";
		var q38 =
			component.find("collingOffRights") != undefined && component.find("collingOffRights").get("v.value") != undefined
				? component.find("collingOffRights").get("v.value")
				: "";
		var q39 =
			component.find("riskswithProducts") != undefined && component.find("riskswithProducts").get("v.value") != undefined
				? component.find("riskswithProducts").get("v.value")
				: "";
		var q40 =
			component.find("replacementProduct") != undefined && component.find("replacementProduct").get("v.value") != undefined
				? component.find("replacementProduct").get("v.value")
				: "";
		var paramsMap = component.get("v.paramsMap");
		paramsMap["Meeting date"] = q1;
		paramsMap["Advisor or Intermediary"] = q2;
		paramsMap["FAIS Classification"] = q3;
		paramsMap["Role"] = q4;
		paramsMap["Delegates at the Meeting"] = q5;
		paramsMap["Net Asset Value of Entity"] = q6;
		paramsMap["Current Financial Situation"] = q7;
		paramsMap["Current Financial Product Experience change/Investment Risk Profile"] = q8;
		paramsMap["Needs or Objectives"] = q9;
		paramsMap["Introductory Meeting"] = q10;
		paramsMap["Specific product requested"] = q11;
		paramsMap["Follow-up Meeting"] = q12;
		paramsMap["Other"] = q13;
		paramsMap["Presentation"] = q14;
		paramsMap["Name of Presentation"] = q15;
		paramsMap["Details of Group Name"] = q16;
		paramsMap["Date"] = q17;
		paramsMap["Location"] = q18;
		paramsMap["Folio Number of Presentation"] = q19;
		paramsMap["Was the client advised of the risk involved?"] = q20;
		paramsMap["The financial position was considered by completing a Financial Needs Analysis"] = q21;
		paramsMap["The client opted not to provide the full facts in relation to his/her financial situation"] = q22;
		paramsMap["Makro (Sectoral ) – Industry"] = q23;
		paramsMap["Makro (Sectoral) – Typical firm or Business Profile"] = q24;
		paramsMap["Makro (Sectoral ) – Other"] = q25;
		paramsMap["Did you select a product prior to receiving the information you provided?"] = q27;
		paramsMap["will address the needs partially or fully replacing an existing financial product"] = q28;
		paramsMap["your needs have an investment or investment component?"] = q29;
		paramsMap["valueOfInvestmentDetermined"] = q30;
		paramsMap["feesToLevied"] = q31;
		paramsMap["indicativeOfFuturePerformances"] = q32;
		paramsMap["monetaryObligations"] = q33;
		paramsMap["anyIncentives"] = q34;
		paramsMap["penalties"] = q35;
		paramsMap["specialTermsConditions"] = q36;
		paramsMap["productReadilyAccessible"] = q37;
		paramsMap["collingOffRights"] = q38;
		paramsMap["riskswithProducts"] = q39;
		paramsMap["Is this a replacement product?"] = q40;
		component.set("v.paramsMap", paramsMap);
	},
    
	saveROA: function (component, event, helper) {
		this.setROAFields(component, event, helper);
		var paramsMap = component.get("v.paramsMap");
		console.log("paramsMap " + JSON.stringify(paramsMap));
		var action = component.get("c.createQuestionnaireRecords");
		action.setParams({
			oppId: component.get("v.recordId"),
			questionsMap: paramsMap
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var result = JSON.stringify(response.getReturnValue());
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Success",
					message: "Records has been Sucessfully Updated",
					duration: " 5000",
					type: "success"
				});
				toastEvent.fire();
				component.set("v.showSpinner", false);
			}
		});
		$A.enqueueAction(action);
	},
//Added by Diksha for voice 02-09-2021
    hideAccordinsForVoice: function(component, event, helper){
        var processType =component.get('v.processType');
        var productusage=component.find("productusage");
        var chequeStatementDetails=component.find("chequeStatementDetails");
        if(processType == 'Voice Sales Product Onboarding'){
           $A.util.toggleClass(productusage, 'slds-hide');
           $A.util.toggleClass(chequeStatementDetails, 'slds-hide');

}
        else{
            $A.util.toggleClass(productusage, 'slds-show');
            $A.util.toggleClass(chequeStatementDetails, 'slds-show');
        }

	}
   
    
})