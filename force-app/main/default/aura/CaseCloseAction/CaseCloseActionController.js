/**
* @author  Rudolf Niehaus : CloudSmiths
* @version v1.0
* @since   2018-06-14
**/
({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.loadData");
        
        action.setParams({
            "recId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var thedata = response.getReturnValue();
                var statusList = thedata.closeStatusList;
                var slaStatus = thedata.isOutOfSla;
                var closeStatus = thedata.isClosed;
                var classifyStatus = thedata.isNotClassified;
                var linkStatus = thedata.isNotLinked;
                var defaultStatus = thedata.defaultStatus;
				 // Added to fetch the additional fields for NBFS case record type
                var isNBFSRecordType = thedata.isNBFSRecordType;
                var NBFSServiceGroup = thedata.NBFSServiceGroup;
                if(NBFSServiceGroup.includes('Complaints')){
                    NBFSServiceGroup =	NBFSServiceGroup.substring(0, NBFSServiceGroup.indexOf('Complaints'));
            		NBFSServiceGroup = NBFSServiceGroup.trim();
                }
                var NBFSCategory = thedata.NBFSCategory;
                var mappings = thedata.mappings;
                var NBFSSource = thedata.NBFSSource;
                var NBFSDocumentList = thedata.DocumentsList;
                var claimamount = thedata.ClaimAmount;
                //Smanga Start
                console.log('priorityServiceGroupsNames ==> ' + thedata.priorityServiceGroupsNames);
                component.set("v.priorityServiceGroupNamesList",thedata.priorityServiceGroupsNames);
                component.set("v.isUserPriorityGroupMember",thedata.isUserPriorityGroupMember); 
                component.set("v.isPriorityServiceGroup",thedata.isPriorityServiceGroup);
                component.set("v.caseBeforeClosure",thedata.caseBeforeClosure);
                console.log("is user in the group ==> "+ component.get("v.isUserPriorityGroupMember"));
                console.log("is it A Priority Serv Group ==> "+ component.get("v.isPriorityServiceGroup"));
                //Smanga End

                                if(isNBFSRecordType === true){
                      if(NBFSDocumentList !== undefined )
                	  {
                    		if(NBFSDocumentList.length > 0){
                        	component.set("v.isFileUpload",true);
                    		component.set("v.files",NBFSDocumentList);
                    	 }  
                	  }
                        if(mappings != null)
                		{
                    		var decisions = mappings.Regulatory_Decision__c;
                    		var productType = mappings.Product_Type__c;
                    		var region = mappings.Region__c;
                    		var problemarea = mappings.Problem_Area__c;
                   
                    		if(decisions !== undefined){
                        	var decisionlist = decisions.split(';');
                			component.set("v.regulatorydecisonsList", decisionlist);
                    	}
                    	if(productType !== undefined){
                        	var producttypelist = productType.split(';');
                       		component.set("v.productTypeList", producttypelist);
                    	}
                    	if(region !== undefined){
                        	var regionlist = region.split(';');
 							component.set("v.regionList",regionlist);	
                     	}
                    	if(problemarea !== undefined){
                        	var problemarealist = problemarea.split(';');
                        	component.set("v.problemAreaList",problemarealist );
                     	}
                	}
                	var closestatuslabel = component.find("stselect");
                    closestatuslabel.set('v.label','Resolution Type');
                    if(NBFSCategory === 'Level 1')
                    {
                        if((NBFSServiceGroup === 'Wealth Advisory' && claimamount < 5001) || NBFSServiceGroup === 'Absa Linked Investments' || NBFSServiceGroup === 'Absa Fund Managers' || NBFSServiceGroup === 'Absa Estates Wills & Trusts' || NBFSServiceGroup =='Absa Short Term Insurance')
                        {
                            var wealthcloseList = 'Resolved Non-Monetary;Resolved Monetary';
                            statusList = wealthcloseList.split(';');
                        }
                        else
                        {
                            statusList = 'Resolved Non-Monetary';
                            component.set("v.selectedStatus", statusList);
                            var action = component.get("c.getDocumentTypeInfo");
                            
        					action.setParams({
            					"servicegroup" : NBFSServiceGroup,
                				"category" : NBFSCategory,
                				"resolutiontype" : statusList
       		 				});
       						action.setCallback(this, function(response) {
           
            				var state = response.getState();
         
            				if (component.isValid() && state === "SUCCESS") {
               					component.set("v.documentlist", response.getReturnValue());
                				console.log("documentlist",response.getReturnValue());
            			 	}
        					});
       						// Send action off to be executed
        					$A.enqueueAction(action);
                        }
                    }  
                }
                //to display additional fields for NBFS Case record type
                component.set("v.isNBFSCaseRecordType", isNBFSRecordType);
                component.set("v.servicegroupName", NBFSServiceGroup);
                component.set("v.category", NBFSCategory);
                component.set("v.source", NBFSSource);

                component.set("v.closeStatuses", statusList);
                component.set("v.isOutOfSla", slaStatus);
                component.set("v.isCaseClosed", closeStatus);
                component.set("v.isNotClassified", classifyStatus);
                component.set("v.isNotLinkedToAccount", linkStatus);
                 // Added by Poulami to remove the assignment of default status:
                if(component.get("v.selectedStatus") === undefined)
                component.set("v.selectedStatus", defaultStatus);
                component.set("v.ireason", "--None--");
                
                var ireason = component.find("ireason");
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
    },
    
    /* New function created to fetch the Advisor details for the field Advisor exposed only for NBFS Case Record Type */
    	getAdvisorDetails : function(component, event, helper) {
       
        	var action = component.get("c.getAdvisorInfo");
       
       	 	var advisorid = component.find("iAdvisor").get("v.value");
         	action.setParams({
            	"advisorid" : advisorid
       		 });
       		action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
            
           	component.set("v.UserTypes", response.getReturnValue());
		   	var name = component.get("v.UserTypes.Name");
           	var code = component.get("v.UserTypes.Advisor_Code__c");
            if(name !== null){
               var advisorname = name.split(" ");
           	   component.set("v.advisorFirstName", advisorname[0]);
           	   component.set("v.advisorLastName", advisorname[1]);
            }
            else{
                    component.set("v.advisorFirstName", '');
           	   		component.set("v.advisorLastName", '');
            }	
           	if(code !== undefined)
              component.set("v.advisorCode", code);
           	else
              component.set("v.advisorCode", '');
         	}
      	});
       
        // Send action off to be executed
        	$A.enqueueAction(action);
            
    },
    
    
    /* New function created to display field for Wealth Advisory only for NBFS Case Record Type */
     getWealthBusinessArea : function(component, event, helper) {
       
        var wealthArea = component.find("iWealthArea").get("v.value");
        component.set("v.wealthArea", wealthArea);
    },
    
   /* New function created to upload the documents to close a case based on Resolution Type only for NBFS Case Record Type */
    UploadFinished : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        var fileName =  uploadedFiles[0].name;
        if(uploadedFiles !== null)
            component.set("v.isFileUpload",true);
        var documentId = uploadedFiles[0].documentId;
        var documentType = component.get("v.documenttype");
       
        var action = component.get("c.UpdateFiles");

        action.setParams({
           
            "documentId":documentId ,
            "description":documentType ,
            "recordId": component.get("v.recordId")
           
            });
       
        action.setCallback(this,function(response){
            var state = response.getState();
       
            if(state === 'SUCCESS'){
            	var result = response.getReturnValue();
        		component.set("v.files",result);
                component.set("v.documenttype",'');
            }
        });
       
        // Send action off to be executed
        $A.enqueueAction(action);    
    },
   
    updateCase : function(component, event, helper) {
        
        helper.showSpinner(component);
        debugger;
        var action = component.get("c.resolveCase");
        var selectedStatus = component.get("v.selectedStatus");
        var selectedReason = component.find("ireason").get("v.value");
        var selectedUnresolve = component.find("ureason").get("v.value");
        var selectedResolvedInFavour = component.find("iResolvedInFavour").get("v.value");
        var comments = component.find("icomm").get("v.value");
        var whoCausedIt = component.find("iWhoCausedIt").get("v.value");
        var summaryOfResolution = component.find("iSummaryOfResolution").get("v.value");
        var whereDidThisHappen = component.find("iWhere_Did_This_Happen").get("v.value");
        var responsibleSite = component.find("iResponsible_Site").get("v.value");
        var tradeLoss = component.find("iTrade_Loss").get("v.value");
        var amountRefunded = component.get("v.amountRefunded"); //component.find("iAmount_Refunded").get("v.value");
        var gestureOfGoodwill = component.find("iGesture_Of_Goodwill").get("v.value");
        // to display additional fields for NBFS Case record type
        var caserecordtype = component.get("v.isNBFSCaseRecordType");
       	var servicegroup = component.get("v.servicegroupName");
        var category = component.get("v.category");

        //added for Short term insurance : we already have logic.
        if(servicegroup != 'Absa Short Term Insurance'){
            var amountPaid = component.find("iAmountPaid").get("v.value");
        }
        
        var amountPaid;
        var paymentDate;
        
        //Short term related
        var paymentMethod;
        var controllableSecondary;
        var escControllability;
        //var regulatoryDecision;
        var finalClaimsDecision;
        var originalClaimsDecision;
        
        if(servicegroup == 'Absa Short Term Insurance'){
            amountPaid = '';
            paymentDate = component.find("iPaymentDate").get("v.value");
            
             paymentMethod = component.find("iPaymentMethod").get("v.value");
             controllableSecondary = component.find("controllableSecondary").get("v.value");
             escControllability = component.find("escControllability").get("v.value");
             //regulatoryDecision = component.find("regulatoryDecision").get("v.value");
             finalClaimsDecision = component.find("finalClaimsDecision").get("v.value");
             originalClaimsDecision = component.find("originalClaimsDecision").get("v.value");
            
        }else{
            amountPaid = component.find("iAmountPaid").get("v.value");
            paymentDate = component.find("iPaymentDate").get("v.value");
        }

        var causeOfProblem = component.find("iCauseOfProblem").get("v.value");
        var resolutionSubType = component.find("iResolutionSubType").get("v.value");
        var paymentDate = component.find("iPaymentDate").get("v.value");
        var controllability = component.find("iControllability").get("v.value");
        var TCFOutcomes = component.find("iTCFOutcomes").get("v.value")
        var advisorName = component.find("iAdvisorName").get("v.value");
        var advisorregion = component.get("v.region");
        var advisortype = component.find("iAdvisortype").get("v.value");
        var productnumber = component.find("iproductnumber").get("v.value");
        var productname = component.find("iproductname").get("v.value");
        var productsupplier = component.find("iproductsupplier").get("v.value");
        var producttype = component.get("v.productType");
       	var advicedate = component.find("iadvicedate").get("v.value");
        var compliant = component.find("icompliant").get("v.value");
        var compliantnature = component.find("icompliantnature").get("v.value");
        var documenttypes = component.get("v.files");
        var portfolioManager = component.find("iPortfolioManager").get("v.value");
        var relationshipManager = component.find("iRelationshipManager").get("v.value");
        var introducer = component.find("iIntroducer").get("v.value");
        var documentfiles = component.get("v.documentlist");
        var isFileUpload = component.get("v.isFileUpload");
        var financialAdvisor = component.find("iFinancialAdvisor").get("v.value");
        var segment = component.find("iSegment").get("v.value");
        var wealtharea = component.find("iWealthArea").get("v.value");
        var responsiblePerson = component.find("iResponsiblePerson").get("v.value");
        //var nature = component.find("iNature").get("v.value");
        var portfolioNumber = component.find("iPortfolioNumber").get("v.value");
        var transaction = component.find("iTransaction").get("v.value");
        var lodged = component.find("ilodged").get("v.value");
        var consultant = component.find("iConsultant").get("v.value");
        var problemarea = component.get("v.problemArea");
        var regdecisions = component.get("v.regulatorydecisons");
        var wealthAreaDesc = component.find("iwealthAreaDesc").get("v.value");
        var problemAreaDesc = component.find("iProblemAreaDesc").get("v.value");
        var accountnumber = component.find("iAccountNumber").get("v.value");
        var advisor = component.find("iAdvisor").get("v.value");
        var ProductArea = component.find("iProductArea").get("v.value");
        var SubProductArea = component.find("iSubProductArea").get("v.value");
        var banker = component.find("iBanker").get("v.value");
        var adviserfirstname = component.find("iAdvisorFirstName").get("v.value");
        var adviserlastname = component.find("iAdvisorLastName").get("v.value");
        var advisercode = component.find("iAdvisorCode").get("v.value");
        var clientNumber = component.find("iClientNumber").get("v.value");
        //Smanga -start - validate if POP is uploaded
        var amountRefunded 			= component.get("v.amountRefunded");
        var popFileIds     			= component.get("v.proofOfPaymentfileIds");
        var showAmountRefundedPopup = component.get("v.showTheReminder");
        console.log('amountRefunded ==> '+ amountRefunded);
        console.log('popFileIds length ==> '+ popFileIds.length);
        //Smanga -end
        
        
        component.set("v.updateCase.Status", selectedStatus);
        component.set("v.updateCase.Out_Of_SLA_Reason__c", selectedReason);
        component.set("v.updateCase.Out_Of_SLA_Comments__c", comments);
        component.set("v.updateCase.Who_Caused_It__c", whoCausedIt);
        component.set("v.updateCase.Summary_of_Resolution__c", summaryOfResolution);
        component.set("v.updateCase.Resolved_in_Favour_of__c", selectedResolvedInFavour);
        component.set("v.updateCase.Unresolved_Reason__c", selectedUnresolve);
        component.set("v.updateCase.Where_Did_This_Happen__c", whereDidThisHappen);
        component.set("v.updateCase.Responsible_Site__c", responsibleSite);
        component.set("v.updateCase.Trade_Loss__c", tradeLoss);
        if(gestureOfGoodwill !== undefined)
        	component.set("v.updateCase.Gesture_Of_Goodwill__c", gestureOfGoodwill);
        component.set("v.updateCase.Who_Caused_It_Options__c", whoCausedIt);
        if(amountPaid !== undefined)
        	component.set("v.updateCase.Amount_Refunded__c", amountPaid);
        else
        	component.set("v.updateCase.Amount_Refunded__c", amountRefunded);
        component.set("v.updateCase.Resolution_Sub_Type__c", resolutionSubType);
        component.set("v.updateCase.Cause_of_problem__c", causeOfProblem);
        component.set("v.updateCase.Date_of_payment__c", paymentDate);
        component.set("v.updateCase.Controllability__c", controllability);
        component.set("v.updateCase.TCF_Outcomes__c", TCFOutcomes);
        component.set("v.updateCase.NBFS_Region__c", advisorregion);
        component.set("v.updateCase.Adviser_Name__c", advisorName);
        component.set("v.updateCase.Adviser_Type__c", advisortype);
        component.set("v.updateCase.Product_Number__c", productnumber);
        component.set("v.updateCase.Product_Name__c", productname);
        component.set("v.updateCase.Product_Supplier__c", productsupplier);
        component.set("v.updateCase.Product_Type__c", producttype);
        component.set("v.updateCase.Advice_Date__c", advicedate);
        component.set("v.updateCase.Compliant__c", compliant);
        component.set("v.updateCase.Nature_of_Non_Compliance_Text__c", compliantnature);
        component.set("v.updateCase.Financial_Advisor__c", financialAdvisor);
        component.set("v.updateCase.Segment__c", segment);
        component.set("v.updateCase.Wealth_Related_Business_Area__c", wealtharea);
        component.set("v.updateCase.Portfolio_Manager__c", portfolioManager);
        component.set("v.updateCase.Relationship_Manager__c", relationshipManager);
        component.set("v.updateCase.Introducer__c", introducer);
        component.set("v.updateCase.Problem_Area__c", problemarea);
        component.set("v.updateCase.Responsible_Person__c", responsiblePerson);
        component.set("v.updateCase.Portfolio_Number__c", portfolioNumber);
        component.set("v.updateCase.Transaction_Type__c", transaction);
        component.set("v.updateCase.Lodged_by_adviser__c", lodged);
        component.set("v.updateCase.Consultant__c", consultant);
        component.set("v.updateCase.Regulatory_Decision__c", regdecisions);
        if(wealthAreaDesc !== undefined)
        	component.set("v.updateCase.Problem_Area_Description__c", wealthAreaDesc);
        else
        	component.set("v.updateCase.Problem_Area_Description__c", problemAreaDesc);
        component.set("v.updateCase.Account_Number__c", accountnumber);
        component.set("v.updateCase.Advisor__c", advisor);
        component.set("v.updateCase.Product_Area__c", ProductArea);
        component.set("v.updateCase.Sub_Product_Area__c", SubProductArea);
        component.set("v.updateCase.Adviser_First_Name__c", adviserfirstname);
        component.set("v.updateCase.Adviser_Last_Name__c", adviserlastname);
        component.set("v.updateCase.Adviser_Code__c", advisercode);
        component.set("v.updateCase.Banker__c", banker);
        component.set("v.updateCase.Client_Number__c", clientNumber);
        
        //Short Term Insurance Related
        component.set("v.updateCase.Payment_Method__c", paymentMethod);
        component.set("v.updateCase.Controllable_Secondary_Complaint_Type__c", controllableSecondary);
        component.set("v.updateCase.Escalation_Controllable__c", escControllability);
        //component.set("v.updateCase.Regulatory_Decision__c", regulatoryDecision);
        component.set("v.updateCase.Final_Claims_Decision__c", finalClaimsDecision);
        component.set("v.updateCase.Original_Claims_Decision__c", originalClaimsDecision);
                
        var updateCaseRecord = component.get("v.updateCase");
        console.log('updateCaseRecord: '+ updateCaseRecord);
        
        /*action.setParams({
            "recId" : component.get("v.recordId"),
            "status" : selectedStatus,
            "reason" : selectedReason,
            "comment" : comments,
            "whoCausedIt" : whoCausedIt,
            "summaryOfResolution" : summaryOfResolution,
            "resolvedInFavour" : selectedResolvedInFavour,
            "unresolvedReason" : selectedUnresolve,
            "whereDidThisHappen" : whereDidThisHappen,
            "responsibleSite" : responsibleSite,
            "tradeLoss" : tradeLoss,
            "amountRefunded" : amountRefunded,
            "gestureOfGoodwill" : gestureOfGoodwill
        });*/
        action.setParams({
            "recId" : component.get("v.recordId"),
        	"caseRecord" : updateCaseRecord
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {

                //Smanga start - get all uploaded files
                var caseRecId = response.getReturnValue();
                var popFileIds =  component.get("v.proofOfPaymentfileIds");

                if(popFileIds.length > 0) {
                    var action = component.get("c.uploadContentDocuments");
                    action.setParams({
                        caseId : caseRecId, 
                        contentDocumentIds : popFileIds
                    });        
                    action.setCallback(this, function(response) {
                        var state = response.getState();            
                        if (state === "SUCCESS") {
                            console.log(response.getReturnValue());
                        }            
                    });
                    $A.enqueueAction(action);
                }//Smanga - end
                
                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Case Closed",
                    "type":"success"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                helper.closeFocusedTab(component);
                //helper.navHome(component, event, helper);
                // refresh record detail
                $A.get("e.force:refreshView").fire();
            }else if(state === "ERROR"){
                var message = '';
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                } else {
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                // show error notification 
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
                
            }
        });
        
        if(selectedStatus === '--None--'){
            
            var toastEvent = $A.get("e.force:showToast");
            
            if(caserecordtype === true){
                toastEvent.setParams({
                "title": "Warning",
                "message": "Please select a Resolution Type before closing this case",
                "type":"warning"
            });
            }
            else{
            toastEvent.setParams({
                "title": "Warning",
                "message": "Please select a Closed Status before closing this case",
                "type":"warning"
            });
            }
            toastEvent.fire();
            
            helper.hideSpinner(component);
            
        }else{
            
             if( !whoCausedIt && caserecordtype === false){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please complete Who Caused It?",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }
            else if( !summaryOfResolution){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please provide Summary of Resolution",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }
            else if(caserecordtype === false){
                
            if(!selectedReason && component.get("v.isOutOfSla")){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select an Out of SLA Reason before closing this case",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( !comments && component.get("v.isOutOfSla") ){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please provide an Out of SLA Comment",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( !whereDidThisHappen){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please complete Where Did This Happen?",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( !responsibleSite){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please complete Responsible Site?",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( !tradeLoss){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please complete Trade Loss?",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if(amountRefunded && showAmountRefundedPopup ){ //Smanga - start

                console.log("<===inside if statement* ===>");
                helper.showReminderAction(component, event);
                helper.hideSpinner(component);
                return null;          
                //Smanga -end
            
            }else if( ( !selectedUnresolve || selectedUnresolve === '--None--' ) && selectedStatus === 'Unresolved'){
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select an Unresolved Reason for this case",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( ( !selectedResolvedInFavour || selectedResolvedInFavour === '--None--' ) && selectedStatus === 'Resolved'){
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select an Resolved in Favour of for this case",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }
             else
               $A.enqueueAction(action);
            }//Poulami added validations for NBFS Case Record Type Fields
            else if(caserecordtype === true)
            {
                if( !TCFOutcomes){
               
                var toastEvent = $A.get("e.force:showToast");
               
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please provide TCF Outcomes.",
                    "type":"warning"
                });
               
                toastEvent.fire();
               
                helper.hideSpinner(component);
                return null;
               
            }else if( !causeOfProblem){
               
                var toastEvent = $A.get("e.force:showToast");
               
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please provide Cause Of Problem.",
                    "type":"warning"
                });
               
                toastEvent.fire();
               
                helper.hideSpinner(component);
                return null;
               
            }else if( !controllability){
               
                var toastEvent = $A.get("e.force:showToast");
               
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please provide Controllability.",
                    "type":"warning"
                });
               
                toastEvent.fire();
               
                helper.hideSpinner(component);
                return null;
               
            }else if(servicegroup === 'Wealth Advisory' && !segment){
                
                var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Segment.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                
            }else if(servicegroup === 'Wealth Advisory' && !banker){
                
                var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please enter the Banker for your Case.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                
            }else if(servicegroup === 'Absa Estates Wills & Trusts' && !ProductArea){
                
                var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select the Product Area for your Case.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                
            }else if(servicegroup === 'Absa Estates Wills & Trusts' && !SubProductArea){
                
                var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select the Sub Product Area for your Case.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                
            }else if(servicegroup === 'Wealth Advisory' && !wealtharea && (category === 'Level 2' || category === 'Level 3')){
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Wealth Related Business Area.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                
             }else if(wealtharea === 'Other' && !wealthAreaDesc){
                 
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Wealth Business Area Description.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                 
             }else if(servicegroup === 'Absa Advisers' && !advisortype && (category === 'Level 2' || category === 'Level 3')){
                
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Adviser Type.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                 
                }else if(servicegroup === 'Absa Advisers' && !adviserfirstname && (category === 'Level 2' || category === 'Level 3')){
                
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Adviser First Name.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                 
                }else if(servicegroup === 'Absa Advisers' && !adviserlastname && (category === 'Level 2' || category === 'Level 3')){
                
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Adviser Last Name.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                 
                }else if(servicegroup === 'Absa Advisers' && !advisercode && (category === 'Level 2' || category === 'Level 3')){
                
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Adviser Code.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                 
                }else if(servicegroup === 'Absa Advisers' && !advicedate && (category === 'Level 2' || category === 'Level 3')){
                    
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Advice Date.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                    
                }else if(servicegroup === 'Absa Advisers' && !compliant && (category === 'Level 2' || category === 'Level 3')){
                    
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Compliant.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                    
                }else if(compliant === 'No' && !compliantnature){
                    
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please enter Nature of Non-Compliance Text.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                    
                }else if(servicegroup === 'Absa Linked Investments' && !clientNumber){
                
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Client Number.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                    
                }else if(servicegroup === 'Absa Linked Investments' && !portfolioNumber){
                    
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please enter Portfolio Number.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                    
                }else if(servicegroup === 'Absa Linked Investments' && !transaction){
                    
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Transaction Type.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                    
                }else if((servicegroup === 'Absa Advisers' || servicegroup === 'Absa Linked Investments' || servicegroup === 'Absa Fund Managers' || servicegroup === 'Wealth Advisory') && !advisorregion){
                
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Region.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
               		return null;
                    
                }else if((servicegroup === 'Stockbroking' || (servicegroup === 'Portfolio Management' && (category === 'Level 2' || category === 'Level 3'))) && !problemarea){
                
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Problem Area.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                    
                }else if(problemarea === 'Other' && !problemAreaDesc){
                    
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Problem Area Description.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                    
                }else if((servicegroup === 'Absa Linked Investments' || servicegroup === 'Absa Advisers' || (servicegroup === 'Wealth Advisory' && (category === 'Level 2' || category === 'Level 3')) || servicegroup === 'Portfolio Management') && !producttype){
               
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Product Type.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                    
                }else if(component.get("v.category") === 'Level 3' && !regdecisions){
                
                    var toastEvent = $A.get("e.force:showToast");
                   	toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select Regulatory Decision.",
                    "type":"warning"
                	});
                	toastEvent.fire();
                	helper.hideSpinner(component);
                	return null;
                    
                }else if( ( !paymentDate ) && selectedStatus === 'Resolved Monetary' && caserecordtype == false){
               
                var toastEvent = $A.get("e.force:showToast");
               
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please provide Payment Date.",
                    "type":"warning"
                });
               
                toastEvent.fire();
               
                helper.hideSpinner(component);
                return null;
               
            } else if( ( !amountPaid ) && selectedStatus === 'Resolved Monetary' && caserecordtype == false){
               
                var toastEvent = $A.get("e.force:showToast");
               
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please provide Amount Paid.",
                    "type":"warning"
                });
               
                toastEvent.fire();
               
                helper.hideSpinner(component);
                return null;
               
            }else if( ( !resolutionSubType ) && selectedStatus === 'Resolved Monetary'){
               
                var toastEvent = $A.get("e.force:showToast");
               
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please provide Resolution Sub Type.",
                    "type":"warning"
                });
               
                toastEvent.fire();
               
                helper.hideSpinner(component);
                return null;
               
            }else if(isFileUpload === true && (documentfiles !== null)){
                
              	var types = [];
                
                outerloop:
                for(var i = 0;i < documentfiles.length;i++){
    				var obj = documentfiles[i];
                innerloop:
                    for(var j = 0;j < documenttypes.length;j++){
                        var ob = documenttypes[j].Description;
                        if(obj === ob){
                            types.push('Y');
                            break innerloop;
                        }
                    }
				}
                console.log('documentfiles length=='+documentfiles.length+'==types.length=='+types.length);
                if(documentfiles.length === types.length){
                    $A.enqueueAction(action);
    				console.log('Arrays are equal!');
                }
                else{
                	var toastEvent = $A.get("e.force:showToast");
               		toastEvent.setParams({
                    "title": "Warning",
                    "message": "All required documents not uploaded. Please upload the require documents.",
                    "type":"warning"
                });
               
                	toastEvent.fire();
               
                	helper.hideSpinner(component);
                	return null;
            		}
            }else if( isFileUpload === false && (documentfiles !== null)){
               	
                var toastEvent = $A.get("e.force:showToast");
               
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Required documents not uploaded. Please upload the require documents.",
                    "type":"warning"
                });
               
                toastEvent.fire();
               
                helper.hideSpinner(component);
                return null;
               
            	}
                else{
               		 $A.enqueueAction(action);
            	}
            }
            else{
                
                $A.enqueueAction(action);
            }
            
        }
    },
    onSelectChange : function(component, event, helper) {
        
        var selected = component.find("stselect").get("v.value");
        
        if(selected == 'Resolved') {
            $A.util.addClass(component.find("ureason"), "slds-hide");
            $A.util.removeClass(component.find("iResolvedInFavour"), "slds-hide");
        } else if (selected == 'Unresolved') {
            $A.util.addClass(component.find("iResolvedInFavour"), "slds-hide");
            $A.util.removeClass(component.find("ureason"), "slds-hide");
        }
         // Fetch the NBFS case record type to get the document types required
        var NBFSFlag = component.get("v.isNBFSCaseRecordType");
        
        if(NBFSFlag == true){
            if (selected == 'Resolved Monetary')
             	component.set("v.isNBFSMonetaryResolution", true);
        	else
        		component.set("v.isNBFSMonetaryResolution", false);
            
            var action = component.get("c.getDocumentTypeInfo");
       
        	var servicegroupname = component.get("v.servicegroupName");
            var category = component.get("v.category");
            
        	action.setParams({
            	"servicegroup" : servicegroupname,
                "category" : category,
                "resolutiontype" : selected
       		 });
       		action.setCallback(this, function(response) {
           
            var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {
               	component.set("v.documentlist", response.getReturnValue());
                console.log("documentlist",response.getReturnValue());
            	}
        	});
       		// Send action off to be executed
        	$A.enqueueAction(action);
        }
        
        $A.util.addClass(component.find("ClientResultTable"), "slds-hide");
        component.set("v.selectedStatus", selected);
        
    },

    //Smanga - function to handle onchange action on the Amount Refunded field
    handleOnChangeAction : function(component, event, helper) {
        
        if(component.get("v.amountRefunded") !== null || component.get("v.amountRefunded") !== undefined || component.get("v.amountRefunded") !== ""){
            helper.showUploadField(component,event, true);
        
        }else{
            helper.showUploadField(component,event, false);
        }
    },

    handleOncommitAction: function(component, event, helper) {
        console.log('component.get("v.amountRefunded") ==> '+ component.get("v.amountRefunded"));
        var enteredValue = component.get("v.amountRefunded");
        console.log('enteredValue ==> '+ enteredValue);
        //enteredValue === "" || enteredValue === undefined || enteredValue === null
        /*if(!enteredValue || enteredValue === ""){
			
            //helper.showUploadField(component,event, false);   
            component.set("v.showUploadStatementField", false);     
        
        }*/
        //console.log('showUploadStatementField ==> '+ component.get("v.showUploadStatementField"));

        if(enteredValue){

            helper.checkIfNotNumber(component,event);
        }
    },

    handleOnuploadfinished : function(component, event, helper) {

        helper.handlePOPFilesChange(component, event);
    },

})