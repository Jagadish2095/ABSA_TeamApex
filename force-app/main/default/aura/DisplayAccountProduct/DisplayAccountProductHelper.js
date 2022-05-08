({
    fetchDataAccounts : function(component, event, helper) {       
        
        var recordId = component.get("v.recordId");
        var customerCode = component.get("v.customerCode");       
        var action = component.get("c.getAcctLinkedToClientCode");		      
        action.setParams(
            { 
                "clientCode" : customerCode
            });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                // var respObj = response.getReturnValue();
                  component.set('v.NoRecordsFound','');
                try{
                    if (respObj.statusCode == 200 && respObj.nbsmsgo3.nbrUserErrs=='0') {
                        var outputTable =  respObj.cip047o.outputTable;
                        var outputTableNew =[];  
                        
                         for(var i=0; i<outputTable.length;i++)
                        {
                            
                             var account=outputTable[i].oaccntnbr.replace(/^0+/, '');  
                                    outputTable[i].oaccntnbr=account;
                        }
                       
                        if((!$A.util.isUndefinedOrNull(outputTable)) && outputTable.length > 0)
                        {  
                             component.set('v.data', outputTable);
                             $A.util.removeClass(component.find("ProductTable"), "slds-hide");
                            
                            var pageSize = component.get("v.productPageSize");
                            // get size of all the records and then hold into an attribute "totalRecords"
                            component.set(
                                "v.productTotalRecords",
                                component.get("v.data").length
                            );
                            // set star as 0
                            component.set("v.productStartPage", 0);
                            
                            component.set("v.productEndPage", pageSize - 1);
                            var PaginationList = [];
                            for (var i = 0; i < pageSize; i++) {
                                if (component.get("v.data").length > i)
                                    PaginationList.push(outputTable[i]);
                            }
                            component.set("v.productPaginationList", PaginationList);
                            
                           /* for(var i = 0; i < outputTable.length; i++)
                            {
                                if(outputTable[i]['status'] != "CLOSED")
                                {
                                    outputTableNew.push(outputTable[i]);     
                                }
                            }  */                          
                            
                        }
                       else
                       {   
                           component.set('v.isNotValidAccounts', true);
                           component.set('v.CanNavigate', false);
                       }                       
                    }  else{
                        component.set('v.isNotValidAccounts',true);
                        component.set('v.NoRecordsFound',respObj.nbsmsgo3.msgEntry[0].msgTxt);
                    }
                        
                   
            }catch(ex)
                {
                    component.set('v.')
                    component.find('branchFlowFooter').set('v.heading', 'Something went wrong');                            
                    component.find('branchFlowFooter').set('v.message', ex.message);                            
                    component.find('branchFlowFooter').set('v.showDialog', true);
                    //console.error(ex);
                }
            }
            else if (state === "ERROR") {                
               
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message){
                       // console.log("Error message: " + errors[0].message);
                        component.find('branchFlowFooter').set('v.heading', 'Something went wrong');                            
                        component.find('branchFlowFooter').set('v.message', error[0].errorMessage);                            
                        component.find('branchFlowFooter').set('v.showDialog', true);
                    }
                    else {
                        //console.log("unknown error");
                        component.find('branchFlowFooter').set('v.heading', 'unknown error');                            
                        component.find('branchFlowFooter').set('v.message', 'unknown error');                            
                        component.find('branchFlowFooter').set('v.showDialog', true);
                    }
                }
            }
                else if(state === "INCOMPLETE"){
                   // console.log("Incomplete action. The server might be down or the client might be offline.");
                    component.find('branchFlowFooter').set('v.heading', 'The server might be down.');                            
                    component.find('branchFlowFooter').set('v.message', 'The server might be down or the client might be offline.');                            
                    component.find('branchFlowFooter').set('v.showDialog', true);
                } 
        });
        $A.enqueueAction(action); 
        // component.set("v.showSpinner", false);
    },
     //Method to get next set of Products to display on Product data table
  nextProductSet: function(component, event) {
    var sObjectList = component.get("v.data");
    var end = component.get("v.productEndPage");
    var start = component.get("v.productStartPage");
    var pageSize = component.get("v.productPageSize");
    var Paginationlist = [];
    var counter = 0;
    for (var i = end + 1; i < end + pageSize + 1; i++) {
      if (sObjectList.length > i) {
        Paginationlist.push(sObjectList[i]);
      }
      counter++;
    }
    start = start + counter;
    end = end + counter;
    component.set("v.productStartPage", start);
    component.set("v.productEndPage", end);
    component.set("v.productPaginationList", Paginationlist);
  },

  //Method to get prev set of Products to display on Product data table
  previousProductSet: function(component, event) {
    var sObjectList = component.get("v.data");
    var end = component.get("v.productEndPage");
    var start = component.get("v.productStartPage");
    var pageSize = component.get("v.productPageSize");
    var Paginationlist = [];
    var counter = 0;
    for (var i = start - pageSize; i < start; i++) {
      if (i > -1) {
        Paginationlist.push(sObjectList[i]);
        counter++;
      } else {
        start++;
      }
    }
    start = start - counter;
    end = end - counter;
    component.set("v.productStartPage", start);
    component.set("v.productEndPage", end);
    component.set("v.productPaginationList", Paginationlist);
  },
})