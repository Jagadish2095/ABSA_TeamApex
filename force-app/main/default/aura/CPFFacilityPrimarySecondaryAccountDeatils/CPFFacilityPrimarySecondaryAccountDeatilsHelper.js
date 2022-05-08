({
getAppPrdctCpfRec :function(component, event, helper) {
    var action = component.get("c.getAppProdctCpfRec");
    action.setParams({
        "oppId": component.get("v.recordId"),
    });
    
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS"){
            var appPrdctCpfRecId = response.getReturnValue();
            console.log("appPrdctCpfRecId: " + JSON.stringify(appPrdctCpfRecId));
            component.set("v.appPrdctCpfRec", appPrdctCpfRecId);
            if(appPrdctCpfRecId.Secondary_Account_Applicable__c == 'No' ){
                component.set("v.secondaryaccoptionGiven", 'N');
                component.set("v.showFacilityAndRepayment", 'No');
            }else if(appPrdctCpfRecId.Secondary_Account_Applicable__c == 'Yes' ){
                component.set("v.secondaryaccoptionGiven", 'Y');
                component.set("v.showFacilityAndRepayment",'Yes');
            }
            if(appPrdctCpfRecId.Include_repayment_schedule__c == 'Yes' ){
                component.set("v.IncluderepaymentscheduleoptionGiven", 'Y');
            }else if(appPrdctCpfRecId.Include_repayment_schedule__c == 'No' ){
                component.set("v.IncluderepaymentscheduleoptionGiven", 'N');
            }
            if(appPrdctCpfRecId.Final_repayment_date__c != null && appPrdctCpfRecId.Final_repayment_date__c != '' ){
                component.set("v.finalRepaymentDate", appPrdctCpfRecId.Final_repayment_date__c);
            }
            if(appPrdctCpfRecId.Prime_rate_margin__c != null &&  appPrdctCpfRecId.Prime_rate_margin__c !=''){
                component.set("v.marginRate", appPrdctCpfRecId.Prime_rate_margin__c );
            }
            if(appPrdctCpfRecId.Interest_rate_basis__c != null && appPrdctCpfRecId.Interest_rate_basis__c != '' ){
                component.set("v.interestratebasis", appPrdctCpfRecId.Interest_rate_basis__c);
            }
            if(appPrdctCpfRecId.Repayment_options__c!=null && appPrdctCpfRecId.Repayment_options__c!='' ){
                    component.set("v.repaymentoptions", appPrdctCpfRecId.Repayment_options__c);
            }
            var wasadesktopvaluationdone = appPrdctCpfRecId.Was_a_desktop_valuation_done__c;
            if (wasadesktopvaluationdone == "No"){
                component.set("v.renderfield", true);
            }   
            else{
                component.set("v.renderfield", false);
            }
            
        }else {
            console.log("Failed with state: " + JSON.stringify(appPrdctCpfRecId));
        }
    });
    
    $A.enqueueAction(action);
},


