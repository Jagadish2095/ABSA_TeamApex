global class Invocable_AllocateLead {

    global class Request {
        @InvocableVariable
            global String role;
        @InvocableVariable
            global String serviceGroup;
    }

    global class Result {
        @InvocableVariable
            global String ownerId;
        @InvocableVariable
            global Boolean failed;
        @InvocableVariable
            global String errorMessage;
    } 
    @InvocableMethod(label='Assign the Lead' 
                     description='Assigns the lead to a banker based on business rules') 
    global static List<Result> assignLead(List<Request> varsList) {
        List<Result> results = new List<Result>();

        Set<String> groupNames = new Set<String>();
        Set<String> roleNames = new Set<String>();
        Map<String, String> groupRoleMap = new Map<String, String>();
        Map<String, Set<Id>> roleUserMap = new Map<String, Set<Id>>();
        Map<String, Set<Id>> roleUserAllocationMap = new Map<String, Set<Id>>();

        for(Request vars : varsList){
            roleNames.add( vars.role );
            groupNames.add( vars.serviceGroup );   
            if(String.isNotBlank(vars.role) && String.isNotBlank(vars.serviceGroup)){
                groupRoleMap.put( vars.serviceGroup, vars.role);
            }
            
        }

        for(User u :[Select Id, UserRole.Name From User Where UserRole.Name IN :roleNames AND isActive = true AND Is_Absent__c = false]){

            if( !roleUserMap.containsKey(u.UserRole.Name)){
                roleUserMap.put(u.UserRole.Name, new Set<Id>());
                roleUserAllocationMap.put(u.UserRole.Name, new Set<Id>());
            }

            if( roleUserMap.containsKey(u.UserRole.Name) ){
                roleUserMap.get(u.UserRole.Name).add(u.Id);
                roleUserAllocationMap.get(u.UserRole.Name).add(u.Id);
            }

        }

        //get all active and available group members for all public groups
        Set<Id> activeGroupMembers = new Set<Id>();

        for(User u :[Select Id, Is_Absent__c From User Where Id IN (Select UserOrGroupId From GroupMember Where Group.Name IN :groupNames) AND isActive = true AND Is_Absent__c = false]){
            activeGroupMembers.add(u.Id);
        }

        //Map users in public groups
        Map<String, Set<Id>> groupUserMap = new Map<String, Set<Id>>();
        Map<String, Set<Id>> groupPriorityUserMap = new Map<String, Set<Id>>();
        Map<String, Set<Id>> groupPriorityUserAllocationMap = new Map<String, Set<Id>>();
        Map<String, Set<Id>> groupUserAllocationMap = new Map<String, Set<Id>>();

        for(GroupMember gm :[Select Group.Name, UserOrGroupId From GroupMember Where UserOrGroupId IN :activeGroupMembers AND Group.Name IN :groupNames]){

            if( !groupUserMap.containsKey(gm.Group.Name)){

                groupUserMap.put(gm.Group.Name, new Set<Id>());
                groupUserAllocationMap.put(gm.Group.Name, new Set<Id>());

                //priority bankers
                groupPriorityUserMap.put(gm.Group.Name, new Set<Id>());
                groupPriorityUserAllocationMap.put(gm.Group.Name, new Set<Id>());
            }
			
            if( groupUserMap.containsKey(gm.Group.Name) ){

                groupUserMap.get(gm.Group.Name).add(gm.UserOrGroupId);
                groupUserAllocationMap.get(gm.Group.Name).add(gm.UserOrGroupId);

                //priority bankers based on Role / group - Group priority bankers to their corresponding public group
                if( groupRoleMap.containsKey(gm.Group.Name) ){
                    if(roleUserMap.containsKey(groupRoleMap.get(gm.Group.Name))){

                        if( roleUserMap.get( groupRoleMap.get(gm.Group.Name)).contains(gm.UserOrGroupId) ){
    
                            groupPriorityUserMap.get(gm.Group.Name).add(gm.UserOrGroupId);
                            groupPriorityUserAllocationMap.get(gm.Group.Name).add(gm.UserOrGroupId);
    
                        }
                    }
                   
                }
            }

        }
        
        //get current Lead assigment count per user in order to proportionally assign the Leads according to
        //relevant work load
        Map<Id, Integer> userLeadCounter = new Map<Id, Integer>();

        List<AggregateResult> resultList = [Select COUNT(Id) cnt, OwnerId 
                                            From Lead 
                                            Where OwnerId IN :activeGroupMembers AND Active__c = 1
                                            GROUP By OwnerId 
                                            ORDER BY count(Id)];

        for (AggregateResult ar: resultList){

            userLeadCounter.put( (Id)ar.get('OwnerId'), (Integer)ar.get('cnt') );

        } 

        //Give zero count for active users that are not part of the result set from our aggregated query as they have no leads
        //allocated to them
        for(String uId :activeGroupMembers){
            
            if(!userLeadCounter.containsKey(uId)){

                userLeadCounter.put( (Id)uId, 1);

            }

        }


        for (Request vars : varsList)
        {

            Result thisResult = new Result();
            //Lead owner allocation
            //records have a role specified. We have to assign Leads to these priority bankers
            //in the role that is also in the public group for a record

            if(String.isNotBlank(vars.role)){
                
                if(roleUserMap.containsKey(vars.role)){
                
                    String userId = '';

                    /** DO NOT DELETE - MIGHT USE THIS FOR EQUAL ASSIGMENT IN A ROUND ROBIN FASHION
                    if( !groupPriorityUserAllocationMap.get(rec.Service_Group__c).isEmpty() ){
                    
                        userId = new List<Id>(groupPriorityUserAllocationMap.get(rec.Service_Group__c))[0];

                    }else{

                        groupPriorityUserAllocationMap.get(rec.Service_Group__c).addAll(groupPriorityUserMap.get(rec.Service_Group__c));

                        if(!groupPriorityUserAllocationMap.get(rec.Service_Group__c).isEmpty()){
                            userId = new List<Id>(groupPriorityUserAllocationMap.get(rec.Service_Group__c))[0];
                            
                        }
                       
                    } 
                    */
                    if(groupPriorityUserMap.containsKey(vars.serviceGroup)){

                        if( !groupPriorityUserMap.get(vars.serviceGroup).isEmpty() ){

                            Integer smallesCount = 0;

                            for(Id uid :groupPriorityUserMap.get(vars.serviceGroup)){

                                if(userLeadCounter.containsKey(uid) ){

                                    if( ( userLeadCounter.get(uid) <= smallesCount ) || ( smallesCount == 0 )){
                                        
                                        userId = uid;

                                        smallesCount = userLeadCounter.get(uid);
                                    }

                                   
                                } 
                            }

                            if( userId != '' ){

                                thisResult.ownerId = userId;
                                
                                //Increment Lead allocation count for this user
                                userLeadCounter.put((Id)userId, ( (Integer)userLeadCounter.get(userId) + 1));
                                
                                //remove Id from set
                                //DO NOT DELETE - MIGHT USE THIS FOR EQUAL ASSIGMENT IN A ROUND ROBIN FASHION
                                //groupPriorityUserAllocationMap.get(rec.Service_Group__c).remove(userId);
        
                            }
        
                            results.add(thisResult);

                        }else{

                            thisResult.failed = true;
                            //rec.Process_Date__c = System.now();
                            //rec.Process_Information__c = 'There are no users for Lead assignment, in the public group ' + rec.Service_Group__c;
                            thisResult.errorMessage = 'There are no users for Lead assignment in this branch ' + vars.serviceGroup + 
                        						 		 ', or not configured correctly, please ask your administrator for help!';
                            results.add(thisResult);
                        }

                    }else{
                            thisResult.failed = true;
                            //rec.Process_Date__c = System.now();
                            //rec.Process_Information__c = 'There are no users for Lead assignment, in the public group ' + rec.Service_Group__c;
                            thisResult.errorMessage = 'There are no users for Lead assignment in the public group ' + vars.serviceGroup + 
                        						 	 ', or not configured correctly, please ask your administrator for help!';
                            results.add(thisResult);
                    }
                    
                }else{

                    thisResult.failed = true;
                    //rec.Process_Date__c = System.now();
                    /*rec.Process_Information__c = 'The Role value in the upload file, did NOT match any Role Name in Salesforce.\n' +
                                                  'File Role Name Value = ' + rec.Role__c;*/
                    thisResult.errorMessage = 'The Role value in the upload file did NOT match any Role Name in Salesforce.\n '+ 
                                                  'File Role Name Value = ' + vars.role;
                    results.add(thisResult);
                }

            }else{
                if(groupUserMap.containsKey(vars.serviceGroup)){
          
                    String userId = '';

                   /**  /** DO NOT DELETE - MIGHT USE THIS FOR EQUAL ASSIGMENT IN A ROUND ROBIN FASHION
                    if( !groupUserAllocationMap.get(rec.Service_Group__c).isEmpty() ){
                        userId = new List<Id>(groupUserAllocationMap.get(rec.Service_Group__c))[0];
                    }else{

                        groupUserAllocationMap.get(rec.Service_Group__c).addAll(groupUserMap.get(rec.Service_Group__c));

                        if(!groupUserAllocationMap.get(rec.Service_Group__c).isEmpty()){
                            userId = new List<Id>(groupUserAllocationMap.get(rec.Service_Group__c))[0];
                        }
                       
                    }*/
                    
                    if( !groupUserMap.get(vars.serviceGroup).isEmpty() ){
                        
                        Integer smallesCount = 0;

                        for(Id uid :groupUserMap.get(vars.serviceGroup)){

                            if(userLeadCounter.containsKey(uid) ){

                                if( ( userLeadCounter.get(uid) <= smallesCount ) || ( smallesCount == 0 )){

                                    userId = uid;

                                    smallesCount = userLeadCounter.get(uid);
                                }

                            } 
                        }

                        if( userId != '' ){

                            thisResult.ownerId = userId;
                            
                            //Increment Lead allocation count for this user

                            userLeadCounter.put((Id)userId, ( (Integer)userLeadCounter.get(userId) + 1));
    
                            //remove Id from set
                            //DO NOT DELETE - MIGHT USE THIS FOR EQUAL ASSIGMENT IN A ROUND ROBIN FASHION
                            //groupUserAllocationMap.get(rec.Service_Group__c).remove(userId);
                        }
                        
                        results.add(thisResult);

                    }else{

                        thisResult.failed = true;
                        //rec.Process_Date__c = System.now();
                        //rec.Process_Information__c = 'There are no users for Lead assignment, in the public group ' + rec.Service_Group__c;
                        thisResult.errorMessage = 'There are no users for Lead assignment in this branch ' + vars.serviceGroup + 
                        						 ', or not configured correctly, please ask your administrator for help!';
                        
                        results.add(thisResult);
                    }

                }else{
                        thisResult.failed = true;
                    //rec.Process_Date__c = System.now();
                    /*rec.Process_Information__c = 'The Service Group value in the upload file, did NOT match any Public Group Name in Salesforce.\n' +
                                                  'File Service Group Name Value = ' + rec.Service_Group__c;*/
                    thisResult.errorMessage = 'There are no users for Lead assignment in this branch ' + vars.serviceGroup + 
                        						 ', or not configured correctly, please ask your administrator for help!';
                        results.add(thisResult);
                }

            }
            
        }
        return results;
    }
}