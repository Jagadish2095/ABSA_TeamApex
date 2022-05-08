/**
* @description class is created to get inputs on portfolio changes.
* CLient Review
* Lightning Component - VAselectchangescomponent
* */
public class CustomerInputsOnchange {
    
    
/**
* @description method will call from aura component and save changes to sf.
* @param lstOfSelectedOptions - list of selected options.
* @param recordId - current case id.
* @return string
* */
    @AuraEnabled
    public static String saveClientChanges(String[] lstOfSelectedOptions,String recordId){
        string msg='';
        try{
            if(lstOfSelectedOptions.size()>0){
                List<Case> listofcase=[select id from case where id =: recordId];
                list<string> listOfOption=new list<string>();
                String selectedOptions='';
                for(String opt:lstOfSelectedOptions){
                    selectedOptions=selectedOptions+'\n'+opt+' : Yes';
                }          
                listofcase[0].Extended_Request_Data__c = selectedOptions;
                update listofcase;
                //system.debug('lstAccountId : ------->>>'+selectedOptions);
            }
        }
        catch(Exception ex){
            msg=ex.getMessage()+'\n'+ex.getLineNumber()+'\n'+ex.getCause();
        }
        return msg;
    }
}