updateFacilityRepaymentcpf : function(component, event, helper) {
    //this.showSpinner(component);
    var margin,Instalmentamount,numberofperiodsfrstdrawn,interestonlyperiods,startingsteppedinstal;
    var dateofFinalrepayment,escalatingper,instalmentperiods,Interestservicefreq;
    var numberofPeriodsMonths,finalinstalamt;
    var netmargin,allinriskmargin,fixedrateperiod,primeratemargin,initialinstalmentamount,equalinstalments;
    var IncluderepaymentscheduleoptionGiven =component.get("v.IncluderepaymentscheduleoptionGiven"); 
    if(component.find("margin") == undefined){
        margin=null;
    }else{
        margin = component.find("margin").get("v.value");
    }
    if(component.find("dateofFinalrepayment") == undefined){
        dateofFinalrepayment=null;
    }else{
        dateofFinalrepayment = component.find("dateofFinalrepayment").get("v.value");
    }
    if(component.find("numberofPeriodsMonths") == undefined){
        numberofPeriodsMonths=null;
    }else{
        numberofPeriodsMonths = component.find("numberofPeriodsMonths").get("v.value");
    }
    if(component.find("primeratemargin") == undefined){
        primeratemargin=null;
    }else{
        primeratemargin = component.find("primeratemargin").get("v.value");
    }

    if(component.find("netmargin") == undefined){
        netmargin=null;
    }else{
        netmargin = component.find("netmargin").get("v.value");
    }
    if(component.find("allinriskmargin") == undefined){
        allinriskmargin=null;
    }else{
        allinriskmargin = component.find("allinriskmargin").get("v.value");
    }
    if(component.find("fixedrateperiod") == undefined){
        fixedrateperiod=null;
    }else{
        fixedrateperiod = component.find("fixedrateperiod").get("v.value");
    }
    if(component.find("Instalmentamount") == undefined){
        Instalmentamount=null;
    }else{
        Instalmentamount = component.find("Instalmentamount").get("v.value");
    }
    if(component.find("numberofperiodsfrstdrawn") == undefined){ 
        numberofperiodsfrstdrawn=null;
    }else{
        numberofperiodsfrstdrawn = component.find("numberofperiodsfrstdrawn").get("v.value");
    }
    if(component.find("interestonlyperiods") == undefined){
        interestonlyperiods=null;
    }else{
        interestonlyperiods = component.find("interestonlyperiods").get("v.value");
    }
    if(component.find("startingsteppedinstal") == undefined){
        startingsteppedinstal=null;
    }else{
        startingsteppedinstal = component.find("startingsteppedinstal").get("v.value");
    }
    if(component.find("escalatingper") == undefined){
        escalatingper=null;
    }else{
        escalatingper = component.find("escalatingper").get("v.value");
    }
    if(component.find("instalmentperiods") == undefined){
        instalmentperiods=null;
    }else{
        instalmentperiods = component.find("instalmentperiods").get("v.value");
    }
    if(component.find("Interestservicefreq") == undefined){
        Interestservicefreq=null;
    }else{
        Interestservicefreq = component.find("Interestservicefreq").get("v.value");
    }
    if(component.find("finalinstalamt") == undefined){
        finalinstalamt=null;
    }else{
        finalinstalamt = component.find("finalinstalamt").get("v.value");
    }
    if(component.find("equalinstalments") == undefined){
        equalinstalments=null;
    }else{
        equalinstalments = component.find("equalinstalments").get("v.value");
    }
         
   
    var secondaryaccoptionGiven =component.get("v.secondaryaccoptionGiven");
    var repaymentoptions=component.get("v.repaymentoptions");
    console.log(component.get("v.repaymentoptions"));
    var action = component.get("c.updateFacilityRepaymentsec");
    action.setParams({
        "recId" : component.get("v.appPrdctCpfRec.Id"),
        "secondaryaccoptionGiven" : secondaryaccoptionGiven,
        "interestratebasis" : component.get("v.interestratebasis"),
        "repaymentoption"   : repaymentoptions ,
        "primeratemargin" : primeratemargin,
        "margin" : margin,
        "IncluderepaymentscheduleoptionGiven" : IncluderepaymentscheduleoptionGiven,
        "Instalmentamount" : Instalmentamount,
        //"Instalmentamount":initialinstalmentamount,
        "numberofperiodsfrstdrawn" : numberofperiodsfrstdrawn,
        "term" : component.find("term").get("v.value"),
        "finalrepaymentdate" : component.find("finalrepaymentdate").get("v.value"),
        "dateofFinalrepayment" : dateofFinalrepayment,
        "numberofPeriodsMonths" : numberofPeriodsMonths,
        "netmargin":netmargin,
        "allinriskmargin":allinriskmargin,
        "fixedrateperiod":fixedrateperiod,
        "interestonlyperiods":interestonlyperiods,
        "startingsteppedinstal":startingsteppedinstal,
        "escalatingper":escalatingper,
        "instalmentperiods":instalmentperiods,
        "Interestservicefreq":Interestservicefreq,
        "finalinstalamt":finalinstalamt,
        "equalinstalments":equalinstalments
        
    });
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
        var state = response.getState();
        
        if (state === "SUCCESS"){
            var appCPFRec = response.getReturnValue();
            console.log('oppRec'+JSON.stringify(appCPFRec));
            component.set("v.showSpinner", false);
            this.refresh(component);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type":"success",
                "message": "Application Product CPF record updated Successfully"
            });
            toastEvent.fire();
            
        } else if (state === "ERROR") {
            var errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    console.log("Error message: " +errors[0].message);
                }
            }else{
                console.log("Unknown error");
            }
        }
        component.set("v.showSpinner", false);
        // this.hideSpinner(component);
    });
    $A.enqueueAction(action);
    
},
InsertPrimaryRepaymentReqcpf : function(component, event, helper) {
    var margin,primaryinstalmentamt,numberofperiodsfrstdrawn,interestonlyperiods,startingsteppedinstal;
    var dateofFinalrepayment,escalatingper,instalmentperiods,Interestservicefreq;
    var numberofPeriodsMonths,finalinstalamt;
    var netmargin,allinriskmargin,fixedrateperiod,primeratemargin,primaryequalinstalments;
    var IncluderepaymentscheduleoptionGiven =component.get("v.IncluderepaymentscheduleoptionGiven"); 
    if(component.find("primarymargin") == undefined){
        margin=null;
    }else{
        margin = component.find("primarymargin").get("v.value");
    }
    if(component.find("primarydateofFinalrepayment") == undefined){
        dateofFinalrepayment=null;
    }else{
        dateofFinalrepayment = component.find("primarydateofFinalrepayment").get("v.value");
    }
    if(component.find("primarynumberofPeriodsMonths") == undefined){
        numberofPeriodsMonths=null;
    }else{
        numberofPeriodsMonths = component.find("primarynumberofPeriodsMonths").get("v.value");
    }
    if(component.find("primaryprimeratemargin") == undefined){
        primeratemargin=null;
    }else{
        primeratemargin = component.find("primaryprimeratemargin").get("v.value");
    }
    if(component.find("netmargin") == undefined){
        netmargin=null;
    }else{
        netmargin = component.find("netmargin").get("v.value");
    }
    if(component.find("allinriskmargin") == undefined){
        allinriskmargin=null;
    }else{
        allinriskmargin = component.find("allinriskmargin").get("v.value");
    }
    if(component.find("fixedrateperiod") == undefined){
        fixedrateperiod=null;
    }else{
        fixedrateperiod = component.find("fixedrateperiod").get("v.value");
    }
    if(component.find("primarynumberofperiodsfrstdrawn") == undefined){
        numberofperiodsfrstdrawn=null;
    }else{
        numberofperiodsfrstdrawn = component.find("primarynumberofperiodsfrstdrawn").get("v.value");
    }
    if(component.find("primaryinterestonlyperiods") == undefined){
        interestonlyperiods=null;
    }else{
        interestonlyperiods = component.find("primaryinterestonlyperiods").get("v.value");
    }
    if(component.find("primarystartingsteppedinstal") == undefined){
        startingsteppedinstal=null;
    }else{
        startingsteppedinstal = component.find("primarystartingsteppedinstal").get("v.value");
    }
    if(component.find("primaryescalatingper") == undefined){
        escalatingper=null;
    }else{
        escalatingper = component.find("primaryescalatingper").get("v.value");
    }
    if(component.find("primaryinstalmentperiods") == undefined){
        instalmentperiods=null;
    }else{
        instalmentperiods = component.find("primaryinstalmentperiods").get("v.value");
    }
    if(component.find("primaryinterestservicefreq") == undefined){
        Interestservicefreq=null;
    }else{
        Interestservicefreq = component.find("primaryinterestservicefreq").get("v.value");
    }
    if(component.find("primaryfinalinstalamt") == undefined){
        finalinstalamt=null;
    }else{
        finalinstalamt = component.find("primaryfinalinstalamt").get("v.value");
    }
       if(component.find("primaryinstalmentamount") == undefined){
        primaryinstalmentamt=null;
    }else{
        primaryinstalmentamt = component.find("primaryinstalmentamount").get("v.value");
    }
     if(component.find("primaryequalinslament") == undefined){
        primaryequalinstalments=null;
    }else{
        primaryequalinstalments = component.find("primaryequalinslament").get("v.value");
    }
    var action = component.get("c.insertPrimaryRepaymentsection");
    action.setParams({
        "recId" : component.get("v.recordId"),
        "secondaryaccoption":component.get("v.secondaryaccoptionGiven"),
        "interestratebasis" : component.get("v.interestratebasis"), 
        "repaymentoption": component.get("v.repaymentoptions"),
        "primeratemargin" : primeratemargin,
        "margin" : margin,
        "IncluderepaymentscheduleoptionGiven" : IncluderepaymentscheduleoptionGiven,
        "Instalmentamount" : primaryinstalmentamt,
        "numberofperiodsfrstdrawn" :numberofperiodsfrstdrawn,// component.find("primarynumberofperiodsfrstdrawn").get("v.value"), 
        "term" : component.find("primaryterm").get("v.value"),
        "finalrepaymentdate" : component.find("primaryfinalrepaymentdate").get("v.value"),
        "dateofFinalrepayment" : dateofFinalrepayment,
        "numberofPeriodsMonths" : numberofPeriodsMonths,
        "Repaymenttype" : component.get("v.RepaymentType"),
        "netmargin":netmargin,
        "allinriskmargin":allinriskmargin,
        "fixedrateperiod":fixedrateperiod,
        "interestonlyperiods":interestonlyperiods,
        "startingsteppedinstal":startingsteppedinstal,
        "escalatingper":escalatingper,
        "instalmentperiods":instalmentperiods,
        "Interestservicefreq":Interestservicefreq,
        "finalinstalamt":finalinstalamt,
        "primaryequalinstalments":primaryequalinstalments,
        "appPrimaryRecId":component.get('v.appPrimaryRecId')


    });
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
        var state = response.getState();
        
        if (state === "SUCCESS"){
            var appRepCPFRec = response.getReturnValue();
            console.log('appRepCPFRec '+JSON.stringify(appRepCPFRec));
            component.set("v.showSpinner", false);
            //  this.refresh(component);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type":"success",
                "message": "Application Product CPF record updated Successfully"
            });
            toastEvent.fire();
            
        } else if (state === "ERROR") {
            var errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    console.log("Error message: " +errors[0].message);
                }
            }else{
                console.log("Unknown error");
            }
        }
        component.set("v.showSpinner", false);
        // this.hideSpinner(component);
    });
    $A.enqueueAction(action);
    
},


