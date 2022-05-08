({
	doInit : function(component, event, helper) {
        helper.doInit(component);    
    },
    /* handleChange : function(component, event, helper) {
        // When an option is selected, navigate to the next screen
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        console.log('navigate'+navigate)
        if(response=='previousId'){
            navigate("BACK");
        }
        if(response=='pauseId'){
            navigate("PAUSE");
        }
        if(response=='nextId'){
            navigate("NEXT");
        }
        
       },*/
       
    dispDebitOrder : function(component, event, helper) {
          var fDate = component.find("fDate").get('v.value');
          var tDate = component.find("tDate").get('v.value');
          if((fDate != '') && (tDate != ''))
          {
             
            helper.getDebitOrder1(component);
          }
                  
    },
      
    getSelectedName: function (component, event) {
    var selectedRows = event.getParam('selectedRows');
          
     // Display that fieldName of the selected rows
    for (var i = 0; i < selectedRows.length; i++){
        if(selectedRows.length > 0){
            var selectedRow=selectedRows[i];
            selectedRow.actionDate = selectedRow.actionDate;
            selectedRow.userCode = selectedRow.userCode;
            selectedRow.userSeq = selectedRow.userSeq;
            component.set("v.proName", selectedRow.actionDate);
            component.set("v.proType", selectedRow.userCode);
            component.set("v.procount", selectedRow.userSeq);
        
        }
    }
        
  },
    
    filterRefData: function(component, event, helper) {
     helper.filterRefDataView(component, event, helper);
   
    },
    filterAmtData: function(component, event, helper) {
     helper.filterAmtDataView(component, event, helper);
   
    },
    updateColumnSorting: function(component, event, helper) {
    var fieldName = event.getParam('fieldName');
    var sortDirection = event.getParam('sortDirection');
    // assign the latest attribute with the sorted column fieldName and sorted direction
    component.set("v.sortedBy", fieldName);
    component.set("v.sortedDirection", sortDirection);
    helper.sortData(component, fieldName, sortDirection);
       
    },
    
     // Following pointing to valid service
    getDebitOrder : function(component, event, helper) {
        helper.getDebitOrderList(component);
    },
  
})