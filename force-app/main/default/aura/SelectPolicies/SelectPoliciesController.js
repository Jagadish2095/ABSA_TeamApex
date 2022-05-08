({
    
    next: function(component, event, helper) {
        var No_selectedPolicy = component.get("v.validateNextButton");
        var AstuteConsent = component.get("v.isCheckBoxTrueResponse");
        if(No_selectedPolicy>0 )// please add next button's logic inside this if block
        {
            alert("Next button clicked successfully");
            component.set("v.ShowResultOnNextScree",true)
        	component.set("v.open",false)
           
        }
    },
    selectedCheckBox: function(cmp, event, helper) {
        var checkCmp = cmp.find("currentCheckBox").get("v.label");
		
        //alert(event.getSource("v.label"));

    },
    
    getCasePolicies : function(component, event, helper) {
        component.set("v.isLoading", true);
        let action = component.get("c.getPolicyInfo");
        action.setParams({
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            component.set("v.isLoading", false);
            if(response.getState()==='SUCCESS'){
                let returnValue = response.getReturnValue();
                console.log('Get Policies : '+JSON.stringify(returnValue));
                component.set("v.PolicyList", returnValue.ClientPolicies);
                component.set("v.OtherPolicyList", returnValue.OtherPolicies);
                component.set("v.isCheckBoxTrueResponse", returnValue.Consent == 'Yes');
                
                let mainPolicyCount = 0;
                for(let policy of returnValue.ClientPolicies){
                    if(policy.selected){
                        mainPolicyCount++;
                    }
                }
                let otherPolicyCount = 0;
                for(let policy of returnValue.OtherPolicies){
                    if(policy.selected){
                        otherPolicyCount++;
                    }
                }
                component.set("v.mainPolicyCount", mainPolicyCount);
                component.set("v.isSelectAll", returnValue.ClientPolicies.length == mainPolicyCount && mainPolicyCount>0);
                component.set("v.otherPolicyCount", otherPolicyCount);
                component.set("v.isSelectAllOther", returnValue.OtherPolicies.length == otherPolicyCount && otherPolicyCount>0);
                component.set("v.validateNextButton", mainPolicyCount+otherPolicyCount);
                if((mainPolicyCount+otherPolicyCount)>0)
                {
                    var evt = $A.get("e.c:PolicySelectionEvent");
                    evt.setParam("check", false); 
                    evt.fire();
                }
                else
                {
                    var evt = $A.get("e.c:PolicySelectionEvent");
                    evt.setParam("check", true); 
                    evt.fire();
                }
            }
            else{
                
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    fetchPolicies : function(component, event, helper) {
       
        var caseId=component.get("v.recordId");
        var action = component.get("c.showPolicies");
       // var action = component.get("c.getPolicyDetails");
        action.setParams({"caseId":caseId
        });
        action.setCallback(this, function(result){
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                console.log("result.getReturnValue().CaseSupportIdList is :"+result.getReturnValue().CaseSupportIdList);
                console.log("result.getReturnValue().consent is: "+result.getReturnValue().consent);
                component.set("v.PolicyList",result.getReturnValue().CaseSupportIdList); 
                var x= component.get("v.PolicyList");
                console.log("PolicyList: "+x);
                 var isConsent = result.getReturnValue().consent; 
                console.log("result.getReturnValue().consent: "+isConsent);
                
        if(isConsent==="Yes"){
            component.set("v.isCheckBoxTrueResponse",true);
        }else if(isConsent==="No"){
            component.set("v.isCheckBoxTrueResponse",false);
        }
                
            }
        });
        $A.enqueueAction(action);      
    },
    
    fetchOtherPolicies : function(component, event, helper) {
      helper.fetchOtherPoliciesHelper(component, event, helper);
        
    },
    
    //Select all policies
    handleSelectAllPolicies: function(component, event, helper) {
        
        var getID = component.get("v.PolicyList");
        //var checkvalue = component.find("selectAll").get("v.value");   
        
        var checkvalue = component.get("v.isSelectAll");  
        console.log("checkvalue"+ checkvalue);
        var checkIndvPolicy = component.find("checkIndvPolicy"); 
        console.log("checkIndvPolicy"+checkIndvPolicy);
        var count=0;
        if(!checkIndvPolicy || checkIndvPolicy.length==0){
            component.set("v.isSelectAll", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "message": "No policies available!"
            });
            toastEvent.fire();
            return;
        }
        if(checkvalue === true){
            for(var i=0; i<checkIndvPolicy.length; i++){
                checkIndvPolicy[i].set("v.checked",true);
                 count++;
            }
            ////////////
            if(!Array.isArray(checkIndvPolicy)){                
                    checkIndvPolicy.set("v.checked",true);
                    count++;
                    console.log("Inside if when checked, count is: "+count);                
            }
            //////////
            //component.set("v.dsblBtn",false);
            component.set("v.isSelectAll",true);
            component.set("v.mainPolicyCount",count);
            var otherCount = component.get('v.otherPolicyCount');
            var totalCount = otherCount + count;
            component.set("v.validateNextButton",totalCount);
            var NoSeletedPolicies = component.get("v.validateNextButton");
            console.log("count is: "+NoSeletedPolicies);
        }
        else{ 
            for(var i=0; i<checkIndvPolicy.length; i++){
                checkIndvPolicy[i].set("v.checked",false);
            }
            if(!Array.isArray(checkIndvPolicy)){                
                    checkIndvPolicy.set("v.checked",false);
                    console.log("Inside if when unchecked, count is: "+count);                
            }
            //component.set("v.dsblBtn",true);
			component.set("v.isSelectAll",false);
            component.set("v.mainPolicyCount",0);
            var otherCount = component.get('v.otherPolicyCount');
            component.set("v.validateNextButton",otherCount);
            
             var NoSeletedPolicies = component.get("v.validateNextButton");
            console.log("count is: "+NoSeletedPolicies);
        }
        
        if(component.get("v.validateNextButton")>0)
        {
            //component.set("v.dsblBtn",false);
            var evt = $A.get("e.c:PolicySelectionEvent");
            evt.setParam("check", false); 
            evt.fire();
        }
        else
        {//component.set("v.dsblBtn",true);
            var evt = $A.get("e.c:PolicySelectionEvent");
            evt.setParam("check", true); 
            evt.fire();
        }
        //to store selected policies at back end
        var caseId=component.get("v.recordId");
        var action = component.get("c.addRemoveSelectedPolicyId");
        var SelectedPolicyID = '';
		var checkForAction;
		if(checkvalue === true)
            checkForAction='SelectAllMain';
        else
            checkForAction='RemoveAllMain';
        action.setParams({"caseid":caseId,"policyIds":SelectedPolicyID,"check":checkForAction,
                         });
        
        action.setCallback(this, function(result){
            component.set("v.isLoading", false);
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                console.log("SelectedRecordIds - result.getReturnValue(): "+result.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
        component.set("v.isLoading", true);
    },
    handleSelectAllOtherPolicies: function(component, event, helper) {
        
        var checkvalue = component.get("v.isSelectAllOther");  
        console.log("checkvalue"+ checkvalue);
        var checkIndvOtherPolicy = component.find("checkIndvOtherPolicy"); 
        console.log("checkIndvOtherPolicy"+checkIndvOtherPolicy);
        
        if(!checkIndvOtherPolicy || checkIndvOtherPolicy.length==0){
            component.set("v.isSelectAllOther", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "message": "No other policies available!"
            });
            toastEvent.fire();
            //return;
        }
        
        var count=0;
        if(checkvalue === true){
            for(var i=0; i<checkIndvOtherPolicy.length; i++){
                checkIndvOtherPolicy[i].set("v.checked",true);
                 count++;
            }
            if(!Array.isArray(checkIndvOtherPolicy)){                
                    checkIndvOtherPolicy.set("v.checked",true);
                    count++;
                    console.log("Inside if when checked, count is: "+count);                
            }
            //component.set("v.dsblBtn",false);
            component.set("v.otherPolicyCount",count);
            var mainCount = component.get('v.mainPolicyCount');
            var totalCount = mainCount + count;
            component.set("v.validateNextButton",totalCount);
            var NoSeletedPolicies = component.get("v.validateNextButton");
            console.log("count is: "+NoSeletedPolicies);
           
        }
        else{ 
            for(var i=0; i<checkIndvOtherPolicy.length; i++){
                checkIndvOtherPolicy[i].set("v.checked",false);
            }
            if(!Array.isArray(checkIndvOtherPolicy)){                
                    checkIndvOtherPolicy.set("v.checked",false);
                    console.log("Inside if when checked, count is: "+count);                
            }
            //component.set("v.dsblBtn",true);
            component.set("v.otherPolicyCount",0);
            var mainCount = component.get('v.mainPolicyCount');
            component.set("v.validateNextButton",mainCount);
             var NoSeletedPolicies = component.get("v.validateNextButton");
            console.log("count is: "+NoSeletedPolicies);
            }
        
        if(component.get("v.validateNextButton")>0)
        {
            //component.set("v.dsblBtn",false);
            var evt = $A.get("e.c:PolicySelectionEvent");
            evt.setParam("check", false); 
            evt.fire();
        }
        else
        {//component.set("v.dsblBtn",true);
            var evt = $A.get("e.c:PolicySelectionEvent");
            evt.setParam("check", true); 
            evt.fire();
        }
        //to store selected fields
        var caseId=component.get("v.recordId");
        var action = component.get("c.addRemoveSelectedPolicyId");
        var SelectedPolicyID = '';
		var checkForAction;
		if(checkvalue === true)
            checkForAction='SelectAllOther';
        else
            checkForAction='RemoveAllOther';
        action.setParams({"caseid":caseId,"policyIds":SelectedPolicyID,"check":checkForAction,
                         });
        
        action.setCallback(this, function(result){
            component.set("v.isLoading", false);
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                console.log("SelectedRecordIds - result.getReturnValue(): "+result.getReturnValue());
            }
        });
        $A.enqueueAction(action);    
        component.set("v.isLoading", true);
    },
    //Process the selected Policies
    handleSelectedPoliciesMain: function(component, event, helper) {
      
        var checkvalueMain = component.get("v.isSelectAll"); 
        console.log("checkvalueMain: "+ checkvalueMain); 
        if(checkvalueMain)
        {
            component.set("v.isSelectAll",false); 
        }
       /* var selectedPolicies = [];
        var checkvalue = component.find("checkIndvPolicy");
        console.log("checkvalue is: "+checkvalue);
        var count = component.get("v.validateNextButton");
        
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedPolicies.push(checkvalue.get("v.text"));
                count++;
                console.log("Inside if, count is: "+count);
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedPolicies.push(checkvalue[i].get("v.text"));
                    count++;
                    console.log("Inside else, count is: "+count);
                }
            }
        }
        
        console.log("count is: "+count);
        component.set("v.validateNextButton",count);
        if(component.get("v.validateNextButton")>0)
        {component.set("v.dsblBtn",false);}
        else
        {component.set("v.dsblBtn",true);}
        console.log('selectedPolicies-' + selectedPolicies); */
        
       /* code to make sure atleast one policy is selected */
        var SelectedPolicyID = event.getSource().get("v.name");
        console.log("SelectedPolicyID: "+SelectedPolicyID);
		var caseId=component.get("v.recordId");
        var action = component.get("c.addRemoveSelectedPolicyId");
        var checkForAction;
        
        var checkboxvalue = event.getSource().get("v.checked");
        console.log("val= "+checkboxvalue);
        
        var count = component.get("v.mainPolicyCount");
       // var count = component.get("v.validateNextButton");
        if(checkboxvalue === true)
        {checkForAction='Add';
         count++;}
        else
        {checkForAction='Remove';
         count=count-1;}
        component.set("v.mainPolicyCount",count);
        count = count + component.get("v.otherPolicyCount");
        console.log("count is: "+count);
        component.set("v.validateNextButton",count);
        if(component.get("v.validateNextButton")>0)
        {//component.set("v.dsblBtn",false);
            var evt = $A.get("e.c:PolicySelectionEvent");
            evt.setParam("check", false); 
            evt.fire();
        }
        else
        {//component.set("v.dsblBtn",true);
            var evt = $A.get("e.c:PolicySelectionEvent");
            evt.setParam("check", true); 
            evt.fire();
        }
		var SelectedPolicyID = event.getSource().get("v.name");
        action.setParams({"caseid":caseId,"policyIds":SelectedPolicyID,"check":checkForAction,
        });
        
        action.setCallback(this, function(result){
            component.set("v.isLoading", false);
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                console.log("SelectedRecordIds - result.getReturnValue(): "+result.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
        component.set("v.isLoading", true);
    },
    //Process The Selected Other Policies
    handleSelectedPoliciesOther: function(component, event, helper) {
        
        var checkvalue = component.get("v.isSelectAllOther"); 
        console.log("checkvalue: "+ checkvalue); 
        if(checkvalue)
        {
            component.set("v.isSelectAllOther",false); 
        }
        /*var selectedPolicies = [];
        var checkvalue = component.find("checkOtherPolicy");
        
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedPolicies.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedPolicies.push(checkvalue[i].get("v.text"));
                }
            }
        }
        console.log('selectedPolicies-' + selectedPolicies);*/
        
        /* code to make sure atleast one policy is selected */
        var checkboxvalue = event.getSource().get("v.checked");
        console.log("val= "+checkboxvalue);
        var checkForAction;
        //var count = component.get("v.validateNextButton");
        var count = component.get("v.otherPolicyCount");
        var AstuteConsent = component.get("v.isCheckBoxTrueResponse");
        if(AstuteConsent)
        {
            if(checkboxvalue === true)
            {checkForAction='Add';count++;}
            else
            {checkForAction='Remove';count=count-1;}
        }
        component.set("v.otherPolicyCount",count);
        count = count + component.get("v.mainPolicyCount");
        console.log("count is: "+count);
        component.set("v.validateNextButton",count);
        if(component.get("v.validateNextButton")>0)
        {
            //component.set("v.dsblBtn",false);
            var evt = $A.get("e.c:PolicySelectionEvent");
            evt.setParam("check", false); 
            evt.fire();
        }
        else
        {//component.set("v.dsblBtn",true);
            var evt = $A.get("e.c:PolicySelectionEvent");
            evt.setParam("check", true); 
            evt.fire();
        }
        var caseId=component.get("v.recordId");
        var action = component.get("c.addRemoveSelectedPolicyId");
        var SelectedPolicyID = event.getSource().get("v.name");
        action.setParams({"caseid":caseId,"policyIds":SelectedPolicyID,"check":checkForAction,
        });
        
        action.setCallback(this, function(result){
            component.set("v.isLoading", false);
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                console.log("SelectedRecordIds - result.getReturnValue(): "+result.getReturnValue());
            }
        });
        $A.enqueueAction(action);   
        component.set("v.isLoading", true);
        
    },
    callAppEventResponse :function(cmp, event, helper) { 
        //Get the event message attribute
        alert("application event handled!");
        var isConsent = event.getParam("isConsent"); 
        console.log("astute consent check"+isConsent);
        if(isConsent==="Yes"){
            cmp.set("v.isCheckBoxTrueResponse",true);
        }else if(isConsent==="No"){
            cmp.set("v.isCheckBoxTrueResponse",false);
        }
        
        //alert('ADD policy '+isCheckBoxTrue);
        console.log("this is val of isCheckBoxTrue: "+isCheckBoxTrue);
    },
    
    openModal : function(cmp, event, helper) { 
     
        let isCheckBoxTrueResponse=cmp.get("v.isCheckBoxTrueResponse");
        console.log("this is val of isCheckBoxTrue in open Modal: "+isCheckBoxTrueResponse);
        if(isCheckBoxTrueResponse){
             cmp.set("v.isModal",true);
            //cmp.set("v.showPopup",true);
        }
        if(!isCheckBoxTrueResponse){
            cmp.set("v.showPopup",true);
            //cmp.set("v.isModal",true);
        }
               
    },
    confirm : function(cmp, event, helper) {
        cmp.set("v.showPopup",false)
         cmp.set("v.isModal",true);
	},
    clodPopup : function(cmp, event, helper) { 
        cmp.set("v.showPopup",false)
    },
    closeModal : function(cmp, event, helper) { 
        
        cmp.set('v.isModal',false);
        //location.reload();
    }, 
    
    handleSuccess : function(cmp, event, helper) { 
         var param = event.getParams(); //get event params
        var fields = param.response.fields; //get all field info
       
	    
        console.log('Product_Name__c - ' + fields.Product_Name__c.value);
        //console.log('mycheckbox - ' + fields.Other_Policy__c.value);
        
        console.log('Record Created Successfully.');
        cmp.set('v.isModal',false);
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been created successfully.",
            "type":"success"
        });
            toastEvent.fire();
        }else{
            alert('The record has been Created successfully.')
        }
        //helper.fetchOtherPoliciesHelper(cmp, event, helper);
        $A.enqueueAction(cmp.get("c.getCasePolicies"));
        //location.reload();
               $A.get('e.force:refreshView').fire();

    },
    
    handleError : function(cmp, event, helper) { 
        
        console.log('Record not Created.');
        cmp.set('v.isModal',false);
        location.reload();
    }
})