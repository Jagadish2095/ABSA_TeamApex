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
                console.log("appPrdctCpfRecId 3: " + JSON.stringify(appPrdctCpfRecId));
                component.set("v.appPrdctCpfRec", appPrdctCpfRecId);
                if(appPrdctCpfRecId.Obligor_incorporated_outside_of_SA__c != '' && appPrdctCpfRecId.Obligor_incorporated_outside_of_SA__c != null ){
                    component.set("v.ObligorincorpoutsideofSAvalues", appPrdctCpfRecId.Obligor_incorporated_outside_of_SA__c);
                }
                if(appPrdctCpfRecId.Environmental_permits__c != '' && appPrdctCpfRecId.Environmental_permits__c !=null ){
                    component.set("v.Environmentalpermitsvalues", appPrdctCpfRecId.Environmental_permits__c );
                }
                if(appPrdctCpfRecId.Financial_assistance__c != '' && appPrdctCpfRecId.Financial_assistance__c !=null){
                    component.set("v.Financialassistancevalues", appPrdctCpfRecId.Financial_assistance__c);
                }
                if(appPrdctCpfRecId.Electrical_compliance_certificate__c != '' && appPrdctCpfRecId.Electrical_compliance_certificate__c!=null){
                    component.set("v.Electricalcompliancecertificatevalues", appPrdctCpfRecId.Electrical_compliance_certificate__c);
                }
                if(appPrdctCpfRecId.Newly_formed_company__c != '' && appPrdctCpfRecId.Newly_formed_company__c!=null ){
                    component.set("v.Newlyformedcompanyvalues", appPrdctCpfRecId.Newly_formed_company__c);
                }
                if(appPrdctCpfRecId.Pre_let__c != '' && appPrdctCpfRecId.Pre_let__c !=null ){
                    component.set("v.Preletvalues", appPrdctCpfRecId.Pre_let__c );
                }
                if(appPrdctCpfRecId.Pre_let_review__c != '' && appPrdctCpfRecId.Pre_let_review__c!=null){
                    component.set("v.Preletreviewvalues", appPrdctCpfRecId.Pre_let_review__c);
                }
                 if(appPrdctCpfRecId.Restraint_against_free_alienation_notari__c != '' && appPrdctCpfRecId.Restraint_against_free_alienation_notari__c!=null ){
                    component.set("v.Restraintagainstfreevalues", appPrdctCpfRecId.Restraint_against_free_alienation_notari__c);
                }
                 if(appPrdctCpfRecId.Notarially_Tied_Consolidation__c != '' && appPrdctCpfRecId.Notarially_Tied_Consolidation__c!=null ){
                    component.set("v.NotariallyTiedConsolidationValues", appPrdctCpfRecId.Notarially_Tied_Consolidation__c);
               } 
                if(appPrdctCpfRecId.Performance_Guarantees__c != '' && appPrdctCpfRecId.Performance_Guarantees__c!=null ){
                    component.set("v.performanceguaramtees", appPrdctCpfRecId.Performance_Guarantees__c);
               }
                if(appPrdctCpfRecId.Is_Section_82_Certificate__c != '' && appPrdctCpfRecId.Is_Section_82_Certificate__c!=null ){
                    component.set("v.sectioncerti", appPrdctCpfRecId.Is_Section_82_Certificate__c);
               }
               if(appPrdctCpfRecId.Is_Bank_Contractor_Insurance_Company__c != '' && appPrdctCpfRecId.Is_Bank_Contractor_Insurance_Company__c!=null ){
                    component.set("v.bankcontractorsorinsurancecomp", appPrdctCpfRecId.Is_Bank_Contractor_Insurance_Company__c);
               }
               if(appPrdctCpfRecId.Is_Confirmation_From_Architect__c != '' && appPrdctCpfRecId.Is_Confirmation_From_Architect__c!=null ){
                    component.set("v.confirmationfrmarchitect", appPrdctCpfRecId.Is_Confirmation_From_Architect__c);
               }
               if(appPrdctCpfRecId.Is_Structural_Integrity_Certificate__c != '' && appPrdctCpfRecId.Is_Structural_Integrity_Certificate__c!=null ){
                    component.set("v.structuralintegritycerti", appPrdctCpfRecId.Is_Structural_Integrity_Certificate__c);
               }
               if(appPrdctCpfRecId.Is_Confirmation_Mech_Elec_Design__c != '' && appPrdctCpfRecId.Is_Confirmation_Mech_Elec_Design__c!=null ){
                    component.set("v.confirmationmechelec", appPrdctCpfRecId.Is_Confirmation_Mech_Elec_Design__c);
               }
               if(appPrdctCpfRecId.Is_Fire_Design__c != '' && appPrdctCpfRecId.Is_Fire_Design__c!=null ){
                    component.set("v.firedesign", appPrdctCpfRecId.Is_Fire_Design__c);
               }
               if(appPrdctCpfRecId.Is_Sufficient_Budget__c != '' && appPrdctCpfRecId.Is_Sufficient_Budget__c!=null ){
                    component.set("v.sufficientbudget", appPrdctCpfRecId.Is_Sufficient_Budget__c);
               }
               if(appPrdctCpfRecId.Is_Professional_Certificate__c != '' && appPrdctCpfRecId.Is_Professional_Certificate__c!=null ){
                    component.set("v.professionalcerti", appPrdctCpfRecId.Is_Professional_Certificate__c);
               }
            }

                else {
                console.log("Failed with state: " + JSON.stringify(appPrdctCpfRecId));
            }
        });
        
        $A.enqueueAction(action);
    },
     getAppConClauseCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppContractClauseRec");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                //debugger;
                var appConClauseRec = response.getReturnValue();
                console.log("newleases: " + JSON.stringify(appConClauseRec));
              	component.set("v.newleases",response.getReturnValue());
              
            }else {
                console.log("Failed with state: " + JSON.stringify(appConClauseRec));
            }
        });
        
        $A.enqueueAction(action);
    },
	addLeaseItems : function(component, event) {
        var leaselist = component.get("v.newleases");
        leaselist.push({
            'sobjectType' : 'Application_Contract_Clause__c',
            'Description__c' : ''
            
        });
        component.set("v.newleases",leaselist);   
        component.set("v.showSpinner", false);
    },
     updateAppPrdctcpfandInsertAppContract : function(component, event, helper) {
       console.log('newleases=='+JSON.stringify(component.get("v.newleases")));
        var valueofpaymade,propertyDescriptionId;
        if(component.find("valueofpaymade") == undefined){
            valueofpaymade=null;
        }else{
            valueofpaymade = component.find("valueofpaymade").get("v.value");
        }
        if(component.find("propertyDescriptionId") == undefined){
            propertyDescriptionId=null;
        }else{
            propertyDescriptionId = component.find("propertyDescriptionId").get("v.value");
        }

       var appProductcpf = new Object();
        appProductcpf.ObligorincorpoutsideofSA= component.get("v.ObligorincorpoutsideofSAvalues");
        appProductcpf.Environmentalpermits= component.get("v.Environmentalpermitsvalues");
        appProductcpf.Financialassistance= component.get("v.Financialassistancevalues");
        appProductcpf.Electricalcompliancecertificate= component.get("v.Electricalcompliancecertificatevalues");
        appProductcpf.Newlyformedcompany= component.get("v.Newlyformedcompanyvalues");
        appProductcpf.Borrowersconvalue= component.find("Borrowersconid").get("v.value");
        appProductcpf.purchasepricevalue= component.find("purchasepriceId").get("v.value");
        appProductcpf.Preletval= component.get("v.Preletvalues");
        appProductcpf.Preletreviewval= component.get("v.Preletreviewvalues");
        appProductcpf.Restraintagainstfreeval= component.get("v.Restraintagainstfreevalues");
        appProductcpf.leaselist= component.get("v.newleases");
        appProductcpf.performanceguaramtees= component.get("v.performanceguaramtees");
        appProductcpf.sectioncerti= component.get("v.sectioncerti");
        appProductcpf.bankcontractorsorinsurancecomp= component.get("v.bankcontractorsorinsurancecomp");
        appProductcpf.confirmationfrmarchitect= component.get("v.confirmationfrmarchitect");
        appProductcpf.structuralintegritycerti= component.get("v.structuralintegritycerti");
        appProductcpf.confirmationmechelec= component.get("v.confirmationmechelec");
        appProductcpf.firedesign= component.get("v.firedesign");
        appProductcpf.sufficientbudget= component.get("v.sufficientbudget");
        appProductcpf.professionalcerti= component.get("v.professionalcerti");
        appProductcpf.valueofpaymade= valueofpaymade;
        appProductcpf.propertyDescriptionId= propertyDescriptionId;
        
         console.log("objData ="+JSON.stringify(appProductcpf));

        var action = component.get("c.updateAppPrdctcpfinsertAppContract");
       action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "objData": JSON.stringify(appProductcpf),
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
               console.log('oppRec---'+JSON.stringify(oppRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application Product CPF And Application Contract Clause record updated Successfully"
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
    updateAppPrdctcpfforNotarially : function(component, event, helper) {
         var property1value;
        var property2value;
        if(component.get("v.NotariallyTiedConsolidationValues") == 'Not Applicable'){
        if(component.find("Property1id") == undefined){
            property1value=null;
        }else{
            property1value = component.find("Property1id").get("v.value");
        }
        if(component.find("Property2id") == undefined){
            property2value=null;
        }else{
            property2value = component.find("Property2id").get("v.value");
        }
      }else {
            property1value = component.find("Property1id").get("v.value");
            property2value = component.find("Property2id").get("v.value");
        }
        var action = component.get("c.updateAppPrdctcpfNorarially");
       action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
           	"NotariallyTiedConsolidation" : component.get("v.NotariallyTiedConsolidationValues"),
            "property1val" : property1value,
           	"property2val" : property2value
           
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var Appprdctcpfrecs = response.getReturnValue();
               console.log('Appprdctcpfrecs---'+JSON.stringify(Appprdctcpfrecs));
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
    
    //My Code
    
      AddFurtherCond : function(component, event) {
          //debugger;
        var TransactionalConvenants = component.get("v.newFurtherCond");
        TransactionalConvenants.push({
            'sobjectType' : 'Application_Contract_Clause__c',
            'Category__c' : 'CPF Application',
            'Type__c'     : 'Further Condition Precedent',
            'Description__c' : ''
            
        });
        component.set("v.newFurtherCond",TransactionalConvenants);   
        component.set("v.showSpinner", false);
    },
    
   furtherAppPrdctcpfandInsertAppContract : function(component, event, helper) {
       debugger;
       console.log('newFurtherCond=='+JSON.stringify(component.get("v.newFurtherCond")));
        var action = component.get("c.furtherAppPrdctcpfinsertAppContract");
       action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "furtherlist" : component.get("v.newFurtherCond")
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
               console.log('oppRec---'+JSON.stringify(oppRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Further Conditions record inserted Successfully"
                });
                toastEvent.fire();
            } 
           // this.hideSpinner(component);
           component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },
    
    handleApplicationEvent : function(component, event,helper) {
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var unlimitedrowinex =event.getParam("UnlimitedRowIndex");
        var unlimitedGauranteelist=component.get("v.newFurtherCond");
        unlimitedGauranteelist.splice(unlimitedrowinex,1);
         component.set("v.newFurtherCond",unlimitedGauranteelist);
        
    },
    
     getAppConClauseCpfRecForFurther :function(component, event, helper) {
        var action = component.get("c.getAppContractClauseRecForFurtherCond");
        
        action.setParams({
            "oppId": component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
               // debugger;
                var appConClauseRec = response.getReturnValue();
                console.log("newFurtherCond: " + JSON.stringify(appConClauseRec));
              	component.set("v.newFurtherCond",response.getReturnValue());
              
            }else {
                console.log("Failed with state: " + JSON.stringify(appConClauseRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    
   /* InsertFurtherConditions : function(component, event, helper) {
        
        console.log('newFurtherCond=='+JSON.stringify(component.get("v.newFurtherCond")));
       // alert();
        var action = component.get("c.insertFurtherConditions");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "OtherTransList" : component.get("v.newFurtherCond")
            
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('inside');
            if (state === "SUCCESS"){
                debugger;
                var UnlimitedOtherTransRec = response.getReturnValue();
                //component.set('v.newFurtherCond',UnlimitedOtherTransRec);
                this.getAppConClauseCpfRecForFurther(component, event);
                console.log('UnlimitedOtherTransRec---'+JSON.stringify(UnlimitedOtherTransRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Any Further Conditions CPF record updated Successfully"
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
        
    },*/
    
    getAppConClauseCpfRecForSpecial :function(component, event, helper) {
        var action = component.get("c.getAppContractClauseRecForSpecialCond");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                //debugger;
                var appConClauseRec = response.getReturnValue();
                console.log("newSpecialCond: " + JSON.stringify(appConClauseRec));
              	component.set("v.newSpecialCond",response.getReturnValue());
              
            }else {
                console.log("Failed with state: " + JSON.stringify(appConClauseRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    AddSpecialCond : function(component, event) {
        var TransactionalConvenants = component.get("v.newSpecialCond");
        TransactionalConvenants.push({
            'sobjectType' : 'Application_Contract_Clause__c',
            'Category__c' : 'CPF Application',
            'Type__c'     : 'Special Condition',
            'Description__c' : ''
            
        });
        component.set("v.newSpecialCond",TransactionalConvenants);   
        component.set("v.showSpinner", false);
    },
    
    handleApplicationEventSpecial : function(component, event,helper) {
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var unlimitedrowinex =event.getParam("UnlimitedRowIndex");
        var unlimitedGauranteelist=component.get("v.newSpecialCond");
        unlimitedGauranteelist.splice(unlimitedrowinex,1);
         component.set("v.newSpecialCond",unlimitedGauranteelist);
        
    },
    
    specialAppPrdctcpfandInsertAppContract : function(component, event, helper) {
       console.log('newSpecialCond=='+JSON.stringify(component.get("v.newSpecialCond")));
        var action = component.get("c.specialAppPrdctcpfinsertAppContract");
       action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "speciallist" : component.get("v.newSpecialCond")
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
               console.log('oppRec---'+JSON.stringify(oppRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Special Conditions record inserted Successfully"
                });
                toastEvent.fire();
            } 
           // this.hideSpinner(component);
           component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },
    getopplineitemRec :function(component, event, helper) {
        var action = component.get("c.getprodName");
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

    
  /*  removeFurtherConditions: function (component) {
        var f = component.get("v.UnlimitedRowIndex");
        debugger;
        component.getEvent("CPFConditions").setParams({
            "UnlimitedRowIndex" : component.get("v.UnlimitedRowIndex")
        }).fire();
    },
    
    removeSpecialConditions: function (component) {
        debugger;
        component.getEvent("CPFConditions").setParams({
            "UnlimitedRowIndex" : component.get("v.UnlimitedRowIndex")
        }).fire();
    },
    
    
  /*  InsertSpecialConditions : function(component, event, helper) {
        
        console.log('newSpecialCond=='+JSON.stringify(component.get("v.newSpecialCond")));
       // alert();
        var action = component.get("c.insertSpecialConditions");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "OtherTransList" : component.get("v.newSpecialCond"),
            
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('inside');
            if (state === "SUCCESS"){
                var UnlimitedOtherTransRec = response.getReturnValue();
				this.getAppConClauseCpfRecForSpecial(component, event);
                console.log('UnlimitedOtherTransRec---'+JSON.stringify(UnlimitedOtherTransRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Special Conditions CPF record updated Successfully"
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
        
    },*/
})