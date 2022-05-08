({
    fetchDataAccounts : function(component, event, helper) { 
        var recordId = component.get("v.recordId");
        var customerCode = component.get("v.customerCode");
        var oppId = component.get("v.opportunityId");
        var action = component.get("c.GetLinkProductsByCif");		      
        action.setParams({
            "CifKey": customerCode        	
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                console.log(respObj);
                
                try{
                    if (respObj.statusCode == 200) {
                        var outputTable =  respObj.qualifyingPackages;
                        var outputTableNew =[];
                        if((!$A.util.isUndefinedOrNull(outputTable)) && outputTable.length > 0)
                        {
                            $A.util.removeClass(component.find("ProductTable"), "slds-hide");
                            for(var key in outputTable){
                                outputTableNew.push({key: key, packageName: outputTable[key].packageName,schemeDescription: outputTable[key].availablePricingScheme[0].schemeDescription,
                                                     schemeCode: outputTable[key].availablePricingScheme[0].schemeCode,accountNumber: outputTable[key].qualifyingProducts.chequeAccountDetails.accountNumber
                                                     ,creditAccountNumber: outputTable[key].qualifyingProducts.creditAccountDetails.creditAccountNumber});
                            }
                            component.set('v.data', outputTableNew);
                        }
                        else if(respObj.errorMessage!='')
                        {   
                            component.set('v.isNoPackageFound', true);
                            component.set('v.NopackagesFound',respObj.errorMessage);
                            
                        }
                    }
                    
                    
                }catch(ex)
                {
                    component.set('v.CanNavigate',true);
                    component.find('branchFlowFooter').set('v.heading', 'Something went wrong');                            
                    component.find('branchFlowFooter').set('v.message', ex.message);                            
                    component.find('branchFlowFooter').set('v.showDialog', true);
                }                
            } else if(state === "ERROR"){
                component.set('v.CanNavigate',true);
                component.find('branchFlowFooter').set('v.heading', 'Something went wrong With Service ClientKey');                            
                component.find('branchFlowFooter').set('v.message', state + 'Something went wrong');                            
                component.find('branchFlowFooter').set('v.showDialog', true);
            } else{
                
            }
        });
        $A.enqueueAction(action);
    },
    
    CreateLink: function(cmp, event, helper) { 
        return new Promise(function(resolve, reject) {
            var clientKey = cmp.get("v.recordId");
            var customerCode = cmp.get("v.customerCode");
            var chequeAccount = cmp.get("v.chequeAccount");
            var creditCardNumber = cmp.get("v.creditCardNumber");
            var pricingCode = cmp.get("v.pricingCode");
            var packageName = cmp.get("v.packageName");
            var action = cmp.get("c.CreatePackageLink");
            action.setParams({ 
                "tclientKey": customerCode,
                "tchequeAccountNumber" : chequeAccount,
                "tcreditAccountNumber": creditCardNumber,
                "tpricingCode": pricingCode,
                "tpackageName":packageName
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(cmp.isValid && state==="SUCCESS") {
                    var returnResponse = JSON.parse(response.getReturnValue());                    
                    var errors = returnResponse.errors;
                    var content = returnResponse.content;
                    var message = "";
                    var sourceSystem = "";
                    if (errors && errors.length > 0) { 
                        for (var i = 0; i < errors.length; i++) {
                            if (errors[i] && errors[i].reason) {
                                message +=  (message.length > 0 ? "\n" : "") + errors[i].reason;
                                sourceSystem +=  (sourceSystem.length > 0 ? "/" : "") + errors[i].sourceSystem;
                            }                     
                        }
                        cmp.set('v.CanNavigate',true);
                        cmp.find('branchFlowFooter').set('v.heading', sourceSystem);                            
                        cmp.find('branchFlowFooter').set('v.message', message);                            
                        cmp.find('branchFlowFooter').set('v.showDialog', true);
                        
                    } else {
                        if (content) { 
                            // if (content[0] && content[0].packageId) {
                            
                            var packageId = content.packageId;
                            cmp.set('v.packageId', packageId);
                            
                            //Create Opportunity
                            
                            let actionOpp = cmp.get('c.getNewOpportunity');
                            var recordId = cmp.get("v.recordId");	
                            var productId = cmp.get("v.productId");	
                            var productType = cmp.get("v.productType");
                            var flowname = cmp.get("v.flowName");            
                            var pricingCode = cmp.get("v.pricingCode");
                            var packageName = cmp.get("v.packageName");                    
                            actionOpp.setParams({
                                "accountID" : recordId,
                                "productCode" :productId ,
                                "productType" : packageName,
                                "flowname" : flowname,
                                "packageId" : packageId
                            });
                            productId= productId + "_" + pricingCode;
                            actionOpp.setCallback(this, function (response) {
                                var state = response.getState();
                                if (state === 'SUCCESS') {
                                    var res = response.getReturnValue();
                                    cmp.set('v.opportunityId',res['opportunityId']);
                                    cmp.set('v.applicationId',res['applicationId']);
                                    cmp.set('v.packageName',productId);
                                    resolve('Continue');
                                } else {
                                    reject('Failed');
                                }
                            });
                            $A.enqueueAction(actionOpp);
                            
                        }
                        
                    }
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) { 
                        if (errors[0] && errors[0].message) {
                            var error =cmp.get('v.NopackagesFound');
                            if(error!='' || error!=null)   
                            {
                                cmp.set('v.CanNavigate',true);
                                cmp.find('branchFlowFooter').set('v.heading', 'Something went wrong 4');                            
                                cmp.find('branchFlowFooter').set('v.message', errors[0].message);                            
                                cmp.find('branchFlowFooter').set('v.showDialog', true);
                            }
                        }
                        
                    } else {
                        var error =cmp.get('v.NopackagesFound');
                        if(error!='' || error!=null)   
                        {
                            cmp.set('v.CanNavigate',true);
                            cmp.find('branchFlowFooter').set('v.heading', 'Something went wrong 5');                            
                            cmp.find('branchFlowFooter').set('v.message', 'Unknown error');                            
                            cmp.find('branchFlowFooter').set('v.showDialog', true);
                        }
                    }
                    
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    createOpportunity : function(component, event, helper) {    
        // return new Promise(function(resolve, reject) {
        let action = component.get('c.getNewOpportunity');
        var recordId = component.get("v.recordId");	
        var productId = component.get("v.productId");	
        var productType = component.get("v.productType");
        var flowname = component.get("v.flowName");            
        var pricingCode = cmp.get("v.pricingCode");
        var packageName = cmp.get("v.packageName");
        
        action.setParams({
            "accountID" : recordId,
            "productCode" :productId ,
            "productType" : productType,
            "flowname" : flowname
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();;
            if (state === 'SUCCESS') {
                var res = response.getReturnValue();
                component.set('v.opportunityId',res['opportunityId']);
                component.set('v.applicationId',res['applicationId']);
                resolve('Continue');
            } else {
                reject('Failed');
            }
        });
        $A.enqueueAction(action);
        // })
    },
    
    OnNextLink : function(component, event, helper) {  
        let action = component.get('c.getNewOpportunity');
        var recordId = component.get("v.recordId");	
        var productId = component.get("v.productId");	
        var productType = component.get("v.productType");
        var flowname = component.get("v.flowName");            
        
        action.setParams({
            "accountID" : recordId,
            "productCode" :productId ,
            "productType" : productType,
            "flowname" : flowname
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();;
            if (state === 'SUCCESS') {
                var res = response.getReturnValue();
                component.set('v.opportunityId',res['opportunityId']);
                component.set('v.applicationId',res['applicationId']);
                resolve('Continue');
            } else {
                reject('Failed');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    fetchGoldProducts : function(cmp, event, helper) { 
        var Products = '';
        var lstProducts = [];
        var lstProductPremium = [];
        
        
        var getProductGold = cmp.get("c.getDetails");
        getProductGold.setParams({
            Products: Products
            
        });
        
        getProductGold.setCallback(this,function(response){
            var state = response.getState();
            if(cmp.isValid && state==="SUCCESS") {
                var returnResponse = response.getReturnValue();
                console.log(returnResponse);
                lstProducts = returnResponse;
                cmp.set("v.lstProducts", lstProducts);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var error =cmp.get('v.NopackagesFound');
                        if(error!='' || error!=null)   
                        {
                            cmp.set('v.CanNavigate',true);
                            component.find('branchFlowFooter').set('v.heading', 'Something went wrong ');                            
                            component.find('branchFlowFooter').set('v.message', errors[0].message);                            
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        }
                    }
                } else {
                    var error =cmp.get('v.NopackagesFound');
                    if(error!='' || error!=null)   
                    {
                        component.find('branchFlowFooter').set('v.heading', 'Something went wrong ');                            
                        component.find('branchFlowFooter').set('v.message', 'Unknown error');                            
                        component.find('branchFlowFooter').set('v.showDialog', true);
                    }
                }
                
            }
        });
        $A.enqueueAction(getProductGold);
    },
    fetchPremiumProducts : function(cmp, event, helper) { 
        
        var Products = '';
        var lstProducts = [];
        var lstProductPremium = [];
        var getProductPremium = cmp.get("c.getDetails2");
        getProductPremium.setParams({
            Products: Products
            
        });
        
        getProductPremium.setCallback(this,function(response){
            var state = response.getState();
            if(cmp.isValid && state==="SUCCESS") {
                var returnResponse = response.getReturnValue();
                console.log(returnResponse);
                lstProductPremium = returnResponse;
                cmp.set("v.lstProductPremium", lstProductPremium);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var error =cmp.get('v.NopackagesFound');
                        if(error!='' || error!=null)   
                        {
                            cmp.find('branchFlowFooter').set('v.heading', 'Something went wrong ');                            
                            cmp.find('branchFlowFooter').set('v.message', errors[0].message);                            
                            cmp.find('branchFlowFooter').set('v.showDialog', true);
                        }
                    }
                } else {
                    var error =cmp.get('v.NopackagesFound');
                    if(error!='' || error!=null)   
                    {
                        cmp.set('v.CanNavigate',true);
                        cmp.find('branchFlowFooter').set('v.heading', 'Something went wrong ');                            
                        cmp.find('branchFlowFooter').set('v.message', 'Unknown error');                            
                        cmp.find('branchFlowFooter').set('v.showDialog', true);
                    }
                }
                
            }
        });
        $A.enqueueAction(getProductPremium);
    }
})