addNewSecondaryAccount : function(component, event) {
    
    var secondaryAcctRepayementlist = component.get("v.newSecondaryAcctRepaymentReq");
    secondaryAcctRepayementlist.push({
        'sobjectType' : 'Application_Repayment_Account_CPF__c',
        'Include_repayment_schedule__c':'No',
        'Prime_rate_margin__c' :'Plus per annum'
        
    });
    component.set("v.newSecondaryAcctRepaymentReq",secondaryAcctRepayementlist);  
    
},

InsertNewSecondaryAcctRepayementRecCpf : function(component, event, helper) {
    console.log('InsertNewSecondaryAcctRepayementRecCpf=='+JSON.stringify(component.get("v.newSecondaryAcctRepaymentReq")));
    console.log('isprimary'+component.get("v.isPrimary"));
    var action = component.get("c.InsertNewSecondaryAcctRepayementRecCpf");
    action.setParams({
        "recId" : component.get("v.recordId"),
        "secondaryAcctRepaymentlst" : component.get("v.newSecondaryAcctRepaymentReq"),
        "isPrimary" : component.get("v.isPrimary"),
        "secondaryaccoptionGiven":component.get("v.secondaryaccoptionGiven"),
        
        
    });
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
        var state = response.getState();
        
        if (state === "SUCCESS"){
            var oppRec = response.getReturnValue();
            console.log('oppRec---'+JSON.stringify(oppRec));
            if($A.util.isEmpty(oppRec)){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please Click on Add Secondary Account and give the Data before Save"
                });
                toastEvent.fire();
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application Secondary Account CPF record updated Successfully"
                });
                toastEvent.fire();} 
        } else if (state === "ERROR") {
            var errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    console.log("Error message: " +errors[0].message);
                }
            }else{
                console.log("Unknown error");
            }
        }
        // this.hideSpinner(component);
        component.set("v.showSpinner", false);
    });
    $A.enqueueAction(action);
    
},

