({
    doInit: function(component, event, helper) {    
        helper.getAppPrdctCpfRec(component, event, helper);
        
        var securityclass=component.get("v.SecurityClass");

        if(securityclass =="New"){
            helper.getSecOffRecSubAgmtofLoanAccts(component, event, helper);
        }
        else if(securityclass =="Existing"){
            console.log('In getSecOffRecSubAgmtofLoanAcctsExist securityclass'+securityclass);
            helper.getSecOffRecSubAgmtofLoanAcctsExist(component, event, helper);
        } 
       
        if(securityclass =="New"){
           helper.getCrossDefaultClause(component, event, helper);
        }
        else if(securityclass =="Existing"){
            console.log('In getSecOffRecSubAgmtofLoanAcctsExist securityclass'+securityclass);
             helper.getCrossDefaultClauseExist(component, event, helper);
        } 

       if(securityclass =="New"){
                helper.getUndertakingtoinjectcostoverrunfunds(component, event, helper);
        }
        else if(securityclass =="Existing"){
            console.log('In getSecOffRecSubAgmtofLoanAcctsExist securityclass'+securityclass);
            helper.getUndertakingtoinjectcostoverrunfundsExist(component, event, helper);
        } 

        if(securityclass =="New"){
            helper.getSecOffRecCrossGuarantee(component, event, helper);
        }
        else if(securityclass =="Existing"){
            console.log('In cross gratunee exist securityclass'+securityclass);
            helper.getSecOffRecCrossGuaranteeExist(component, event, helper);
        } 
       if(securityclass =="New"){
             helper.getcrossCollSecurityofferedCpfRec(component, event, helper);
        }
        else if(securityclass =="Existing"){
              helper.getcrossCollSecurityExist(component, event, helper);

        } 
        helper.getopplineitemRec(component, event, helper);
        
        
    },
    
    handelsecurityproviderconsent : function(component, event, helper) {
        helper.updateAppPrdctcpf(component, event, helper);
    },
    SubordinationAgreementofLoanAccounts : function(component, event, helper) {
        var securityclass=component.get("v.SecurityClass");
        var SubordinationAgreementofLoanAccounts=component.get("v.SubordinationAgreementofLoanAccounts");
               
        if(SubordinationAgreementofLoanAccounts=='Yes' && securityclass=='New'){
            console.log('In NEw suboaggree'+SubordinationAgreementofLoanAccounts  +securityclass);
            if(component.find("claimsby").get("v.value") == '' ||component.find("CPAdocumentversion").get("v.value") == '' )
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
            }     else{
                          helper.insertSubAgreeforLoanAcct(component, event, helper);

            }
            
        }
        else if(SubordinationAgreementofLoanAccounts=='Yes' && securityclass=='Existing'){
                        console.log('In Existing suboaggree'+SubordinationAgreementofLoanAccounts  +securityclass);
            var dateegeg= component.find("dateRegistered").get("v.value") ;           
            console.log('In date suboaggree'+dateegeg );

            if(component.find("claimsby").get("v.value") == '' ||component.find("dateRegistered").get("v.value") == '' ||component.find("dateRegistered").get("v.value") == null )
            {  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
            }     else{
                    /*if(securityclass =="New"){
                          helper.insertSubAgreeforLoanAcct(component, event, helper);
                    }
                    else if(securityclass =="Existing"){ */
                        helper.insertSubAgreeforLoanAcctExist(component, event, helper);
                   // } 

            }
        }
        else{
                     if(securityclass =="New"){
                          helper.insertSubAgreeforLoanAcct(component, event, helper);
                    }
                    else if(securityclass =="Existing"){ 
                        helper.insertSubAgreeforLoanAcctExist(component, event, helper);
                    } 
                    } 
                   

        },
    Undertakingtoinjectcostoverrunfunds: function(component, event, helper) {
         var securityclass=component.get("v.SecurityClass");

        var Undertakingtoinjectcostoverrunfunds=component.get("v.Undertakingtoinjectcostoverrunfunds");
        
        if(Undertakingtoinjectcostoverrunfunds=='Yes' && securityclass=='New'){
            console.log('In NEw suboaggree'+Undertakingtoinjectcostoverrunfunds  +securityclass);
            if(component.find("whowillberesponsiblepay").get("v.value") == ''  )
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
            }     else{
                        helper.insertUndertakingtoinjectcostoverrunfunds(component, event, helper);

            }
            
        }
        else if(Undertakingtoinjectcostoverrunfunds=='Yes' && securityclass=='Existing'){
                        console.log('In Existing suboaggree'+Undertakingtoinjectcostoverrunfunds  +securityclass);
            var dateegeg= component.find("dateRegisteredunder").get("v.value") ;           
            console.log('In date suboaggree'+dateegeg );

            if(component.find("whowillberesponsiblepay").get("v.value") == '' ||component.find("dateRegisteredunder").get("v.value") == '' ||component.find("dateRegisteredunder").get("v.value") == null )
            {  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
            }     else{
                  
                        helper.insertUndertakingtoinjectcostoverrunfundsExist(component, event, helper);
                    //} 

            }
        }
        else{
                     if(securityclass =="New"){
                        helper.insertUndertakingtoinjectcostoverrunfunds(component, event, helper);
                    }
                    else if(securityclass =="Existing"){ 
                        helper.insertUndertakingtoinjectcostoverrunfundsExist(component, event, helper);
                    } 
                    } 
                   
        
    /*    if(Undertakingtoinjectcostoverrunfunds=='Yes'){
            if(component.find("whowillberesponsiblepay").get("v.value") == '' ){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
            }     else{
                   
                    if(securityclass =="New"){
                        helper.insertUndertakingtoinjectcostoverrunfunds(component, event, helper);
                    }
                    else if(securityclass =="Existing"){
                        helper.insertUndertakingtoinjectcostoverrunfundsExist(component, event, helper);
                    } 

            }
        }
         else{
                   
                    if(securityclass =="New"){
                        helper.insertUndertakingtoinjectcostoverrunfunds(component, event, helper);
                    }
                    else if(securityclass =="Existing"){
                        helper.insertUndertakingtoinjectcostoverrunfundsExist(component, event, helper);
                    } 

            } */
        
    },
    
    CrossDefaultClause: function(component, event, helper) {
          var securityclass=component.get("v.SecurityClass");

        var CrossDefaultClause=component.get("v.CrossDefaultClause");
        
        if(CrossDefaultClause=='Yes'){
            if(component.find("crossdefaultclauseparty").get("v.value") == '' ){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
            }     else{
                
                 if(securityclass =="New"){
                    helper.insertCrossDefaultClause(component, event, helper);
                    }
                    else if(securityclass =="Existing"){
                        helper.insertCrossDefaultClauseExist(component, event, helper);
                    } 

            }
        }else{
                
                 if(securityclass =="New"){
                    helper.insertCrossDefaultClause(component, event, helper);
                    }
                    else if(securityclass =="Existing"){
                        helper.insertCrossDefaultClauseExist(component, event, helper);
                    } 

            }
        
    },
    Crossguarantee: function(component, event, helper) {
        var securityclass=component.get("v.SecurityClass");
        console.log('securityclass'+securityclass);
        var Crossguarantee=component.get("v.Crossguarantee");
        var Includingcessionofclaimsandloanaccount=component.get("v.Includingcessionofclaimsandloanaccount");
        var cpfreleased=component.get("v.cpfreleased");
        var Crossguarantee=component.get("v.Crossguarantee");
        
        if(Crossguarantee=='Limited'){
            if(component.find("Amount").get("v.value") == '' || component.find("Amount").get("v.value") == undefined || Includingcessionofclaimsandloanaccount == '' || cpfreleased =='' ){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
            }else if(cpfreleased == 'Yes'){
                if(component.find("Inpwentorelease").get("v.value") == undefined || component.find("Inpwentorelease").get("v.value") == '' ||
                   component.find("InpreleaseCondtn").get("v.value") == undefined || component.find("InpreleaseCondtn").get("v.value") == ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "error!",
                        "type":"Error",
                        "message": "Please complete all required fields"
                    });
                    toastEvent.fire();
                }else{
                    if(securityclass =="New"){
                        helper.insertCrossguarantee(component, event, helper);
                    }
                    else if(securityclass =="Existing"){
                        helper.insertCrossguaranteeexist(component, event, helper);
                    } 
                    
                }
            }else{
                if(securityclass =="New"){
                    helper.insertCrossguarantee(component, event, helper);
                    
                }
                else if(securityclass =="Existing"){
                    console.log('In cross gratunee exist securityclass'+securityclass);
                    
                    helper.insertCrossguaranteeexist(component, event, helper);
                } 
                
            }
        }else if(Crossguarantee=='Unlimited'){
            if( Includingcessionofclaimsandloanaccount == '' || cpfreleased =='' ){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
            } else if(cpfreleased == 'Yes'){
                if(component.find("Inpwentorelease").get("v.value") == undefined || component.find("Inpwentorelease").get("v.value") == '' ||
                   component.find("InpreleaseCondtn").get("v.value") == undefined || component.find("InpreleaseCondtn").get("v.value") == ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "error!",
                        "type":"Error",
                        "message": "Please complete all required fields"
                    });
                    toastEvent.fire();
                }else{
                    if(securityclass =="New"){
                        helper.insertCrossguarantee(component, event, helper);
                    }
                    else if(securityclass =="Existing"){
                        helper.insertCrossguaranteeexist(component, event, helper);
                    } 
                    
                }
            } else{
                if(securityclass =="New"){
                    helper.insertCrossguarantee(component, event, helper);
                }
                else if(securityclass =="Existing"){
                    helper.insertCrossguaranteeexist(component, event, helper);
                } 
                
            }
        }else{
            if(securityclass =="New"){
                helper.insertCrossguarantee(component, event, helper);
            }
            else if(securityclass =="Existing"){
                helper.insertCrossguaranteeexist(component, event, helper);
            } 
        }  
    },
    
    handlecrossCollSubmit : function(component, event, helper) {
        var securityclass=component.get("v.SecurityClass");

        var crossCollOptionGiven =component.get("v.crossCollOptionGiven");
        var facilitiesoptiongiven = component.get("v.facilitiesoptiongiven") ;
        if(crossCollOptionGiven=='Yes'){
            if(component.find("inpsecprovided").get("v.value") == undefined ||component.find("inpsecprovided").get("v.value") == '' ||
               component.find("inpFacilities").get("v.value") == undefined || component.find("inpFacilities").get("v.value") == ''){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
            }else if(component.find("inpFacilities").get("v.value") == 'Insert specific facility detail'){
                if(component.find("Inpspecificdetails").get("v.value") == undefined || component.find("Inpspecificdetails").get("v.value") == ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "error!",
                        "type":"Error",
                        "message": "Please complete all required fields"
                    });
                    toastEvent.fire();
                }else{
                    if(securityclass =="New"){
                        helper.insertcrossCollateralisation(component, event, helper);
                    }
                    else if(securityclass =="Existing"){
                        helper.insertcrossCollateralisationExist(component, event, helper);
                    } 
                    
                }
            }else{
                if(securityclass =="New"){
                    helper.insertcrossCollateralisation(component, event, helper);
                }
                else if(securityclass =="Existing"){
                    helper.insertcrossCollateralisationExist(component, event, helper);
                } 
            }
            component.set("v.showSpinner", false);
        }else if(crossCollOptionGiven=='No'){
            if(securityclass =="New"){
                helper.insertcrossCollateralisation(component, event, helper);
            }
            else if(securityclass =="Existing"){
                helper.insertcrossCollateralisationExist(component, event, helper);
            } 
        }
        
    },
    crosscollhandleChange: function (component, event,helper) {
        var crosscollchangeValue = event.getParam("value");
        var crossCollOptionGiven = component.get("v.crossCollOptionGiven") ;
        if(crosscollchangeValue== 'N'){
            
            component.set("v.crossCollOptionGiven", 'N');
            component.set("v.showcrosscollsec", 'No');
        }
        else if(crosscollchangeValue=='Y'){
            
            component.set("v.crossCollOptionGiven", 'Y');
            component.set("v.showcrosscollsec",'Yes');
        }
    },
    showfacilitydetailfield: function (component, event,helper) {
        var facilitiesoptiongiven = component.find("inpFacilities").get("v.value");
        if(facilitiesoptiongiven== 'Insert specific facility detail'){
            component.set("v.showfacilitydetail", true);
        }
        else{
            component.set("v.showfacilitydetail", false);
        }
    },
    
})