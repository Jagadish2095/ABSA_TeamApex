({
    getAppPrdctCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppProdctCpfRec");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appPrdctCpfRec = response.getReturnValue();
                console.log("appPrdctCpfRecId 3: " + JSON.stringify(appPrdctCpfRec));
                component.set("v.appPrdctCpfRec", appPrdctCpfRec);
                if(appPrdctCpfRec.Gap_insurance__c	 != '' && appPrdctCpfRec.Gap_insurance__c!= null ){
                    component.set("v.gapinsurance", appPrdctCpfRec.Gap_insurance__c);
                }
                if(appPrdctCpfRec.Early_termination_fee__c	 != '' && appPrdctCpfRec.Early_termination_fee__c!= null ){
                    component.set("v.EarlyTerminationFee", appPrdctCpfRec.Early_termination_fee__c);
                }
                if(appPrdctCpfRec.Gap_insurance__c	 != '' && appPrdctCpfRec.Gap_insurance__c!= null ){
                    component.set("v.gapinsurance", appPrdctCpfRec.Gap_insurance__c);
                }
                if(appPrdctCpfRec.Conversion_options__c	 != '' && appPrdctCpfRec.Conversion_options__c!= null ){
                    component.set("v.showConversionField", appPrdctCpfRec.Conversion_options__c);
                }
                if(appPrdctCpfRec.Repayment_options__c	 != '' && appPrdctCpfRec.Repayment_options__c!= null ){
                    component.set("v.repaymentoptions", appPrdctCpfRec.Repayment_options__c);
                }
                 if(appPrdctCpfRec.Conversion_options__c	 != '' && appPrdctCpfRec.Conversion_options__c!= null ){
                    component.set("v.showConversionField", appPrdctCpfRec.Conversion_options__c);
                }
               if(appPrdctCpfRec.Prime_rate_margin__c != null &&  appPrdctCpfRec.Prime_rate_margin__c !=''){
                component.set("v.marginRate", appPrdctCpfRec.Prime_rate_margin__c );
            }
            if(appPrdctCpfRec.Interest_rate_basis__c != null && appPrdctCpfRec.Interest_rate_basis__c != '' ){
                component.set("v.interestratebasis", appPrdctCpfRec.Interest_rate_basis__c);
            }


                
            } else {
                console.log("Failed with state: " + JSON.stringify(appPrdctCpfRec));
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    AddOtherFeesAfterConversion : function(component, event) {
        var feesafterconversiondetails = component.get("v.newFeesAfterConnversion");
        feesafterconversiondetails.push({
            'sobjectType' : 'Application_Fees__c',
        });
        component.set("v.newFeesAfterConnversion",feesafterconversiondetails);   
    },
    AddOtherConditionsAfterConversion: function(component, event) {
        var conditionsafterconversiondetails = component.get("v.newConditionsAfterConnversion");
        conditionsafterconversiondetails.push({
            'sobjectType' : 'Application_Contract_Clause__c',
        });
        component.set("v.newConditionsAfterConnversion",conditionsafterconversiondetails);   
    },
    
    updateAppPrdctcpf: function(component, event, helper) { 
        var conversion,totalfacilimitonamenddate,finalrepaydateafterconversion,numofperiods,term,
            interestpayday,interestbasis,netmargin,allinriskmargin,fixedrateperiod,primeratemargin,
            margin,flexifee,earlyTermFeeYr1,earlyTermFeeYr2,earlyTermFeeYr3,earlyTermFeeFurtherYrs,
            repaymentoptions,instalmentperiods,interestservicefreq,instalamt,interestonlyperiods,
            startingsteppedinstal,escalatingper,numberofperiods,finalinstalamt,equalinstalments;
        if(component.find("conversion") == undefined){
            conversion=null;
        }else{
            conversion = component.find("conversion").get("v.value");
        }
        if(component.find("totalfacilimitonamenddate") == undefined){
            totalfacilimitonamenddate=null;
        }else{
            totalfacilimitonamenddate = component.find("totalfacilimitonamenddate").get("v.value");
        }
        if(component.find("finalrepaydateafterconversion") == undefined){
            finalrepaydateafterconversion=null;
        }else{
            finalrepaydateafterconversion = component.find("finalrepaydateafterconversion").get("v.value");
        }
        if(component.find("numofperiods") == undefined){
            numofperiods=null;
        }else{
            numofperiods = component.find("numofperiods").get("v.value");
        }
        if(component.find("term") == undefined){
            term=null;
        }else{
            term = component.find("term").get("v.value");
        }
        if(component.find("interestpayday") == undefined){
            interestpayday=null;
        }else{
            interestpayday = component.find("interestpayday").get("v.value");
        }
        if(component.find("interestbasis") == undefined){
            interestbasis=null;
        }else{
            interestbasis = component.find("interestbasis").get("v.value");
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
        if(component.find("primeratemargin") == undefined){
            primeratemargin=null;
        }else{
            primeratemargin = component.find("primeratemargin").get("v.value");
        }
        if(component.find("margin") == undefined){
            margin=null;
        }else{
            margin = component.find("margin").get("v.value");
        }
        if(component.find("flexifee") == undefined){
            flexifee=null;
        }else{
            flexifee = component.find("flexifee").get("v.value");
        }
        if(component.find("earlyTermFeeYr1") == undefined){
            earlyTermFeeYr1=null;
        }else{
            earlyTermFeeYr1 = component.find("earlyTermFeeYr1").get("v.value");
        }
        if(component.find("earlyTermFeeYr2") == undefined){
            earlyTermFeeYr2=null;
        }else{
            earlyTermFeeYr2 = component.find("earlyTermFeeYr2").get("v.value");
        }
        if(component.find("earlyTermFeeYr3") == undefined){
            earlyTermFeeYr3=null;
        }else{
            earlyTermFeeYr3 = component.find("earlyTermFeeYr3").get("v.value");
        }
        if(component.find("earlyTermFeeFurtherYrs") == undefined){
            earlyTermFeeFurtherYrs=null;
        }else{
            earlyTermFeeFurtherYrs = component.find("earlyTermFeeFurtherYrs").get("v.value");
        }
        if(component.find("repaymentoptions") == undefined){
            repaymentoptions=null;
        }else{
            repaymentoptions = component.find("repaymentoptions").get("v.value");
        }
        if(component.find("instalmentperiods") == undefined){
            instalmentperiods=null;
        }else{
            instalmentperiods = component.find("instalmentperiods").get("v.value");
        }
        if(component.find("interestservicefreq") == undefined){
            interestservicefreq=null;
        }else{
            interestservicefreq = component.find("interestservicefreq").get("v.value");
        }
        if(component.find("instalamt") == undefined){
            instalamt=null;
        }else{
            instalamt = component.find("instalamt").get("v.value");
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
        if(component.find("numberofperiods") == undefined){
            numberofperiods=null;
        }else{
            numberofperiods = component.find("numberofperiods").get("v.value");
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


        var appProductcpf = new Object();
        appProductcpf.conversion = conversion;
        appProductcpf.totalfacilimitonamenddate= totalfacilimitonamenddate;
        appProductcpf.finalrepaydateafterconversion= finalrepaydateafterconversion;
        appProductcpf.numofperiods= numofperiods;
        appProductcpf.term= term;
        appProductcpf.interestpayday=interestpayday;
        appProductcpf.interestbasis= interestbasis;
        appProductcpf.netmargin= netmargin;
        appProductcpf.allinriskmargin= allinriskmargin; 
        appProductcpf.fixedrateperiod= fixedrateperiod;
        appProductcpf.primeratemargin= primeratemargin;
        appProductcpf.margin= margin;
        appProductcpf.flexifee= flexifee;
        appProductcpf.gapinsurance= component.get('v.gapinsurance');
        appProductcpf.newFeesAfterConnversion= component.get('v.newFeesAfterConnversion');
        appProductcpf.newConditionsAfterConnversion= component.get('v.newConditionsAfterConnversion');
        appProductcpf.EarlyTerminationFee= component.get('v.EarlyTerminationFee');
        appProductcpf.earlyTermFeeYr1= earlyTermFeeYr1;
        appProductcpf.earlyTermFeeYr2= earlyTermFeeYr2;
        appProductcpf.earlyTermFeeYr3= earlyTermFeeYr3;
        appProductcpf.earlyTermFeeFurtherYrs= earlyTermFeeFurtherYrs;
        appProductcpf.repaymentoptions= repaymentoptions;
        appProductcpf.instalmentperiods= instalmentperiods;
        appProductcpf.interestservicefreq= interestservicefreq;
        appProductcpf.instalamt=instalamt;
        appProductcpf.interestonlyperiods=interestonlyperiods;
        appProductcpf.startingsteppedinstal=startingsteppedinstal;
        appProductcpf.escalatingper=escalatingper;
        appProductcpf.numberofperiods=numberofperiods;
        appProductcpf.finalinstalamt=finalinstalamt;
        appProductcpf.equalinstalments=equalinstalments;
        var action = component.get("c.updateAppPrdctcpf");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "objData": JSON.stringify(appProductcpf),
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                console.log("generalinfo ="+JSON.stringify(oppRec));
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
            // this.hideSpinner(component);
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },
    
    getAppOtherFeesRec :function(component, event, helper) {
        var action = component.get("c.getApplicationFeesRec");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appFeesRec = response.getReturnValue();
                console.log("newOtherfees: " + JSON.stringify(appFeesRec));
                component.set("v.newFeesAfterConnversion",response.getReturnValue());
                
            }else {
                console.log("Failed with state: " + JSON.stringify(appFeesRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    getAppConClauseCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppContractClauseRec");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
            "type":'Conversion'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                //debugger;
                var appConClauseRec = response.getReturnValue();
                console.log("newConditionsAfterConnversion: " + JSON.stringify(appConClauseRec));
                component.set("v.newConditionsAfterConnversion",response.getReturnValue());
                
            }else {
                console.log("Failed with state: " + JSON.stringify(appConClauseRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    
})