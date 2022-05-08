({
	// Used to sort the 'Age' column
    sortBy: function(field, reverse, primer) {
        var key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    },
   
    handleSort: function(cmp, event) {
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');

        var cloneData = cmp.get("v.childproductList");
        cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));
        
        cmp.set('v.childproductList', cloneData);
        cmp.set('v.sortDirection', sortDirection);
        cmp.set('v.sortedBy', sortedBy);
    },
    
    inithelper : function(component, event, helper, data) {
        component.set("v.IsSpinner",true);
       var actions = [
            { label: 'View', name: 'view' },
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete'}
        ];
       component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text', sortable: true},
            {label: 'Product Name', fieldName: 'Product_Name__c', type: 'text', sortable: true},
            {label: 'Beneficiary Name', fieldName: 'Beneficiary_Name__c', type: 'text', sortable:true},
            {label: 'Guarantee Amount', fieldName: 'Guarantee_Amount__c', type: 'currency', sortable:true},
            {label: 'Guarantee Created Date', fieldName: 'Guarantee_Created_Date__c', type: 'date', sortable:true},
            {label: 'Guarantee Expiry Date', fieldName: 'Guarantee_Expiry_Date__c', type: 'date', sortable:true},
            { type: 'action', typeAttributes: { rowActions: actions } }
       ]);
		var action = component.get("c.getdetails"); 
        action.setParams({
            caseId : component.get("v.recordId")
        });   
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()) {
                var res = response.getReturnValue();
                var childlist = [];
                for(var k=0; k<res.length; k++){
                    if(res[k].Application_Product_Parent__c){
                        component.set("v.parentproductId",res[k].Application_Product_Parent__c);
                        childlist.push(res[k]);
                    }else if(!res[k].Application_Product_Parent__c){
                        component.set("v.parentproductId",res[k].Id);
                    }       
                }
                component.set("v.childproductList",childlist);
            }
            component.set("v.IsSpinner",false);
        });
        $A.enqueueAction(action);
    },
    
    getcolumndetails: function(component, event, helper, data) {
        component.set("v.IsSpinner",true);
        var sec = [];
        sec.push('A');
        sec.push('B');
        if(!component.get("v.parentproductModal")){
            var datalabel ='';
            if(data.Product_Code__c){
              datalabel = 'ABSA_'+data.Product_Code__c;
            }
            var action = component.get("c.getLabelString"); 
            action.setParams({
                labelName : datalabel,
                applicationprodid: data.Opportunity_Product_Id__c
            });   
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()) {
                    var res = response.getReturnValue();
                    component.set("v.labelText", res);
                    var labelText = component.get("v.labelText");
                    if(labelText){
                     var sections = labelText.split(';');
                     if(sections[0] && sections[0]!=''){
                         var contractfields = sections[0].split(',');
                         var contractfieldsval = [];
                         for(var i=0; i<contractfields.length; i++){
                             var fieldval = contractfields[i].split(':');
                             contractfieldsval.push({fieldname:fieldval[0], mandatory:fieldval[1]=='TRUE'?true:false});
                         }
                         component.set("v.contractfields",contractfieldsval);
                     }else{
                        var index = sec.indexOf('A');
                        if (index !== -1) {
                          sec.splice(index, 1);
                        }
                         component.set("v.activeSectionschild",sec);
                         component.set("v.contractfields",[]);
                     }
                     if(sections[1] && sections[1]!=''){
                         var guaranteefields = sections[1].split(',');
                         var guaranteefieldsval = [];
                         for(var i=0; i<guaranteefields.length; i++){
                             var fieldval = guaranteefields[i].split(':');
                             guaranteefieldsval.push({fieldname:fieldval[0], mandatory:fieldval[1]=='TRUE'?true:false});
                         }
                         component.set("v.guaranteefields",guaranteefieldsval);
                     }else{
                        var index = sec.indexOf('B');
                        if (index !== -1) {
                          sec.splice(index, 1);
                        }
                         component.set("v.activeSectionschild",sec);
                         component.set("v.guaranteefields",[]);
                     }
                    }
                    component.set("v.productdetailmodal",true);
                }else{
                    component.find('notifLib').showToast({
                        "title": "Error!",
                        "variant":"error",
                        "message": "LDP Type label is missing for this one. Please check with your admin."
                    });
                }
            });
            $A.enqueueAction(action);
        }else{
            component.set("v.productdetailmodal",true);
        }
        component.set("v.IsSpinner",false);
    },
    deleteappproduct: function(component, event, helper, data) {
      if (confirm('Do you want to delete this record?')){
        component.set("v.IsSpinner",true);
        var action = component.get("c.deleteproducts"); 
        action.setParams({
            productid: data,
            caseId : component.get("v.recordId")
        });   
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()) {
                var res = response.getReturnValue();
                var childlist = [];
                 for(var k=0; k<res.length; k++){
                    if(res[k].Application_Product_Parent__c){
                        childlist.push(res[k]);
                    }       
                }
                component.set("v.childproductList",childlist);
            }
            component.find('notifLib').showToast({
                "title": "Success!",
                "variant":"success",
                "message": "Application product record deleted Successfully."
            });
            component.set("v.IsSpinner",false);
        });
        $A.enqueueAction(action);
      }else{
          component.set("v.IsSpinner",false);
      }
    },
})