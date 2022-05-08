({
	initComp : function(component, event, helper) {
		 helper.SecurityBondsHelper(component,event,helper);
		//var n = new Number(1000000);
        //var myObj = {
            // style: "currency",
            // currency: "ZAR"
            //}
        //console.log('SA Currency' + n.toLocaleString("en-ZA", myObj));
	},
    
    handleClick: function(component, event, helper) {
       
    	helper.SecurityBondsHelper(component,event,helper);
        
        
   },
    viewAllBonds : function(component, event, helper) {
       component.set("v.isPagination" , true);
       var bondsList = component.get("v.listOfSearchRecords");
       var pageSize = component.get("v.pageSize"); 
       var paginationList = [];
       	for(var i=0; i< pageSize; i++)
       	{
         	paginationList.push(bondsList[i]);
       	}
        component.set("v.minimunListRecords", paginationList);
    },
    
    closeBondsModel : function(component, event, helper) {
       
       var flag = component.get("v.popupFlag");
       var minimum = component.get("v.minimunListRecords");
       var bondsList = component.get("v.opportunityList");
       console.log('Close Model********' + flag);
       console.log('Close Model------' + minimum);
       
        component.set("v.isOpen",false);
       
        component.set("v.isBondOpen",false);
   },
    first : function(component, event, helper){
       
       var bondsList = component.get("v.listOfSearchRecords");
       var pageSize = component.get("v.pageSize"); 
       var paginationList = [];
        component.set("v.start",0);
        component.set("v.end",0);
        component.set("v.isLastPage", false);
       for(var i=0; i< pageSize; i++)
       {
           if(bondsList[i] != undefined){
         	paginationList.push(bondsList[i]); 
            }
       }
        component.set("v.minimunListRecords", paginationList);
        
    },
    last : function(component, event, helper){
	var bondsList = component.get("v.listOfSearchRecords");

	var pageSize = component.get("v.pageSize");

	var totalSize = component.get("v.totalSize");

	var paginationList = [];

		for(var i=totalSize-pageSize+1; i< totalSize; i++){
		paginationList.push(bondsList[i]);
        }
			component.set('v.paginationList', paginationList);

    },
    previous : function(component, event, helper){
       var bondsList = component.get("v.opportunityList");
	   var end = component.get("v.end");
       var start = component.get("v.start");
       var pageSize = component.get("v.pageSize");
	   var paginationList = [];

	   var counter = 0;
	   for(var i= start-pageSize; i < start ; i++){
          if(i > -1){
			paginationList.push(bondsList[i]);
			counter ++;
           }else {
               start++;
           }
        }
          start = start - counter;
          end = end - counter;
          component.set("v.start",start);
		  component.set("v.end",end);
          component.set("v.paginationList", paginationList);
        
    },
    next : function(component, event, helper){
        component.set("v.minimunListRecords", '');
		var bondsList = component.get("v.listOfSearchRecords");
        var end = component.get("v.end");
		var start = component.get("v.start");
		var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
       
        
        for(var i = pageSize; i < bondsList.length  ; i++){
         
              if(bondsList[i] != undefined){
                  console.log('Bonds ***********' + bondsList[i]);
            	  paginationList.push(bondsList[i]);
                  counter ++ ;
                  }
          

         }

        start = start + counter;
        //end = end + counter;
        component.set("v.start",start);
        component.set("v.end",end);
        component.set("v.totalSize",counter);
        console.log('Counetr Length------------------' + counter);
        
        if(counter > 0){
            component.set("v.minimunListRecords", paginationList);
            component.set("v.isLastPage", false);
        }
        if(pageSize >= counter){
             component.set("v.isLastPage", true);
            //component.set("v.start",0);
        }else{
            component.set("v.isLastPage", false);
        }

    },
    
    selectedItem : function(component,event,helper){
        component.set("v.isOpen",false);
        var minimumList = component.get("v.listOfSearchRecords");
        var ctarget = event.currentTarget;
    	var id_str = ctarget.dataset.value;
    	console.log("Length " + minimumList.length);
        console.log("Data Set" + id_str);

        
        for(var i = 0;i < minimumList.length;i++){
            if(minimumList[i].bondRegnum == id_str){
                component.set("v.oBonds",minimumList[i]);
                break;
            }
             
        }
        component.set("v.isBondOpen",true);
        
        
    },
    closeBondsDetailsModel : function(component,event,helper){
        var flag = component.get("v.popupFlag");
        if(flag) {
            component.set("v.isOpen",true);
        }else{
            component.set("v.isOpen",false);
        }
        component.set("v.isBondOpen",false);
    }
    
    
})