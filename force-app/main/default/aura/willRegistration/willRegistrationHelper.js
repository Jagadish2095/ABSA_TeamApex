({
    checkOnInitValidity: function (component) {
        console.log("checkOnInitValidity");
        this.showSpinner(component);       
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkInitValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var validity = response.getReturnValue();                               
                if(validity[0] == 'Valid'){                     
                    component.set("v.showPreviousValidationFailed", false); 
                } else if(validity[0] == 'Invalid'){                    
                    component.set("v.showPreviousValidationFailed", true);
                    component.set("v.invalidMessages", validity[1]);
                    component.set("v.showValidated", false);
                }
            } else {
                console.log("checkOnInitValidity function failed with the state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    checkOnRegistrationError  : function (component) {
        console.log("checkOnRegistrationError");
        this.showSpinner(component);      
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkRegistrationError");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var RegistrationError = response.getReturnValue();
                console.log('checkOnRegistrationError: '+RegistrationError);                
                if(RegistrationError[0] == 'Done'){                   
                    component.set("v.showRegistrationStart", false);
                    component.set("v.showFinishedScreen",true);
                    component.set("v.showValidated", false);                    
                } else  if(RegistrationError[0] == 'Not Started'){                 
                    component.set("v.showRegistrationStart", true);
                    component.set("v.RegistrationErrorMessages", RegistrationError[1]);
                    component.set("v.showValidated", true);                    
                } else if(RegistrationError[0] == 'PreviousError'){                   
                    component.set("v.showPreviousValidationFailed", true);
                } else if(RegistrationError[0] == 'Invalid'){                       
                    component.set("v.showRegistrationStart", false);
                    component.set("v.showRegistrationFailedError", true);
                    component.set("v.RegistrationErrorMessages", RegistrationError[1]);
                    component.set("v.showValidated", true);
                } else if(RegistrationError[0] == 'Valid'){                           
                    component.set("v.showRegistrationFailedError", false);                            
                }
            }
            else {
                console.log("checkOnRegistrationError function failed with the state: " + state);
            }
            this.hideSpinner(component);
        });        
        $A.enqueueAction(action);
    },    
    
    getAccountData: function (component) {
        console.log("getAccountData");
        this.showSpinner(component);       
        var oppId = component.get("v.recordId");
        var action = component.get("c.getAccountData");
        action.setParams({
            "oppId": oppId
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.account",response.getReturnValue());                
                if(component.get("v.account.CIF__c")==null){                    
                    component.set("v.showValidated",false);
                    component.set("v.showError",true);
                    component.set("v.errorMessage","CIF Key is missing in the Account Record.  Please add CIF Key to the Account Record");                    
                }else{                    
                    component.set("v.showError",false);
                    component.set("v.errorMessage","");
                }
            }
            else {
                console.log("Failed fetching the account record :  " + state);
            }            
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    getOpportunityData: function (component) {
        console.log("getOpportunityData");
        this.showSpinner(component);       
        var oppId = component.get("v.recordId");
        var action = component.get("c.getOpportunityData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.opportunity", response.getReturnValue());                
            }
            else {
                console.log("Failed while fetching opportunity with state: " + state);
            }
            component.set("v.showSpinner", false);            
        });
        $A.enqueueAction(action);
    },    
    
    getApplicationData	 : function (component) {
        console.log("getApplicationData");        
        this.showSpinner(component);       
        var oppId = component.get("v.recordId");
        var action = component.get("c.getApplicationData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                component.set("v.application",response.getReturnValue());               
                if(component.get("v.application.Will_Type__c") =='Revision'){
                    component.set("v.showNewWillRegistration", false); 
                }
                console.log('type :' + component.get("v.application.Will_Type__c"));                
                if(component.get("v.application.Will_Stock_Confirmation__c") ==undefined){
                    component.set("v.application.Will_Stock_Confirmation__c", false);
                }
                if(component.get("v.application.Will_Created_In_Will_System__c") ==undefined){
                    component.set("v.application.Will_Created_In_Will_System__c", false);   
                }
                if(component.get("v.application.Will_Record_Created_In_SF__c") ==undefined){
                    component.set("v.application.Will_Record_Created_In_SF__c", false);  
                }
                if(component.get("v.application.Will_Initialise_Tracker_Create__c") ==undefined){
                    component.set("v.application.Will_Initialise_Tracker_Create__c", false);   
                }
                if(component.get("v.application.Get_Will_Detail__c") ==undefined){
                    component.set("v.application.Get_Will_Detail__c", false);   
                }                
                if(component.get("v.application.Will_Updated_In_Will_System__c") ==undefined){
                    component.set("v.application.Will_Updated_In_Will_System__c", false); 
                }                
                if(component.get("v.application.Will_Drafting_Banking_Detail_Created__c") ==undefined){
                    component.set("v.application.Will_Drafting_Banking_Detail_Created__c", false); 
                }
                if(component.get("v.application.Will_Banking_Detail_Created__c") ==undefined){
                    component.set("v.application.Will_Banking_Detail_Created__c", false); 
                }
                if(component.get("v.application.Will_Update_To_CIF__c") ==undefined){
                    component.set("v.application.Will_Update_To_CIF__c", false);
                }                
                if(component.get("v.application.Will_Communication_Sent__c") ==undefined){
                    component.set("v.application.Will_Communication_Sent__c", false);
                }
                if(component.get("v.application.Will_Asset_Liabilities_Created__c") ==undefined){
                    component.set("v.application.Will_Asset_Liabilities_Created__c", false);
                }                
                if(component.get("v.application.Will_Registration_Tracker_Created__c") ==undefined){
                    component.set("v.application.Will_Registration_Tracker_Created__c", false);
                }                
                /****************************  REVISION START   ******************************************/                
                if(component.get("v.application.Revision_Get_Will_Detail__c") ==undefined){
                    component.set("v.application.Revision_Get_Will_Detail__c", false);
                }
                if(component.get("v.application.Revision_Drafting_Banking_Detail_Created__c") ==undefined){
                    component.set("v.application.Revision_Drafting_Banking_Detail_Created__c", false);
                }
                if(component.get("v.application.Revision_Will_Banking_Detail_Created__c") ==undefined){
                    component.set("v.application.Revision_Will_Banking_Detail_Created__c", false);
                }
                if(component.get("v.application.Revision_Will_Update__c") ==undefined){
                    component.set("v.application.Revision_Will_Update__c", false);
                }
                if(component.get("v.application.Revision_Registration_AppTracker_Created__c") ==undefined){
                    component.set("v.application.Revision_Registration_AppTracker_Created__c", false);
                }
                if(component.get("v.application.Revision_Registration_Tracker_Created__c") ==undefined){
                    component.set("v.application.Revision_Registration_Tracker_Created__c", false);
                }                
            }
            else {
                console.log("Failed fetching the application record :  " + state);
            }            
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },    
    
    getAssetData: function (component) {
        console.log("getAssetData"); 
        this.showSpinner(component);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getAssetData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var assetResponse = response.getReturnValue();           
                if(Object.keys(assetResponse).length > 0 ){ //Asset Found on Client                    
                    component.set("v.asset", response.getReturnValue());
                    if(component.get("v.showError")==true || component.get("v.errorFound")==true ||component.get("v.showPreviousValidationFailed ")==true || component.get("v.showRegistrationFailedError ")==true || component.get("v.application.Registration_Status__c") !='Submitted'){
                        component.set("v.showFinishedScreen",false);                        
                    }else if(component.get("v.showError")==false && component.get("v.errorFound")==false && component.get("v.showPreviousValidationFailed") ==false && component.get("v.showRegistrationFailedError ")==false && component.get("v.application.Registration_Status__c") =='Submitted'){
                        component.set("v.showFinishedScreen",true);
                        component.set("v.showPreviousValidationFailed",false);
                    }
                }else {
                    console.log(" NO Asset found");
                }
            }
            else {
                console.log("Failed while fetching Asset with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    getStockNumber : function(component, event, helper){
        console.log("getStockNumber");        
        this.showSpinner(component);        
        var oppId = component.get("v.recordId");
        var checkStockNumber=component.get("v.application.Will_Stock_Confirmation__c");
        console.log("checkStockNumber" + checkStockNumber);        
        if(checkStockNumber === false) {
            component.set("v.application.Will_Stock_Confirmation__c",true);
            var channel='';                 
            var application ='WILLS';
            var msgLanguage = 'E';  				
            var msgTarget = 'STD' ;        
            var finalMsgClass = '';   			    
            var finalMsgCode = '';					
            var prodCategory = '001';						
            var prodType = '410';						
            var prodCode = '410';
            var siteCode = '3232';
            var action = component.get("c.getStockService");
            action.setParams({
                "oppId":oppId,
                "channelP": channel,
                "applicationP": application,
                "msgLanguageP":msgLanguage ,
                "msgTargetP":msgTarget,
                "finalMsgClassP":finalMsgClass,
                "finalMsgCodeP": finalMsgCode,
                "prodCategoryP": prodCategory,
                "prodTypeP": prodType,
                "prodCodeP": prodCode,
                "siteCodeP": siteCode
            });            
            action.setCallback(this, function(response) {
                var state = response.getState();
                var message = response.getReturnValue();
                var res=JSON.stringify(message);
                console.log('Stock Number:'+res);
                if (state === "SUCCESS") {                    
                    if(message!='false'){  //getting Will Number/Stock Number
                        component.set("v.asset.Name" , message); 
                        component.set("v.asset.SerialNumber" , message); 
                        component.set("v.showValidated",false);                  
                        var emessage = '"Will Number Generated Successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        //Calling function to create Will Record In Will System.
                        this.createAssetInSf(component, event, helper);
                    }
                    else{
                        var emessage = '"Stock number Already Exist for the client : "'+message;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire(); 
                        component.set("v.showValidated",true);
                    }
                }
                else{                    
                    var emessage = '"Submission Failed while fetching Will Number. Plese try again .. "';
                    var toastEvent = this.getToast("Error!", emessage, "Error");
toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);                    
                }   
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }else{
            //Stock Service already called 
            component.set("v.showSpinner", false);
            component.set("v.showValidated",false);
            //Calling function to create Will Record.
            this.createAssetInSf(component, event, helper);
        }
    },    
    
    createAssetInSf : function (component, event, helper) {
        console.log("createAssetInSf");
        this.showSpinner(component);
        var checkAssetInSf=component.get("v.application.Will_Record_Created_In_SF__c");
        console.log("checkAssetInSf" + checkAssetInSf);
        if(checkAssetInSf === false) {            
            var action = component.get("c.createAssetInSf");  
            var oppId = component.get("v.recordId");
            var asset =component.get("v.asset");            
            var stringAsset=JSON.stringify(asset);                      
            action.setParams({
                "opp": component.get("v.opportunity"),
                "oppId": oppId,
                "asse": asset                
            });             
            action.setCallback(this, function(response) {
                var state = response.getState();
                var Response = response.getReturnValue();
                if (state === "SUCCESS") {                    
                    if(Response==='Success'){
                        var emessage = '"Will Record is Created in SF Successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.createAssetWillSystem(component, event, helper);                        
                    }else {
                        var emessage = '"Failed to create A Will Record in SF : "'+Response;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();                        
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }      
                }
                else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission failed in process of creating a will in SF.Please Try Again .. Error : "'+errors;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();                    
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true); 
                }  
                component.set("v.showSpinner", false);                
            });            
            $A.enqueueAction(action);            
        }   
        else{
            //Asset already creaetd in SF 
            //Calling function to create Will Record In Will System.
            component.set("v.showSpinner", false);
            this.createAssetWillSystem(component, event, helper);            
        }   
    },
    
    createAssetWillSystem  : function (component, event, helper) {   
        console.log("createAssetWillSystem");
        this.showSpinner(component);
        var checkAssetCreateInWill=component.get("v.application.Will_Created_In_Will_System__c");
        console.log("checkAssetCreateInWill" + checkAssetCreateInWill);        
        if(checkAssetCreateInWill === false) {            
            var oppId = component.get("v.recordId");
            var willNo = component.get("v.asset.SerialNumber");
            var cifKey = component.get("v.account.CIF__c");
            //var domicileSite = component.get("v.opportunity.CIF__c");  //site object code -need to remove this - changed to Opp owner site code  			
            var corpCode = 'ABS';        
            var TransactionSite = 3232;   			    
            var tellerNo = 0;
            var action = component.get("c.createAssetInWillSystem");            
            action.setParams({                
                "oppId": oppId,
                "willNoP": willNo,
                "cifKeyP": cifKey,
                //"domicileSiteP": domicileSite,
                "corpCodeP":  corpCode,
                "TransactionSiteP": TransactionSite ,
                "tellerNoP":  tellerNo 
            });             
            action.setCallback(this, function(response) {
                var state = response.getState();
                var Response = response.getReturnValue();
                if (state === "SUCCESS") {                     
                    if(Response==='Success'){                        
                        component.set("v.application.Will_Created_In_Will_System__c", true); 
                        var emessage = '"Will Record is Created in Will System Successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.createTracker(component, event, helper);                        
                    }else if(Response==='Exists'){                        
                        alert('Cannot Continue with Registration !!! \n Will Already Exists in the Will System .');                        
                        component.set("v.showWillAlreadyExist",true);
                        component.set("v.showValidated",false);
                        component.set("v.showRegistrationStart",false);
                        component.set("v.showRegistrationFailedError",false);
                        component.set("v.showPreviousValidationFailed",false);                        
                    }else { 
                        var emessage = '"Failed to create A Will Record in Will System : "'+Response;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();                        
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }
                    component.set("v.showSpinner", false);
                }
                else if (state === "ERROR"){                    
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission Failed in Creating a WILL in Will System.Plese Try Again .. Error : "'+response+errors;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();                    
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);                    
                } 
                component.set("v.showSpinner", false);
            });            
            $A.enqueueAction(action);            
        }   
        else{
            //Asset already created in Will 
            //Calling function to create Tracker.
            component.set("v.showSpinner", false);
            this.createTracker(component, event, helper);
        } 
    },
    
    createTracker  : function (component, event, helper) {    
        console.log("createTracker");
        this.showSpinner(component);
        var checkTrackerCreated=component.get("v.application.Will_Initialise_Tracker_Create__c");
        console.log("checkTrackerCreated" + checkTrackerCreated);        
        if(checkTrackerCreated === false) {            
            var oppId = component.get("v.recordId");            
            var channel = 'WILLS';
            var application = 'WILLS';
            var willNo=component.get("v.asset.SerialNumber");
            var tstatus = 'D';
            var sstatus = 'A';
            var statCd = 'Arkcdxiqbsmyglenftph';
            var filLoc = '';
            var prevId = '';
            var actionP = 'Application Received';
            var comments = '';
            var branchCd = '3232'; //if Lucy =7283 else default 3232            
            var action = component.get("c.createTracker");            
            action.setParams({                
                "oppId": oppId,
                "channel" : channel,
                "application" : application,
                "willNo" : willNo,
                "tstatus" : tstatus,
                "sstatus" : sstatus,
                "statCd" : statCd,
                "filLoc" : filLoc,
                "prevId" : prevId,
                "actionP" : actionP,
                "comments" : comments,
                "branchCd" : branchCd,                
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                var Response = response.getReturnValue();
                if (state === "SUCCESS") {                     
                    if(Response==='Success'){
                        var emessage = '"Tracker is Created  Successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.getWillDetail(component, event, helper);
                    }else {
                        var emessage = '"Failed to create Tracker : "'+Response;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }
                }
                else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission Failed in Creating Tracker : "'+response+errors;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                } 
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }   
        else{
            //Tracker already creaetd  
            //Calling function to create Tracker get Will Deatail.
            component.set("v.showSpinner", false);
            this.getWillDetail(component, event, helper);
        } 
    },
    
    getWillDetail  : function (component, event, helper) {
        console.log("getWillDetail");
        this.showSpinner(component);
        var oppId = component.get("v.recordId");
        var willNo=component.get("v.asset.SerialNumber");
        var action = component.get("c.getAssetFromWillSystem");
        action.setParams({
            "oppId": oppId,
            "willNoP": willNo,
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            var getWillDetailResponse = response.getReturnValue();
            if (state === "SUCCESS") { 
                component.set("v.getResponse",response.getReturnValue());
                this.UpdateWillDetails(component, event, helper);
            }
            else if (state === "ERROR"){
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
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    UpdateWillDetails  : function (component, event, helper) {
        console.log("UpdateWillDetails");
        this.showSpinner(component);
        var CheckUpdateWill=component.get("v.application.Will_Updated_In_Will_System__c");
        if(CheckUpdateWill === false) { 
            var oppId = component.get("v.recordId");
            var willNo=component.get("v.asset.SerialNumber");
            var action = component.get("c.UpdateWill"); 
            action.setParams({
                "oppId" : oppId,
                "willNoP" : willNo,
                "GetWillResponse1" : component.get("v.getResponse"),
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                var UpdateWillResponse = response.getReturnValue();
                if (state === "SUCCESS") {
                    if(UpdateWillResponse =='Success'){
                        var emessage = '"Will Record Updated Successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.debitOrderInstruction(component, event, helper);
                    }else {
                        var emessage = '"Failed to Update Will Record : "'+UpdateWillResponse;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }
                }
                else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission Failed Updating Will Record From Will System.Plese Try Again : "'+errors;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                } 
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }   
        else{
            component.set("v.showSpinner", false);
            this.debitOrderInstruction(component, event, helper);
        }
    },
    
    debitOrderInstruction : function (component, event, helper) {
        console.log("debitOrderInstruction");
        this.showSpinner(component);
        var debitOrderInstruction=component.get("v.application.Fees_Waived__c");
        var debitOrderInstructionFeeEstate=component.get("v.application.Fee_For_Estate_Provider_Plan__c");
        var debitOrderInstructionFeeStaff=component.get("v.application.Fee_For_Staff__c");
        var dBInstructionCreated = component.get("v.application.Will_Drafting_Banking_Detail_Created__c");
        console.log("debitOrderInstruction" + debitOrderInstruction);
        if(debitOrderInstruction === false && debitOrderInstructionFeeEstate === false && debitOrderInstructionFeeStaff === false) {
            if(dBInstructionCreated === false) { //already created debitorderInstruction for drafting -(Dupicate checks)
                var oppId = component.get("v.recordId");
                var willNo=component.get("v.asset.SerialNumber");
                var action = component.get("c.debitOrderInstruction");
                action.setParams({
                    "oppId": oppId,
                    "willNoP": willNo
                }); 
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    var Response = response.getReturnValue();
                    if (state === "SUCCESS") {
                        if(Response==='Success'){
                            var emessage = '"Will Drafting Debit Order Instruction Created Successfully"';
                            var toastEvent = this.getToast("Success", emessage, "Success");
                            toastEvent.fire();
                            this.createWillBankingDetail(component, event, helper);
                        }else if(Response==='ServiceDown') {
                            var emessage = '"Internal Error: Debit Order Instruction Service Down .. Please Try Again "';
                            var toastEvent = this.getToast("Error!", emessage, "Error");
                            toastEvent.fire();
                            $A.get('e.force:refreshView').fire();
                            component.set("v.showValidated",true);
                        }else if(Response==='BranchPaymentDone') {
                            var emessage = '"Will Drafting Debit Order Instruction Created Successfully in branch"';
                            var toastEvent = this.getToast("Success", emessage, "Success");
                            toastEvent.fire();
                            this.createWillBankingDetail(component, event, helper);
                        }
                    }
                    else if (state === "ERROR"){
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                        var emessage = '"Submission Failed in creating Will Drafting Debit Order Instruction : "'+response;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    } 
                    component.set("v.showSpinner", false);
                });
                $A.enqueueAction(action);
            }
            else{
                component.set("v.showSpinner", false);
                this.createWillBankingDetail(component, event, helper);
            }
        }   
        else{
            //Create Will Drafting  Banking details Already called  
            //Calling function to create safe custody fees.
            component.set("v.showSpinner", false);
            this.createWillBankingDetail(component, event, helper);
        }
    },
    
    createWillBankingDetail : function (component, event, helper) {
        console.log("createWillBankingDetail");
        this.showSpinner(component);
        var createWillBankingRecordCreated=component.get("v.application.Will_Banking_Detail_Created__c");
        var createWillBankingRecord=component.get("v.application.Safe_Custody_Is_Required__c");
        console.log("createWillBankingRecord" + createWillBankingRecord);
        if(createWillBankingRecord === 'Yes' ) {
            if(createWillBankingRecordCreated === false) { //already created Will banking details for SCF -(Dupicate checks)
                var oppId = component.get("v.recordId");
                var willNo=component.get("v.asset.SerialNumber");
                var action = component.get("c.createWillBankingDetail");
                action.setParams({
                    "oppId": oppId,
                    "willNoP": willNo
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    var Response = response.getReturnValue();
                    if (state === "SUCCESS") {
                        if(Response==='Success'){
                            var emessage = '"Will Banking Detail created Successfully"';
                            var toastEvent = this.getToast("Success", emessage, "Success");
                            toastEvent.fire();
                            this.updateWillToCIF(component, event, helper);
                        }else if(Response === 'AlreadyExists'){
                            var emessage = '"Will Banking Detail created Already"';
                            var toastEvent = this.getToast("Success", emessage, "Success");
                            toastEvent.fire();
                            this.updateWillToCIF(component, event, helper);
                        }else  {
                            var emessage = '"Failed in Creating Will Banking Details for safe custody "';
                            var toastEvent = this.getToast("Error!", emessage, "Error");
                            toastEvent.fire();
                            $A.get('e.force:refreshView').fire();
                            component.set("v.showValidated",true);
                        }
                    }
                    else if (state === "ERROR"){
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                        var emessage = '"Submission Failed in creating Will Banking detail : "'+response;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }
                    component.set("v.showSpinner", false);
                });
                $A.enqueueAction(action);
            }
            else{
                component.set("v.showSpinner", false);
                this.updateWillToCIF(component, event, helper);
            }
        }   
        else if(createWillBankingRecord === 'No'){
            //Safe custody Banking details is not required to captured  
            //Calling function to Update To CIF.
            component.set("v.showSpinner", false);
            this.updateWillToCIF(component, event, helper);
        }
    },
    
    updateWillToCIF : function (component, event, helper) {
        console.log("updateWillToCIF");
        this.showSpinner(component);
        var checkUpdateToCIF=component.get("v.application.Will_Update_To_CIF__c");
        console.log("checkUpdateToCIF" + checkUpdateToCIF);
        if(checkUpdateToCIF === false ) {
            var oppId = component.get("v.recordId");            
            var action = component.get("c.updateWillToCIF");
            var clientCode = component.get("v.account.CIF__c");     
            var accountNo= component.get("v.asset.SerialNumber");   //Will Number
            var siteAccOpen='3232';  //or 8198
            var tellerNo= '1469';
            var product='WILL';
            var srcOfFnds2= '';
            var srcOfFnds3='';
            var srcOfFnds4='';
            var srcOfFnds5='';
            var sec129DeliveryAddr='1';
            action.setParams({
                "oppId": oppId,
                "clientCodeP" : clientCode,
                "accountNoP" : accountNo,
                "siteAccOpenP" : siteAccOpen,
                "tellerNoP" : tellerNo,
                "productP" : product,
                "srcOfFnds2P" : srcOfFnds2,
                "srcOfFnds3P" : srcOfFnds3,
                "srcOfFnds4P" : srcOfFnds4,
                "srcOfFnds5P" : srcOfFnds5,
                "sec129DeliveryAddrP" : sec129DeliveryAddr
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                var Response = response.getReturnValue();
                if (state === "SUCCESS") {
                    if(Response==='Success'){
                        var emessage = '"Will Updated In CIF Successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.sendWillRegisteredComm(component, event, helper);
                    }else {
                        var emessage = '"Failed To Update A Will In CIF System : "'+Response;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }
                }
                else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission Failed in Updating a WILL in CIF .Plese Try Again .. Error : "'+errors+response;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                } 
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
        else{
            //Update to CIF done   
            //Calling function to create Tracker after registration .
            component.set("v.showSpinner", false);
            this.sendWillRegisteredComm(component, event, helper);
        }
    },
    
    sendWillRegisteredComm : function (component, event, helper) {
        console.log("sendWillRegisteredComm");
        var now = new Date();
        this.showSpinner(component);
        var checkSendComm=component.get("v.application.Will_Communication_Sent__c");
        console.log("checkSendComm" + checkSendComm);
        if(checkSendComm === false ) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.sendWillRegCommunication"); 
            action.setParams({
                "oppId": oppId
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var message = response.getReturnValue();
                    if(message == 'Success'){
                        var emessage = '"Communication sent successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.createAssetNLiabilities(component, event, helper);
                    } else{
                        var emessage = '"Communication failed due to : "'+message;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                    }
                } else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }                    
                    var emessage = '"Submission Failed in sending Communication after Registration : "'+errors;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                } 
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
        else{
            component.set("v.showSpinner", false);
            this.createAssetNLiabilities(component, event, helper);
        }
    },
    
    createAssetNLiabilities : function (component, event, helper) {
        console.log("createAssetNLiabilities");
        this.showSpinner(component);
        var createAssetLiabilities=component.get("v.application.Will_Asset_Liabilities_Created__c");
        console.log("createAssetLiabilities" + createAssetLiabilities);
        if(createAssetLiabilities === false ) {
            var oppId = component.get("v.recordId");
            var willNoP= component.get("v.asset.SerialNumber");
            var action = component.get("c.createAssetLiabilities"); 
            action.setParams({
                "oppId" : oppId,
                "willNoP" : willNoP
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var Response = response.getReturnValue();
                if (state === "SUCCESS") {
                    if(Response==='Success'){
                        var emessage = '"Asset and Liabilities is Created Successfully After Registration"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.createTrackerafterRegistration(component, event, helper);
                    }else {          
                        var emessage = '"Failed to create asset and liabilities After Registration : "'+Response;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }
                }
                else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission Failed in create asset and liabilities after Registration : "'+errors;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                } 
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
        else{
            //tracker create after registraion  
            //Calling function to createasset and liabilities .
            component.set("v.showSpinner", false);
            this.createTrackerafterRegistration(component, event, helper);
        }
    },
    
    createTrackerafterRegistration  : function (component, event, helper) {
        console.log("createTrackerafterRegistration");
        this.showSpinner(component); 
        var createTrackerAfReg=component.get("v.application.Will_Registration_Tracker_Created__c");
        var RegistrationStatus=component.get("v.application.Registration_Status__c");
        console.log("createTrackerAfReg" + createTrackerAfReg);
        console.log("RegistrationStatus" + RegistrationStatus);
        if(createTrackerAfReg === false && RegistrationStatus !='Submitted') {
            var oppId = component.get("v.recordId");
            var channel = 'WILLS';
            var application = 'WILLS';
            var willNo=component.get("v.asset.SerialNumber");
            var tstatus = 'D';
            var sstatus = 'AR';
            var statCd = 'ARkcdxiqbsmyglenftph';
            var filLoc = '';
            var prevId = '';
            var actionP = 'Registration Information';
            var comments = '';
            var branchCd = '3232'; //if Lucy =7283 else default 3232
            var action = component.get("c.createRegistrationTracker");
            action.setParams({
                "oppId": oppId,
                "channel" : channel,
                "application" : application,
                "willNo" : willNo,
                "tstatus" : tstatus,
                "sstatus" : sstatus,
                "statCd" : statCd,
                "filLoc" : filLoc,
                "prevId" : prevId,
                "actionP" : actionP,
                "comments" : comments,
                "branchCd" : branchCd,
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                var Response = response.getReturnValue();
                if (state === "SUCCESS") {
                    if(Response==='Success'){
                        var emessage = '"Tracker is Created Successfully After Registration"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        component.set("v.RegistrationErrorMessages",'');
                        component.set("v.showRegistrationFailedError",false);
                        component.set("v.showFinishedScreen",true); 
                        component.set("v.showValidated",false);
                        component.set("v.showRegistrationStart",false);
                        component.set("v.showSpinner", false);
                        $A.get('e.force:refreshView').fire();
                    }else {
                        var emessage = '"Failed to create Tracker After Registration : "'+Response;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }
                }
                else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission Failed in Creating Tracker After Registration : "'+response;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
        else{
            //All steps done Show Finished screen
            component.set("v.showPreviousValidationFailed",false); 
            component.set("v.showFinishedScreen",true); 
            component.set("v.showValidated",false);
            component.set("v.showSpinner", false); 
        } 
    },
    
    /***************************************************   REVISION START **************************************************************/
    
    revisionDebitOrderInstruction : function (component, event, helper) {
        console.log("revisionDebitOrderInstruction");
        this.showSpinner(component);
        var revsionDebitOrderInstruction=component.get("v.application.Fees_Waived__c");
        var revsionDebitOrderInstructionFeeStaff=component.get("v.application.Fee_For_Staff__c");
        var revsionDebitOrderInstructionFeeEstate=component.get("v.application.Fee_For_Estate_Provider_Plan__c");
        var revisiondBInstructionCreated = component.get("v.application.Revision_Drafting_Banking_Detail_Created__c");
        if(revsionDebitOrderInstruction === false && revsionDebitOrderInstructionFeeEstate === false && revsionDebitOrderInstructionFeeStaff === false){
            if(revisiondBInstructionCreated === false) { //already created debitorderInstruction for drafting -(Dupicate checks)
                var oppId = component.get("v.recordId");
                var willNo=component.get("v.asset.SerialNumber");
                var action = component.get("c.revisionDebitOrderInstruction");
                action.setParams({
                    "oppId": oppId,
                    "willNoP": willNo
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    var Response = response.getReturnValue();
                    if (state === "SUCCESS") {
                        if(Response==='Success'){
                            var emessage = '"Will Drafting Debit Order Instruction Created Successfully"';
                            var toastEvent = this.getToast("Success", emessage, "Success");
                            toastEvent.fire();
                            this.revisionGetWillBankingDetail(component, event, helper);
                        }else if(Response==='BranchPaymentDone') {
                            var emessage = '"Will Drafting Debit Order Instruction Created Successfully in branch"';
                            var toastEvent = this.getToast("Success", emessage, "Success");
                            toastEvent.fire();
                            this.revisionGetWillBankingDetail(component, event, helper);
                        }
                    }
                    else if (state === "ERROR"){
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                        var emessage = '"Submission Failed in creating Will Drafting Debit Order Instruction : "'+response;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    } 
                });
                $A.enqueueAction(action);
            }
            else{
                this.revisionGetWillBankingDetail(component, event, helper);
            }
            component.set("v.showSpinner", false); 
        }   
        else{
            //Create Will Drafting  Banking details Already called  
            //Calling function to create safe custody fees.
            component.set("v.showSpinner", false); 
            this.revisionGetWillBankingDetail(component, event, helper);            
        }
    },
    
    revisionGetWillBankingDetail : function (component, event, helper) {
        console.log("revisionGetWillBankingDetail");
        this.showSpinner(component);
        var revisionCheckSCFRequired=component.get("v.application.Safe_Custody_Is_Required__c");
        console.log("revisionCheckSCFRequired" + revisionCheckSCFRequired);
        if(revisionCheckSCFRequired === 'Yes' ) { //Safe Custody is required
            var oppId = component.get("v.recordId");
            var willNo=component.get("v.asset.SerialNumber");
            var action = component.get("c.revisionGetWillBankingDetail");
            action.setParams({
                "oppId": oppId,
                "willNoP": willNo,
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                var getWillBankingDetailResponse = response.getReturnValue();
                if (state === "SUCCESS") {
                    if(getWillBankingDetailResponse == 'Success'){
                        var emessage = '"Will Banking detail SCF Fetched  Successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.revisionUpdateWillBankingDetail(component, event, helper);
                    }else {
                        
                        this.revisionCreateWillBankingDetail(component, event, helper);
                    }
                }
                else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission Failed Fetching Will Banking detail SCF : "'+errors;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                }
                component.set("v.showSpinner", false); 
            });
            $A.enqueueAction(action);
            
        }
        else if(revisionCheckSCFRequired === 'No'){
            //Safe custody Banking details is not required to captured  
            //Calling function TO create Asset and Liabilities
            component.set("v.showSpinner", false); 
            this.revisionCreateAssetNLiabilities(component, event, helper);
        }
    },
    
    revisionUpdateWillBankingDetail : function (component, event, helper) {
        console.log("revisionUpdateWillBankingDetail");
        this.showSpinner(component); 
        var oppId = component.get("v.recordId");
        var willNo=component.get("v.asset.SerialNumber");
        var action = component.get("c.revisionUpdateWillbankingDetail");
        action.setParams({
            "oppId": oppId,
            "willNoP": willNo,
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            var getWillDetailResponse = response.getReturnValue();
            if (state === "SUCCESS") {
                if(getWillDetailResponse =='Success'){
                    var emessage = '"Will Banking Details SCF updated Successfully"';
                    var toastEvent = this.getToast("Success", emessage, "Success");
                    toastEvent.fire();
                    this.revisionCreateAssetNLiabilities(component, event, helper);
                }else {
                    var emessage = '"Failed to Update Will Banking Details SCF : "'+getWillDetailResponse;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                }
            }
            else if (state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var emessage = '"Submission Failed to update Will Banking Details SCF. Please Try Again... : "'+errors;
                var toastEvent = this.getToast("Error!", emessage, "Error");
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                component.set("v.showValidated",true);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    revisionCreateWillBankingDetail : function (component, event, helper) {
        console.log("revisionCreateWillBankingDetail");
        this.showSpinner(component);
        var revisionCreateWillBankingCreated=component.get("v.application.Revision_Will_Banking_Detail_Created__c");
        console.log("revisionCreateWillBankingCreated" + revisionCreateWillBankingCreated);
        if(revisionCreateWillBankingCreated === false) { //already created Will banking details for SCF -(Dupicate checks)
            var oppId = component.get("v.recordId");
            var willNo=component.get("v.asset.SerialNumber");
            var action = component.get("c.revisionCreateWillBankingDetail");
            action.setParams({                    
                "oppId": oppId,
                "willNoP": willNo
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var Response = response.getReturnValue();
                if (state === "SUCCESS") {
                    if(Response==='Success'){
                        var emessage = '"Will Banking Detail SCF created Successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.revisionCreateAssetNLiabilities(component, event, helper);
                    }else  {
                        var emessage = '"Failed in Creating Will Banking Details SCF"';
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }
                }
                else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission Failed in creating Will Banking detail SCF : "'+response;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
        else{
            component.set("v.showSpinner", false);
            this.revisionCreateAssetNLiabilities(component, event, helper);
        }
    },
    
    revisionCreateAssetNLiabilities : function (component, event, helper) {
        console.log("revisionCreateAssetNLiabilities");
        this.showSpinner(component);
        var oppId = component.get("v.recordId");
        var willNoP= component.get("v.asset.SerialNumber");
        var action = component.get("c.revisionCreateAssetLiabilities"); 
        action.setParams({
            "oppId" : oppId,
            "willNoP" : willNoP
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var Response = response.getReturnValue();
            if (state === "SUCCESS") {
                if(Response==='Success'){
                    var emessage = '"Asset and Liabilities are Created Successfully"';
                    var toastEvent = this.getToast("Success", emessage, "Success");
                    toastEvent.fire();
                    this.revisionGetWillDetail(component, event, helper);
                }else {          
                    var emessage = '"Failed to create asset and liabilities : "'+Response;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                }
            }
            else if (state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var emessage = '"Submission Failed in create asset and liabilities  : "'+errors;
                var toastEvent = this.getToast("Error!", emessage, "Error");
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                component.set("v.showValidated",true);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    revisionGetWillDetail : function (component, event, helper) {
        console.log("revisionGetWillDetail");
        this.showSpinner(component);
        var oppId = component.get("v.recordId");
        var willNo=component.get("v.asset.SerialNumber");
        var action = component.get("c.revisionGetAssetFromWillSystem");
        action.setParams({
            "oppId": oppId,
            "willNoP": willNo,
        }); 
        action.setCallback(this, function(response) {             
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.getResponse",response.getReturnValue());
                this.revisionUpdateWillDetails(component, event, helper);
            }
            else if (state === "ERROR"){
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
            component.set("v.showSpinner", false);
        });        
        $A.enqueueAction(action);
    },
    
    revisionUpdateWillDetails  : function (component, event, helper) {
        console.log("revisionUpdateWillDetails");
        this.showSpinner(component);
        var RevisionCheckUpdateWill=component.get("v.application.Revision_Will_Update__c");
        if(RevisionCheckUpdateWill === false) {
            var oppId = component.get("v.recordId");
            var willNo=component.get("v.asset.SerialNumber");
            var action = component.get("c.revisionUpdateWill");
            action.setParams({
                "oppId" : oppId,
                "willNoP" : willNo,
                "revisionGetWillResponse1" : component.get("v.getResponse"),
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                var UpdateWillResponse = response.getReturnValue();
                if (state === "SUCCESS") {
                    if(UpdateWillResponse =='Success'){
                        var emessage = '"Will Record Updated Successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.revisionSendWillRegisteredComm(component, event, helper);
                    }else {
                        var emessage = '"Communication failed due to  : "'+UpdateWillResponse;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }
                }
                else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    var emessage = '"Submission Failed Updating Will Record From Will System.Plese Try Again  : "'+errors;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }   
        else{
            component.set("v.showSpinner", false);
            this.revisionSendWillRegisteredComm(component, event, helper);
        }
    },
    
    revisionSendWillRegisteredComm : function (component, event, helper) {
        console.log("revisionSendWillRegisteredComm");
        this.showSpinner(component);
        var checkSendComm=component.get("v.application.Will_Communication_Sent__c");
        console.log("checkSendComm" + checkSendComm);
        if(checkSendComm === false ) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.sendWillRegCommunication"); 
            action.setParams({
                "oppId": oppId
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var message = response.getReturnValue();
                    if(message == 'Success'){
                        var emessage = '"Communication sent successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.revisionCreateTrackerApp(component, event, helper);
                    } else{
                        var emessage = '"Communication failed due to  : "'+message;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                    }
                } else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission Failed in sending Communication after Registration : "'+errors;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                } 
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
        else{
            component.set("v.showSpinner", false);
            this.revisionCreateTrackerApp(component, event, helper);
        }
    },
    
    revisionCreateTrackerApp  : function (component, event, helper) {
        console.log("revisionCreateTrackerApp");
        this.showSpinner(component);
        var RevisionCheckAppTracker=component.get("v.application.Revision_Registration_AppTracker_Created__c");
        if(RevisionCheckAppTracker === false) {
            var oppId = component.get("v.recordId");
            var channel = 'WILLS';
            var application = 'WILLS';
            var willNo=component.get("v.asset.SerialNumber");
            var tstatus = 'D';
            var sstatus = 'A';
            var statCd = 'Arkcdxiqbsmyglenftph';
            var filLoc = '';
            var prevId = '';
            var actionP = 'Application Received';
            var comments = '';
            var branchCd = '3232'; //if Lucy =7283 else default 3232
            var action = component.get("c.revisionCreateRegistrationTrackerApplication");
            action.setParams({
                "oppId": oppId,
                "channel" : channel,
                "application" : application,
                "willNo" : willNo,
                "tstatus" : tstatus,
                "sstatus" : sstatus,
                "statCd" : statCd,
                "filLoc" : filLoc,
                "prevId" : prevId,
                "actionP" : actionP,
                "comments" : comments,
                "branchCd" : branchCd,
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                var Response = response.getReturnValue();
                if (state === "SUCCESS") {
                    if(Response==='Success'){
                        var emessage = '"Application Tracker is Created Successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        this.revisionCreateTracker(component, event, helper);
                    }else {
                        var emessage = '"Failed to create Application Tracker : "'+Response;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }
                }
                else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission Failed in Creating Application Tracker : "'+response;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }   
        else{
            component.set("v.showSpinner", false);
            this.revisionCreateTracker(component, event, helper);
        } 
    },
    
    revisionCreateTracker  : function (component, event, helper) {
        console.log("revisionCreateTracker");
        this.showSpinner(component);
        var revisionCreateTrackerAfReg=component.get("v.application.Revision_Registration_Tracker_Created__c");
        var revisionRegistrationStatus=component.get("v.application.Registration_Status__c");
        console.log("revisionCreateTrackerAfReg" + revisionCreateTrackerAfReg);
        console.log("revisionRegistrationStatus" + revisionRegistrationStatus);
        if(revisionCreateTrackerAfReg === false && revisionRegistrationStatus !='Submitted') {
            var oppId = component.get("v.recordId");
            var channel = 'WILLS';
            var application = 'WILLS';
            var willNo=component.get("v.asset.SerialNumber");
            var tstatus = 'D';
            var sstatus = 'AR';
            var statCd = 'ARkcdxiqbsmyglenftph';
            var filLoc = '';
            var prevId = '';
            var actionP = 'Registration Information';
            var comments = '';
            var branchCd = '3232'; //if Lucy =7283 else default 3232
            var action = component.get("c.revisionCreateRegistrationTracker");
            action.setParams({
                "oppId": oppId,
                "channel" : channel,
                "application" : application,
                "willNo" : willNo,
                "tstatus" : tstatus,
                "sstatus" : sstatus,
                "statCd" : statCd,
                "filLoc" : filLoc,
                "prevId" : prevId,
                "actionP" : actionP,
                "comments" : comments,
                "branchCd" : branchCd,
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                var Response = response.getReturnValue();
                if (state === "SUCCESS") {
                    if(Response==='Success'){
                        var emessage = '"Tracker is Created Successfully"';
                        var toastEvent = this.getToast("Success", emessage, "Success");
                        toastEvent.fire();
                        component.set("v.RegistrationErrorMessages",'');
                        component.set("v.showRegistrationFailedError",false);
                        component.set("v.showFinishedScreen",true); 
                        component.set("v.showValidated",false);
                        component.set("v.showRegistrationStart",false);
                        $A.get('e.force:refreshView').fire();
                    }else {
                        var emessage = '"Failed to create Tracker" : '+Response;
                        var toastEvent = this.getToast("Error!", emessage, "Error");
                        toastEvent.fire();	
                        $A.get('e.force:refreshView').fire();
                        component.set("v.showValidated",true);
                    }
                }
                else if (state === "ERROR"){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    var emessage = '"Submission Failed in Creating Tracker" : '+response;
                    var toastEvent = this.getToast("Error!", emessage, "Error");
                	toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.set("v.showValidated",true);
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
        else{
            component.set("v.showPreviousValidationFailed",false); 
            component.set("v.showFinishedScreen",true); 
            component.set("v.showValidated",false);
            component.set("v.showSpinner", false);
        } 
    },
    
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    getToast : function(title, msg, type) {        
        var toastEvent = $A.get("e.force:showToast");        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        }); 
        console.log('toastEvent : '+'title : '+title+' - message : '+msg+' - type : '+type);
        return toastEvent;
    }
})