({
	initComp : function(component, event, helper) {
		helper.SecurityLifePolicyHelper(component,event,helper);
	},
    viewAllCreditLife : function(component , event , helper){
       component.set("v.isPagination" , true);
       var bondsList = component.get("v.listOfSearchRecords");
       var pageSize = component.get("v.pageSize"); 
       var paginationList = [];
       	for(var i=0; i< pageSize && i< bondsList.length; i++)
       	{
         	paginationList.push(bondsList[i]);
       	}
        component.set("v.minimunListRecords", paginationList);
        if(bondsList.length<pageSize){
         component.set("v.isLastPage", true);   
        }
    },
    
    first : function(component, event, helper){
       
       var bondsList = component.get("v.listOfSearchRecords");
       var pageSize = component.get("v.pageSize"); 
       var paginationList = [];
        component.set("v.start",0);
        component.set("v.end",9);
        component.set("v.isLastPage", false);
       for(var i=0; i< pageSize; i++)
       {
           if(bondsList[i] != undefined){
         	paginationList.push(bondsList[i]); 
            }
       }
        component.set("v.minimunListRecords", paginationList);
        
    },
    next : function(component, event, helper){
       var bondsList = component.get("v.listOfSearchRecords");
        var end = component.get("v.end");
		var start = component.get("v.start");
		var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        var lengthb= bondsList.length;
        
        for(var i = (end+1);  i< (end+11) && i< bondsList.length  ; i++){
         
              if(bondsList[i] != undefined){
                  console.log('Bonds ***********' + bondsList[i]);
            	  paginationList.push(bondsList[i]);
                  counter ++ ;
                  }
          

         }

        start = start + counter;
        end = end + counter;
        component.set("v.start",start);
        component.set("v.end",end);
        component.set("v.totalSize",counter);
        console.log('Counetr Length------------------' + counter);
        if(end+1>= bondsList.length){
            component.set("v.isLastPage", true);
        }
        if(counter > 0){
            component.set("v.minimunListRecords", paginationList);
            component.set("v.isLastPage", false);
        }
        if(pageSize > counter){
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
            if(minimumList[i].ApplicationId == id_str){
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