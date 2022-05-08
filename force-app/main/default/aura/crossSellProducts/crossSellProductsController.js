({
    myAction : function(component, event, helper) {
      //default="0060E00000aIl8KQAS"
      //0060E00000aIw0aQAC  
    },
    
    doInit:function(component, event, helper) {
        
        component.set("v.raiderDetails",{});
        helper.fetchPickListValForRiderType(component,event);
        helper.fetchPickListValForIdType(component, event);
        helper.checkAccountValid(component,event);
        //helper.getOpportunitypartyDetails(component,event);
       
	   // helper.getOpportunityDetails(component,event);
        
    },

    validateSearchValueLength : function(component, event, helper){
        //Get Search value character size
            var searchValue = component.find("iSearchValue").get("v.value");
            var searchValueLength;

            if (searchValue != null) {
                searchValueLength = searchValue.length;

                //Set disable property
                if (searchValueLength > 1) {
                component.set("v.isNotValidSearchValue", false);
                } else {
                component.set("v.isNotValidSearchValue", true);
                }
            } else {
                component.set("v.isNotValidSearchValue", true);
            }
    },

    searchClient : function(component, event, helper){
        component.set("v.showSpinner",true);
        var searchValue = component.get("v.searchValue");
        var action = component.get("c.getAccountData");

        action.setParams({
            searchValue: searchValue 
          });
          action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var accountList = response.getReturnValue();
                if(accountList.length >0){
                let objTest =component.get("v.raiderDetails"); 
                //First_Name__c,Last_Name__c,Rider_Type__c,ID_Type__c,RSA_ID_Number__c,Date_of_Birth__c
                objTest.First_Name__c =accountList[0].FirstName;//component.get("v.opportunityDetails.Person_Account_First_Name__c");
                objTest.Last_Name__c =accountList[0].LastName;//component.get("v.opportunityDetails.Person_Account_Last_Name__c");
                objTest.DD_Cross_Sell_Product_Member_Type__c ='Rider Individual';
                objTest.ID_Type__c ='';
                objTest.RSA_ID_Number__c =accountList[0].ID_Number__pc;//component.get("v.opportunityDetails.ID_Number__c");
                objTest.Date_of_Birth__c =accountList[0].PersonBirthdate;//component.get("v.opportunityDetails");
                objTest.Gender__c =accountList[0].Gender__pc;//component.get("v.opportunityDetails.Person_Account_Gender__c");
                objTest.Opportunity__c=component.get("v.OpportunityFromFlow");

                component.set("v.raiderDetails",objTest);
                component.set("v.showNewPanelRider",true);
				component.set("v.searchValue",'');
                    component.set("v.showSpinner",false);
                    component.set("v.isNotValidSearchValue", true);
                }else{
                    component.set("v.searchValue",'');
                    component.set("v.showSpinner",false);
                    alert('No records found with the number');
                }
            }
          });
          $A.enqueueAction(action);
    },
    
    onPicklistselectedRiderTypeChange : function(component, event, helper) {
        var selctedValue = event.getSource().get("v.value") ;
        component.set("v.selectedRiderType",selctedValue);
        component.set("v.selectedCaptureResponse",'');
        component.set("v.showexistingFamilyOptions",false);
        //show yes or no picklist value
       // console.log('count'+component.get("v.riderIndCount"));
       // console.log('count faml'+component.get("v.riderfamCount"))
        if(selctedValue !='' && selctedValue =="Rider Individual"){
            if(component.get("v.riderIndCount") < 5){
              component.set("v.showraiderAsMainMemOption",true);
              component.set("v.CoverPremium",'15.00');
            } else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "You cannot add More than 5 Rider Individual.",
                    "type":"error"
                });
                toastEvent.fire();
                component.set("v.showraiderAsMainMemOption",false); 
                component.set("v.selectedRiderType",'');
            }
        }
        else if(selctedValue !='' && selctedValue =="Rider Family"){
            if(component.get("v.riderfamCount") < 5){
              component.set("v.showraiderAsMainMemOption",true);  
              component.set("v.CoverPremium",'20.00');
            } else{
                component.set("v.showraiderAsMainMemOption",false); 
                component.set("v.selectedRiderType",'');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "You cannot add More than 5 Rider Family.",
                    "type":"error"
                });
                toastEvent.fire();
            }  
        }
        else{
            component.set("v.showraiderAsMainMemOption",false);  //hiding if it is none
            component.set("v.showexistingFamilyOptions",false);
            component.set("v.selectedCaptureResponse",'');
        }
    },
    onPicklistselectedCaptureResponseChange : function(component, event, helper) {
       var selectedValue = event.getSource().get("v.value") ; 
        // component.set("v.selectedCaptureResponse", selctedValue);
        if(selectedValue != '' && selectedValue == 'Yes'){
            helper.generateFamilyPicklistOptions(component,event);
            component.set("v.showNewRiderButton",false);
            
        }
        else if(selectedValue != '' && selectedValue == 'No'){
            component.set("v.showNewRiderButton",true);
            component.set("v.selectedFamilyMemberResponse",'');
            component.set("v.showexistingFamilyOptions",false);
        }
        else if(selectedValue == ''){
            component.set("v.showexistingFamilyOptions",false);
            component.set("v.showNewRiderButton",false);
        }
    },
    
    onPicklistexistingFamilyOptionsChange :function(component,event,helper){
        var cntInd=component.get("v.riderIndCount");
        var cntFam=component.get("v.riderfamCount");
        var riderType=component.get("v.selectedRiderType");
        
        
        var selectedFamlyval = event.getSource().get("v.value") ;
        component.set("v.raiderDetails",{});
        let objTest =component.get("v.raiderDetails");
        var existingOppDetailMap = component.get("v.OpportunityPartyDetailsMap");
        var existedData = component.get("v.allBeneficiaries");
        var dupCheckArr = [];
        for(var i=0; i< existedData.length ;i++){
            if(existedData[i].Id){
                dupCheckArr.push(existedData[i].Id);
            }
        }
        //console.log('dupCheckArr '+dupCheckArr);
       // console.log('Dupcheck Id'+existingOppDetailMap[selectedFamlyval].Id);
            if(selectedFamlyval !='' && existingOppDetailMap != null && Object.keys(existingOppDetailMap).includes(selectedFamlyval) ){
                if(dupCheckArr.length >0 && dupCheckArr.includes(existingOppDetailMap[selectedFamlyval].Id)){
                     var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Record already added!!",
                            "type":"error"
                        });
                        toastEvent.fire();
                component.set("v.showexistingFamilyOptions",false);//hide family name options
                component.set("v.selectedRiderType",'');//
                component.set("v.raiderDetails",{});
                component.set("v.showraiderAsMainMemOption",false);
                component.set("v.selectedCaptureResponse",''); //setting yes no to empty
                component.set("v.selectedFamilyMemberResponse",'');//seeting family response to empty 
                }else{
                    if(riderType=="Rider Individual"){
                        cntInd=cntInd+1;
                        component.set("v.riderIndCount",cntInd);
                    }else if(riderType=="Rider Family"){
                        cntFam= cntFam+1
                        component.set("v.riderfamCount",cntFam);
                    }
                    
                objTest.Name=existingOppDetailMap[selectedFamlyval].First_Name__c+''+existingOppDetailMap[selectedFamlyval].Last_Name__c;
                objTest.First_Name__c =existingOppDetailMap[selectedFamlyval].First_Name__c;//component.get("v.opportunityDetails.Person_Account_First_Name__c");
                objTest.Last_Name__c =existingOppDetailMap[selectedFamlyval].Last_Name__c;//component.get("v.opportunityDetails.Person_Account_Last_Name__c");
                objTest.DD_Cross_Sell_Product_Member_Type__c =component.get("v.selectedRiderType");
                objTest.ID_Type__c =existingOppDetailMap[selectedFamlyval].ID_Type__c;
                objTest.RSA_ID_Number__c =existingOppDetailMap[selectedFamlyval].RSA_ID_Number__c;//component.get("v.opportunityDetails.ID_Number__c");
                objTest.Date_of_Birth__c =existingOppDetailMap[selectedFamlyval].Date_of_Birth__c;//component.get("v.opportunityDetails");
                objTest.Gender__c =existingOppDetailMap[selectedFamlyval].Gender__c;//component.get("v.opportunityDetails.Person_Account_Gender__c");
                objTest.Opportunity__c=component.get("v.OpportunityFromFlow");
                objTest.Id=existingOppDetailMap[selectedFamlyval].Id;
                objTest.Premium=component.get("v.CoverPremium");
                
                console.log('existedData yes'+JSON.stringify(existedData));
                if(existedData.length >0){
                    existedData.push(objTest);
                }else{
                    existedData=[];
                    existedData.push(objTest);
                }
                
                component.set("v.allBeneficiaries",existedData);
                component.set("v.showexistingFamilyOptions",false);//hide family name options
                component.set("v.selectedRiderType",'');//
                component.set("v.raiderDetails",{});
                component.set("v.showraiderAsMainMemOption",false);
                component.set("v.selectedCaptureResponse",''); //setting yes no to empty
                component.set("v.selectedFamilyMemberResponse",'');//seeting family response to empty
                console.log('befn '+JSON.stringify(component.get("v.allBeneficiaries")));
                component.set("v.isQuoteDone",false);//added to hide next button
            }//inner else
            }//outer if
        
    },
  
   	newRider: function(component, event) {
       component.set("v.raiderDetails",{});
        let objTest =component.get("v.raiderDetails");
        objTest.DD_Cross_Sell_Product_Member_Type__c=component.get("v.selectedRiderType");
        component.set("v.raiderDetails",objTest);
        component.set("v.showNewPanelRider", true);
	},
    cancelRider: function(component, event) {
        component.set("v.showNewPanelRider", false);
        component.set("v.showNewPanelRider", false);
           component.set("v.selectedCaptureResponse", '');//for hiding the Yes no response
           component.set("v.showNewRiderButton",false); //button hide fro individual
           component.set("v.selectedRiderType",'');//when family type details added making it as none
           component.set("v.showraiderAsMainMemOption",false); 
           component.set("v.selectedGenderValue",'');
           component.set("v.raiderDetails",{});
    },
                
   onPicklistGenderChange: function(component, event, helper) {
       component.set("v.raiderDetails.Gender__c", event.getSource().get("v.value"));         
   },
                    
	onPicklistselectedIdTypeChange : function(component, event, helper) {
            component.set("v.raiderDetails.ID_Type__c", event.getSource().get("v.value"));
     },    
	
    
   addRider : function(component,event,helper){
       var allValid= false;
       var formId ="riderForm";
       allValid= helper.validationCheck(component,allValid,formId);
       console.log(allValid);
       if(allValid){
           let objTest =component.get("v.raiderDetails");
           objTest.Opportunity__c=component.get("v.OpportunityFromFlow");
           objTest.Premium=component.get("v.CoverPremium");
           objTest.DD_Cross_Sell_Product_Member_Type__c=component.get("v.selectedRiderType");
           component.set("v.raiderDetails",objTest);
           var cntInd=component.get("v.riderIndCount");
           var cntFam=component.get("v.riderfamCount");
           var riderTypeCheck= component.get("v.raiderDetails").DD_Cross_Sell_Product_Member_Type__c;
          // console.log('riderTypeCheck '+riderTypeCheck);
           if(riderTypeCheck=="Rider Individual"){
               cntInd=cntInd+1;
               component.set("v.riderIndCount",cntInd);
           }else if(riderTypeCheck=="Rider Family"){
               cntFam= cntFam+1
               component.set("v.riderfamCount",cntFam);
           }
          // console.log('data '+JSON.stringify(component.get("v.raiderDetails")));
           var allBeneficiaryMap = component.get("v.allBeneficiariesMap");
           var existedData = component.get("v.allBeneficiaries");
           if(existedData.length >0){
               existedData.push(component.get("v.raiderDetails"));
           }else{
               existedData=[];
               existedData.push(component.get("v.raiderDetails"));
           }
           let selectedRiderType = component.get("v.selectedRiderType");
           let objectMap =$A.util.isEmpty(allBeneficiaryMap) ? {} : allBeneficiaryMap;
         //  console.log('objectMap '+JSON.stringify(objectMap));
          // console.log('inside if'+selectedRiderType);
           if( Object.keys(objectMap).includes(selectedRiderType)){
               var existingList=objectMap[selectedRiderType];
               existingList.push(component.get("v.raiderDetails"));
               objectMap[selectedRiderType]=existingList;
           }
           else{
               var dummyArray=[];
               dummyArray.push(component.get("v.raiderDetails"));
               objectMap[selectedRiderType]=dummyArray;
           }
           
           //console.log('***',objectMap);
           //console.log('intial map check '+JSON.stringify(component.get("v.allBeneficiariesMap")));
           component.set("v.allBeneficiariesMap",objectMap);
           component.set("v.allBeneficiaries",existedData);
           component.set("v.showNewPanelRider", false);
           component.set("v.selectedCaptureResponse", '');//for hiding the Yes no response
           component.set("v.showNewRiderButton",false); //button hide fro individual
           component.set("v.selectedRiderType",'');//when family type details added making it as none
           component.set("v.showraiderAsMainMemOption",false); 
           component.set("v.selectedGenderValue",'');
           component.set("v.raiderDetails",{});
           component.set("v.isQuoteDone",false);
       }
 },                     
                            
     removeDeletedRow: function(component, event, helper) {
        component.set("v.showSpinner",true);
         // get the selected row Index for remove, from Lightning Event Attribute  
         var index = event.getParam("indexVar");
         var allRowsList = component.get("v.allBeneficiaries");
         var deletedId;
         var deletedData=event.getParam("raiderDetails");
         allRowsList.splice(index, 1);
         var cntInd=component.get("v.riderIndCount");
         var cntFam=component.get("v.riderfamCount");
         var riderCheck = event.getParam("raiderDetails").DD_Cross_Sell_Product_Member_Type__c;
        // console.log('riderCheck '+riderCheck);
         //console.log('******'+JSON.stringify(event.getParam("raiderDetails")));
         if(event.getParam("raiderDetails").Id){
            deletedId=event.getParam("raiderDetails").Id;
             component.set("v.OpportunityPartyDetailsListDelete",event.getParam("raiderDetails"));
             //making a server call for delete if id exist
             var oppPartyData =component.get("v.allBeneficiaries");
             var oppPartyDeleteData =component.get("v.OpportunityPartyDetailsListDelete");
             //console.log('Delet '+JSON.stringify(oppPartyDeleteData));
             if(oppPartyDeleteData.length >0 ){
                 component.set("v.showSpinner",true);
                 var action = component.get("c.deleteOppPartyData");
                 action.setParams({
                     "oppPartyListdelete": oppPartyDeleteData,
                     "oppPartyId":event.getParam("raiderDetails").Id,
                     "roadCover":true,
                     "healthAssis":false
                 });
                 action.setCallback(this, function(a) {
                     var state = a.getState();
                     if (state === "SUCCESS") {
                        //var a = component.get('c.doInit');
                        //$A.enqueueAction(a);
                        
                        //Added 12 11 2020 by prnv
                        var check =false;
                        var existFamOpts =component.get("v.OpportunityPartyDetailsList");
                        for(var i = 0; i < existFamOpts.length; i++){
                            if(existFamOpts[i].Id == deletedId){
                                check= true;
                                break;
                            }
                            
                        }
                        if(check==false){
                            var oppPartyDetailsMap = {};//OpportunityPartyDetailsMap
                            delete deletedData.Premium;
                            existFamOpts.push(deletedData);    
                            component.set("v.OpportunityPartyDetailsList",existFamOpts);
                            oppPartyDetailsMap[deletedId]=deletedData;
                            component.set("v.OpportunityPartyDetailsMap",oppPartyDetailsMap); 
                        }
                        //end--

                         component.set("v.showSpinner",false);
                         var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "Rider Removed Successfully",
                            "type":"success"
                        });
                        toastEvent.fire();
                     }else{
                         console.log('Error '+JSON.stringify(a.getError()));
                         component.set("v.showSpinner",false);
                         var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "please try delete again",
                            "type":"error"
                        });
                        toastEvent.fire();
                     }
                 });
                 $A.enqueueAction(action);
             }
             
         }
         if(riderCheck =='Rider Individual'){
             cntInd = cntInd-1;
             component.set("v.riderIndCount",cntInd);
         }else if(riderCheck =='Rider Family'){
             cntFam = cntFam-1; 
             component.set("v.riderfamCount",cntFam);
         }
         component.set("v.selectedRiderType",'');
         
         component.set("v.showraiderAsMainMemOption",false);
         component.set("v.selectedCaptureResponse",''); //setting yes no to empty
         
         component.set("v.showexistingFamilyOptions",false);
         component.set("v.selectedFamilyMemberResponse",'');
         
         component.set("v.showNewRiderButton",false); 
         component.set("v.allBeneficiaries", allRowsList);
         component.set("v.showSpinner",false);
        
     },
         
    editRow :  function(component, event, helper) {
             var index = event.getParam("indexVar");
             component.set("v.indexVar",index);
             
             component.set("v.raiderDetails",event.getParam("raiderDetails"));
            if(component.get("v.raiderDetails").DD_Cross_Sell_Product_Member_Type__c=='Main Member'){
                component.set("v.disableField",true);
            }else{
               component.set("v.disableField",false); 
               
            }
          component.set("v.showUpdatePanelModal",true);
    },
        
    confrimAndClose : function(component, event, helper){ 
                 var allValid= false;
                 var formId ="updateForm";
                 allValid =helper.validationCheck(component,allValid,formId);
                 if(allValid){
                    component.set("v.isQuoteDone",false);//adedd on 12-11-2020
                     var index = component.get("v.indexVar");
                     console.log('index '+index);
                     var allRowsList = component.get("v.allBeneficiaries");
                     allRowsList.splice(index, 1,component.get("v.raiderDetails"));
                     //allRowsList.push(component.get("v.raiderDetails"));
                     component.set("v.allBeneficiaries", allRowsList);
                     component.set("v.showUpdatePanelModal", false);
                     component.set("v.raiderDetails",{});
                     console.log('data with all Modal' + JSON.stringify(component.get("v.allBeneficiaries")));
                 }
 },         
             
    closeConfirmation: function(component, event, helper) {
                     // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
                     component.set("v.showUpdatePanelModal", false);
    }, 
    
    handleChangePrev : function(component,event,helper){
           var actionClicked = event.getSource().getLocalId();
   			// Call that action
   			var navigate = component.getEvent("navigateFlowEvent");
   			navigate.setParam("action", actionClicked);
   			navigate.fire();
    },
    
    handleChangeNext :function(component,event,helper){
        
		var LabelName = event.getSource().get("v.label");
        var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
        if(quoteOutcome == '' || quoteOutcome == null){
             var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "please select Quote Outcome.",
                            "type":"error"
                        });
                        toastEvent.fire();
                return null;
        }
        else{
        if(LabelName == 'Quote'){
        	helper.saveOppPartyData(component,event,helper); 
        }else{
       	var actionClicked = event.getSource().getLocalId();
   	    // Call that action
   		var navigate = component.getEvent("navigateFlowEvent");
   		navigate.setParam("action", actionClicked);
        navigate.setParam("outcome", component.get("v.quoteStatus"));
   		navigate.fire();
        }
        }  
    },
    
   
                                            
})