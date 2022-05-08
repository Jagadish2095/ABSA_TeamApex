({
     fetchData: function(component) {
        var RecordId = component.get('v.recordId');
        var cifkey = component.get('v.cifkey');
        var getAccountInfo = component.get("c.getAccount");
        getAccountInfo.setParams({
            recordId : RecordId
        });
        getAccountInfo.setCallback(component, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var results = response.getReturnValue();
                //var results = result.split(',');
               component.set("v.firstName", results.Account.FirstName);
                component.set("v.lastName", results.Account.LastName);
                component.set("v.idNumber", results.Account.ID_Number__pc);
                component.set("v.emailAddress", results.Account.PersonEmail);
                component.set("v.cellphoneNumber", results.Account.PersonMobilePhone);
                if(results.OtherPhone!=null || results.OtherPhone!='' || results.OtherPhone!= undefined){
                    component.set("v.telephoneNumber", results.OtherPhone);
                }else{
                    component.set("v.telephoneNumber", '');
                }
                var ages = results.Account.Age__pc;
                var age = Math.trunc( ages );
                component.set("v.age", age);
                component.set("v.gender", results.Account.Gender__pc);
                component.set("v.dateofbirth",results.Account.PersonBirthdate);
                
            } else if (state == "ERROR") {
                var errors = response.getError();              
                component.find('branchFlowFooter').set('v.heading', 'Failed to get Account Information.');
                component.find('branchFlowFooter').set('v.message', errors[0].message);
                component.find('branchFlowFooter').set('v.showDialog', true);
            }
        });
        $A.enqueueAction(getAccountInfo);        
    },
    fetchData_Original: function(component) {
        var RecordId = component.get('v.recordId');
        var cifkey = component.get('v.cifkey');
        var MonthlyIncome=component.get('v.MonthlyIncome');
        var Smoker = component.get('v.Smoker');
        var InsuredAmount = component.get('v.InsuredAmount');
        var Education = component.get('v.education'); 
        var getQuoteInfo= component.get("c.getAbsaInstantLifeQuote");
        var self = this;
        if(InsuredAmount=='' && InsuredAmount==null){
            
        }
        getQuoteInfo.setParams({
            recordId : RecordId,
            InsuredAmount : InsuredAmount,
            Education : Education,
            IsSmoker :Smoker,
            MonthlyIncomeAmount:MonthlyIncome,
        });
        getQuoteInfo.setCallback(component, function(response) {            
            var state = response.getState();
            component.set('v.errorFree','no');
            if(state === "SUCCESS" && component.isValid()){
                var result = JSON.parse(response.getReturnValue());
                if(result.ValidationErrors.length <1 && (result.InsuredLineResults[0].StatusCode!='DEC' || result.InsuredLineResults[0].PremiumAmount!='') )
                {
                   // component.set('v.CanNavigate', true);
                    console.log('Insured amount' + result.InsuredLineResults[0].InsuredAmount);
                    component.set('v.InsuredAmount',result.InsuredLineResults[0].InsuredAmount);
                    component.set('v.PremiumAmount', result.InsuredLineResults[0].PremiumAmount);
                     component.set('v.InsuredAmount_Previous','0');
                    component.set('v.PremiumAmount_Previous','0');
                    component.set('v.InsuredAmount_Next','0');
                    component.set('v.PremiumAmount_Next', '0');
                    component.set('v.errorFree','yes');
                    var InsuredPAmount = component.get('v.InsuredAmount');
       				 InsuredPAmount= (Number(InsuredPAmount)- 1000000);
                     var InsuredNAmount=component.get('v.InsuredAmount');
                     InsuredNAmount=(Number(InsuredPAmount)+ 1000000);
                    if(InsuredAmount>=1000000)
                    {
                  	 self.fetchQuote_Previous(component);
                     }
                } 
                else {
                    if(result.ValidationErrors.length >=1 ){
                        component.set('v.CanNavigate', true);
                        component.find('branchFlowFooter').set('v.heading', 'Absa Instant Life Quote Submission.');
                        component.find('branchFlowFooter').set('v.message', result.ValidationErrors[0].Id +':  '+ result.ValidationErrors[0].Message );
                        component.find('branchFlowFooter').set('v.showDialog', true);
                        
                    }
                    else if(result.InsuredLineResults[0].StatusCode=='DEC' || result.InsuredLineResults[0].PremiumAmount=='') {
                        component.set('v.CanNavigate', true);
                        component.find('branchFlowFooter').set('v.heading', 'Absa Instant Life Quote Submission.');
                        component.find('branchFlowFooter').set('v.message', result.InsuredLineResults[0].StatusCode +':  '+'Quotation Declined');
                        component.find('branchFlowFooter').set('v.showDialog', true);
                       
                        
                    }
                        else if(state == "ERROR")
                        {
                            component.set('v.CanNavigate', true);
                            component.find('branchFlowFooter').set('v.heading', 'Absa Instant Life Quote Submission.');
                            component.find('branchFlowFooter').set('v.message', result.InsuredLineResults[0].StatusCode +':  '+'Quotation Declined');
                            component.find('branchFlowFooter').set('v.showDialog', true);
                           
                        }
                }
            }
           // component.set("v.showSpinner", false);
        });
        $A.enqueueAction(getQuoteInfo);
    },
    fetchQuote_Previous: function(component) {
        // component.set("v.showSpinner", true);
        var RecordId = component.get('v.recordId');
        var cifkey = component.get('v.cifkey');
        var MonthlyIncome=component.get('v.MonthlyIncome');
        var Smoker = component.get('v.Smoker');
        var Education = component.get('v.education'); 
        var getQuoteInfoPrevious= component.get("c.getAbsaInstantLifeQuote");
        var self = this;
        var InsuredAmount = component.get('v.InsuredAmount');
        InsuredAmount= (Number(InsuredAmount)- 1000000);
      
        getQuoteInfoPrevious.setParams({
            recordId : RecordId,
            InsuredAmount : InsuredAmount,
            Education : Education,
            IsSmoker :Smoker,
            MonthlyIncomeAmount:MonthlyIncome,
        });
        getQuoteInfoPrevious.setCallback(component, function(response) {            
            var state = response.getState();
            component.set('v.errorFree','no');
            if(state === "SUCCESS" && component.isValid()){
                var result = JSON.parse(response.getReturnValue());
               if(result.ValidationErrors.length <1 && (result.InsuredLineResults[0].StatusCode!='DEC' || result.InsuredLineResults[0].PremiumAmount!='') )
                {
                   // alert('Previous'+ result.InsuredLineResults[0].InsuredAmount)
                    //component.set('v.CanNavigate', true);
                    component.set('v.InsuredAmount_Previous',result.InsuredLineResults[0].InsuredAmount);
                    component.set('v.PremiumAmount_Previous', result.InsuredLineResults[0].PremiumAmount);
                    component.set('v.errorFree','yes');
                   
                    self.fetchQuote_Next(component);
                }
                    else {
                    if(result.ValidationErrors.length >=1 ){
                        component.set('v.CanNavigate', true);
                        component.find('branchFlowFooter').set('v.heading', 'Absa Instant Life Quote Submission.');
                        component.find('branchFlowFooter').set('v.message', result.ValidationErrors[0].Id +':  '+ result.ValidationErrors[0].Message );
                        component.find('branchFlowFooter').set('v.showDialog', true);
                       
                    }
                    else if(result.InsuredLineResults[0].StatusCode=='DEC' || result.InsuredLineResults[0].PremiumAmount=='') {
                        component.set('v.CanNavigate', true);
                        component.find('branchFlowFooter').set('v.heading', 'Absa Instant Life Quote Submission.');
                        component.find('branchFlowFooter').set('v.message', result.InsuredLineResults[0].StatusCode +':  '+'Quotation Declined');
                        component.find('branchFlowFooter').set('v.showDialog', true);
                       
                    }
                        else if(state == "ERROR")
                        {
                            component.set('v.CanNavigate', true);
                            component.find('branchFlowFooter').set('v.heading', 'Absa Instant Life Quote Submission.');
                            component.find('branchFlowFooter').set('v.message', result.InsuredLineResults[0].StatusCode +':  '+'Quotation Declined');
                            component.find('branchFlowFooter').set('v.showDialog', true);
                            
                        }
                }
                
            }
            
        });
        $A.enqueueAction(getQuoteInfoPrevious);
        
    },
    fetchQuote_Next: function(component) {
        // component.set("v.showSpinner", true);
        var RecordId = component.get('v.recordId');
        var cifkey = component.get('v.cifkey');
        var MonthlyIncome=component.get('v.MonthlyIncome');
        var Smoker = component.get('v.Smoker');
        var InsuredAmount = component.get('v.InsuredAmount');
        InsuredAmount =  (Number(InsuredAmount)+ 1000000);
        var Education = component.get('v.education'); 
        var getQuoteInfoNext= component.get("c.getAbsaInstantLifeQuote");
       
        getQuoteInfoNext.setParams({
            recordId : RecordId,
            InsuredAmount : InsuredAmount,
            Education : Education,
            IsSmoker :Smoker,
            MonthlyIncomeAmount:MonthlyIncome,
            
        });
        getQuoteInfoNext.setCallback(component, function(response) {            
            var state = response.getState();
            component.set('v.errorFree','no');
            if(state === "SUCCESS" && component.isValid()){
                var result =  JSON.parse(response.getReturnValue());
               if(result.ValidationErrors.length <1 && (result.InsuredLineResults[0].StatusCode!='DEC' || result.InsuredLineResults[0].PremiumAmount=='')) 
                {
                   //alert('next amount' + result.InsuredLineResults[0].InsuredAmount );
                    component.set('v.InsuredAmount_Next',result.InsuredLineResults[0].InsuredAmount);
                    component.set('v.PremiumAmount_Next', result.InsuredLineResults[0].PremiumAmount);
                    component.set('v.CanNavigate', true);
                    component.set('v.errorFree','yes');}
               
                 else {
                    if(result.ValidationErrors.length >=1 ){
                        component.set('v.CanNavigate', true);
                        component.find('branchFlowFooter').set('v.heading', 'Absa Instant Life Quote Submission.');
                        component.find('branchFlowFooter').set('v.message', result.ValidationErrors[0].Id +':  '+ result.ValidationErrors[0].Message );
                        component.find('branchFlowFooter').set('v.showDialog', true);
                       
                    }
                    else if(result.InsuredLineResults[0].StatusCode=='DEC' || result.InsuredLineResults[0].PremiumAmount=='') {
                        component.set('v.CanNavigate', true);
                        component.find('branchFlowFooter').set('v.heading', 'Absa Instant Life Quote Submission.');
                        component.find('branchFlowFooter').set('v.message', result.InsuredLineResults[0].StatusCode +':  '+'Quotation Declined');
                        component.find('branchFlowFooter').set('v.showDialog', true);
                       
                    }
                        else if(state == "ERROR")
                        {
                            component.set('v.CanNavigate', true);
                            component.find('branchFlowFooter').set('v.heading', 'Absa Instant Life Quote Submission.');
                            component.find('branchFlowFooter').set('v.message', result.InsuredLineResults[0].StatusCode +':  '+'Quotation Declined');
                            component.find('branchFlowFooter').set('v.showDialog', true);
                            
                        }
                }
                
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(getQuoteInfoNext);
        
    },
        
})