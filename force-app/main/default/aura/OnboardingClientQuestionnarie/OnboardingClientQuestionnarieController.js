({
    initData: function(component, event, helper) {
        console.log('***In controller');
        helper.getRecordTypeNamehelper(component, event, helper);
        //helper.getQuestionWrapperhelper(component, event, helper);
    },
    validateandSave: function(component, event, helper) {
        var questionwithsectionlists = component.get('v.questionwithsectionlist');
          helper.validateandSave(component, event, helper); 
    },
    
    onCheckedChange : function(component, event, helper) {
        
        var target = event.getSource();
        var chValue = target.get("v.checked");
        var chValue1 = target.get("v.label");
        var chName = target.get("v.name");
        var jsonData={};    //new Map();
        var jsonObj = [];
        var questionwithAns = component.get("v.questionwithsectionlist");
        
         questionwithAns.forEach(function(data){
            var finaldata = data.value;
            finaldata.forEach(function(finaldat){
               // datawithAns.push(finaldat);
                console.log('in ccccaaa--'+chValue1);
                
                if(finaldat.questionLabel == chName){
                    console.log('in cccc--'+chValue);
                    if(chValue == false ){
                      finaldat.userAnswer =   'false';  
                    }else{
                        finaldat.userAnswer =  'true';
                    }
                    
                   // jsonData[finaldat.questionLabel]=   finaldat.userAnswer;
                }
                
				
            })
            
            console.log("json---"+JSON.stringify(questionwithAns));
             
            component.set('v.questionwithsectionlist',questionwithAns);
      
        }) 
    }    
})