getSecondaryAcctRepaymentRec :function(component, event, helper) {
    var action = component.get("c.getSecondaryAcctRepaymentRec");
    var oppRecId=component.get("v.recordId");
    
    action.setParams({
        "oppId": component.get("v.recordId"),
    });
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS"){
            var getSecondaryAcctRepaymentRec = response.getReturnValue();
            console.log("newSecondaryAcctRepaymentReq: " + JSON.stringify(getSecondaryAcctRepaymentRec));
            component.set("v.newSecondaryAcctRepaymentReq",getSecondaryAcctRepaymentRec);
        }else {
            console.log("Failed with state: " + JSON.stringify(getSecondaryAcctRepaymentRec));
        }
    });
    
    $A.enqueueAction(action);
}, 
getPrimaryAcctRepaymentRecord :function(component, event, helper) {
    var action = component.get("c.getPrimaryAcctRepaymentRec");
    var oppRecId=component.get("v.recordId");
    
    action.setParams({
        "oppId": component.get("v.recordId"),
    });
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS"){
            var getprimaryAcctRepaymentRec = response.getReturnValue();
            console.log("newPrimaryAcctRepaymentReq: " + JSON.stringify(getprimaryAcctRepaymentRec));
            if(getprimaryAcctRepaymentRec!= null ){
                component.set("v.appPrimaryRecId",getprimaryAcctRepaymentRec.Id);
                if(getprimaryAcctRepaymentRec.Final_repayment_date__c == 'Date' ){
                    component.set("v.finalRepaymentDate", 'Date');
                }else if(getprimaryAcctRepaymentRec.Final_repayment_date__c == 'after the date of first drawdown' ){
                    component.set("v.finalRepaymentDate", 'after the date of first drawdown');
                }else if(getprimaryAcctRepaymentRec.Final_repayment_date__c == 'after the Signature Date' ){
                    component.set("v.finalRepaymentDate", 'after the Signature Date');
                }
                if(getprimaryAcctRepaymentRec.Repayment_options__c!=null && getprimaryAcctRepaymentRec.Repayment_options__c!='' ){
                component.set("v.repaymentoptions", getprimaryAcctRepaymentRec.Repayment_options__c);
            }

            }
        }else {
            console.log("Failed with state: " + JSON.stringify(getprimaryAcctRepaymentRec));
        }
    });
    
    $A.enqueueAction(action);
},
refresh : function(component, event, helper) {
    var action = component.get('c.dummyRefresh');
    action.setCallback(component,
                        function(response) {
                            var state = response.getState();
                            if (state === 'SUCCESS'){
                                $A.get('e.force:refreshView').fire();
                            } else {
                                //do something
                            }
                        }
                        );
    $A.enqueueAction(action);
},
getopplineitemRec :function(component, event, helper) {
    var action = component.get("c.getprodName");
    var oppRecId=component.get("v.recordId");
    action.setParams({
        "oppId": component.get("v.recordId"),
    });
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS"){
            var getprodNamelst = response.getReturnValue();
            console.log(":getprodName " + JSON.stringify(getprodNamelst));
            component.set("v.prodName",getprodNamelst[0].Product_Name__c);
            
        }else {
            console.log("Failed with state: " + JSON.stringify(getprodNamelst));
        }
    });
    
    $A.enqueueAction(action);
},
    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }


})