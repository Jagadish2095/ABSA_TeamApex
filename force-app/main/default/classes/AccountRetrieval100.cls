//**********************************************************************************
//
//            Copyright 2016 Enghouse Interactive. All rights reserved
//
// The source code contained or described herein and all documents related to the
// source code ("Material") are owned by Enghouse Interactive or its suppliers or
// licensors.  Title to the Material remains with Enghouse Interactive or its
// suppliers and licensors.  The Material contains trade secrets and proprietary
// and confidential information of Enghouse or its suppliers and licensors.  The
// Material is protected by worldwide copyright and trade secret laws and treaty
// provisions. No part of the Material may be used, copied, reproduced, modified,
// published, uploaded, posted, transmitted, distributed, or disclosed in any way
// without Enghouse's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials,  either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be express
// and approved by Enghouse in writing.
//
//**********************************************************************************

//
// Modification History
//
// 3.001    James Holdcroft 3-Dec-2013
// First version
//
// 3.002    Philip Simons   9-Apr-1015
// Second version - with additional methods
//
// 3.003    Philip Simons   5-Aug-1015
// Third version - with user info and improved getCaller
//
// 3.004    Philip Simons   15-Oct-1015
// Forth version - with improved getCaller to cope with callerId starting with 9
//
// 3.005    Philip Simons   25-Feb-1016
// Fifth version - get current date and time as string
//
// 3.006    Philip Simons   18-Apr-1016
// Sixth version - improve objectQuery 
//
// 3.007    Philip Simons   10-May-1016
// Seventh version - improve objectQuery 
//
// 3.008    Philip Simons   20-Sep-1016
// Eighth version - added handleConvertedLead
//
// 3.008.1 Philip Simons   28-Oct-1016
// Minor fix to prevent errors when saving task when a lead conversion is happening at the same time
//
// 3.100 Steve Rogers   09-Oct-2017
// CRM-594: Added a new class: GetTaskInfo to be used by a transfer/conference target to get the Subject and Comments from a call log by its sfTaskId
//
// 3.100 Mazhar Nazeer 28-Nov-2017
// Class Name is updated with 100. This should be incremented for every version release.
//


global class AccountRetrieval100{    
    webService static String GetEIApexVersion()
    {
        return '3.100';
    }
    static List<List<SObject>> getCallerInt(String callerId)
    {
         String scallerId=callerId;
        //remove initial '+'
        if(callerId.length()>0)
        {
            if(callerId.startsWith('+'))
            {
                callerId=callerId.substring(1);
            }
        }
        if(callerId.length()>0)
        {
            callerId=callerId+' or '+callerId.substring(1);
        }
        
        List<List<SObject>> searchList = [FIND  :callerId IN PHONE FIELDS RETURNING ACCOUNT(Type,AccountNumber,Name,Id),CASE(CaseNumber,Status,Priority,Id),CONTACT(Title,Name,Id),LEAD(Company,Title,LeadSource,Name,Id)];
        return searchList;       
    }
    webService static String getCaller(String callerId) {
        try{
        
            return JSON.serialize(getCallerInt(callerId));
        
        } catch(Exception e){
            return 'Error: ' +e.getMessage() + ' Line: ' + e.getLineNumber();
        }
    }
    
    webService static String adhocQuery(String sosl) {
        List<List<SObject>> searchList = search.query(sosl);
        String JSONString = JSON.serialize(searchList);
        return JSONString;
    }
    //dynamic query using list of query lines
    static List<SObject> DynamicQuery(String typeName,String queryStr,List<String> queryList)
    {
        Object arg0;
        Object arg1;
        Object arg2;
        Object arg3;
        Object arg4;
        Object arg5;
        Object temp;
       
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objType = schemaMap.get(typeName);
        
        for(Integer argCnt=0;argCnt<queryList.size();argCnt++)
        {
            Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
            Schema.DisplayType fieldType=fieldMap.get(
                queryList[argCnt].substringBefore('=').substringAfter('.').trim()).
                getDescribe().getType();
            
            if(fieldType==Schema.DisplayType.Boolean)temp=Boolean.valueOf(queryList[argCnt].substringAfter('=').trim());
            else if(fieldType==Schema.DisplayType.Date)temp=Date.valueOf(queryList[argCnt].substringAfter('=').trim());
            else if(fieldType==Schema.DisplayType.DateTime)temp=DateTime.valueOf(queryList[argCnt].substringAfter('=').trim());
            else if(fieldType==Schema.DisplayType.Double)temp=Double.valueOf(queryList[argCnt].substringAfter('=').trim());
            else if(fieldType==Schema.DisplayType.Integer)temp=Integer.valueOf(queryList[argCnt].substringAfter('=').trim());
            else if(fieldType==Schema.DisplayType.Percent)temp=Double.valueOf(queryList[argCnt].substringAfter('=').trim());
            else temp=queryList[argCnt].substringAfter('=');
            
            if(argCnt==0)arg0=temp;
            else if(argCnt==1)arg1=temp;
            else if(argCnt==2)arg2=temp;
            else if(argCnt==3)arg3=temp;
            else if(argCnt==4)arg4=temp;
            else if(argCnt==5)arg5=temp;
 
            if(argCnt>0)
            {
                querystr=queryStr+' AND ';
            }
            queryStr=queryStr+queryList[argCnt].substringBefore('=')+'=';
            queryStr=queryStr+':arg'+argCnt;
        }
        return database.query(queryStr);
    }
    webService static String objectQuery(String defaultANI,String params)
    {
        List<List<Object>> queryList = new List<List<Object>>();
        List<SObject> tempList;
        boolean found=false;
        String[] paramArr=(String[])JSON.deserialize(params,String[].class);
        String aniQuery='';
        List<String> CaseQuery=new List<String>();
        List<String> AccountQuery=new List<String>();
        List<String> ContactQuery=new List<String>();
        List<String> LeadQuery=new List<String>();
        String urlQuery='';
    
        for(String str:paramArr)
        {
            String[] spl=str.Split('\t');
            if(spl[0]=='IQ')
            {
                String objName=spl[1].substringBefore('.').toUpperCase().trim();
                if(objName=='CASE'){
                    CaseQuery.add(spl[1]);    
                }else if(objName=='ACCOUNT'){
                    AccountQuery.add(spl[1]);
                }else if(objName=='CONTACT'){
                    ContactQuery.add(spl[1]);
                }else if(objName=='LEAD'){
                    LeadQuery.add(spl[1]);
                }else {
                    if(urlQuery.length()>0)
                    {
                        urlQuery=urlQuery+'&';
                    }
                    urlQuery=urlQuery+spl[1].substringBefore('=')+'='+
                        EncodingUtil.urlEncode(spl[1].substringAfter('='),'UTF-8');
                }    
            }else if(spl[0]=='OA'){
                aniQuery=spl[1];    
            }
        }        
        
        if(AccountQuery.size()>0)
        {
            tempList=DynamicQuery('Account','Select Type,AccountNumber,Name,Id from Account where ',AccountQuery);
            found|=tempList.size()>0;
            queryList.add(tempList);
        }else{
            queryList.add(new List<Account>());
        }
        if(CaseQuery.size()>0)
        {
            tempList=DynamicQuery('Case','Select CaseNumber,Status,Priority,Id from Case where ',CaseQuery);
            found|=tempList.size()>0;
            queryList.add(tempList);
        }else{
            queryList.add(new List<Case>());
        }

        if(ContactQuery.size()>0)
        {
            tempList=DynamicQuery('Contact','Select Title,Name,Id from Contact where ',ContactQuery);
            found|=tempList.size()>0;
            queryList.add(tempList);
        }else{
            queryList.add(new List<Contact>());
        }

        if(LeadQuery.size()>0)
        {
            tempList=DynamicQuery('Lead','Select Company,Title,LeadSource,Name,Id from Lead where ',LeadQuery);
            found|=tempList.size()>0;
            queryList.add(tempList);
        }else{
            queryList.add(new List<Lead>());
        }
        if(urlQuery.length()>0)
        {
            found|=true;
            List<Object> temp=new List<Object>();
            temp.add((Object)urlQuery);
            queryList.add(temp);
        }
        if(!found&&(aniQuery.trim().length()>0))
        {
            queryList=getCallerInt(aniQuery.trim());
            for(List<Object> so:queryList)
            {
                if(so.size()>0)
                {
                    found=true;
                }
            }
        }
        if(!found)
        {
            queryList=getCallerInt(defaultANI);
        }

        return JSON.serialize(queryList);
    }
    
    webService static String getAutoLoginInfo()
    {
        String user=UserInfo.getUserid();
        Sobject[] s=[SELECT name,phone,extension,id From User WHERE id=:user];
        String JSONString = JSON.serialize(s);
        return JSONString; 
    }
    webService static String getToday()
    {
        return date.today().format();
    }
    webService static String getNow()
    {
        return System.now().format();
    }
    webService static String getTaskInfo(String taskId)
    {
        Task[] tasks = [Select Id, Subject, Description from Task where id=:taskId];
        String JSONString = JSON.serialize(tasks);
        return JSONString;
    }
    
    private static final Integer MAX_ATTEMPTS = 3;
    
    public class HandleConvertedLeadInfo
    {
        private String m_WhoId;
        private String m_WhatId;
        private String m_RelatedName;
        private String m_RelatedId;
        private Lead m_LockedLead;
        public String WhoId{get{return m_WhoId;}}
        public String WhatId{get{return m_WhatId;}}
        public String RelatedName{get{return m_RelatedName;}}
        public String RelatedId{get{return m_RelatedId;}}
        public Lead LockedLead{get{return m_LockedLead;}}
        public HandleConvertedLeadInfo(String whoId,String whatId,String relatedName,String relatedId,Lead lockedLead)
        {
            m_WhoId=whoId;
            m_WhatId=whatId;
            m_RelatedName=relatedName;
            m_RelatedId=relatedId;
            m_LockedLead=lockedLead;
        }
        public HandleConvertedLeadInfo(String whoId,String whatId)
        {
            m_WhoId=whoId;
            m_WhatId=whatId;  
            if(whoId!='')
            {
                m_RelatedId=whoId;
            }else{
                m_RelatedId=whatId;
            }
            if(m_RelatedId!='')
            {
                ID id=(ID)m_RelatedId;
                Schema.SObjectType token = id.getSObjectType(); 
                Schema.DescribeSObjectResult dr = token.getDescribe();
                m_RelatedName=dr.getName();
            }       
        }
    }
    //return the opportunity/Contact/Account for the first converted lead, or the first objectId for any other object
    //selectWhichConverted bit0=1 to include opportunity
    //selectWhichConverted bit1=1 to include contact
    //selectWhichConverted bit2=1 to include account
    static HandleConvertedLeadInfo handleConvertedLead(String whos,String whatId,Integer selectWhichConverted,String relatedName,String relatedId)
    {
        String[] whoIds=(String[])JSON.deserialize(whos,String[].class);
                
        for(String objectId:whoIds)
        {
            if(objectId!='')
            {
                Id id=(Id)objectId;
                Schema.SObjectType token = id.getSObjectType(); 
                Schema.DescribeSObjectResult dr = token.getDescribe();
                string temp='select id from '+dr.getName()+' where id=\''+objectid+'\'';
                if(Database.query(temp).size()>0)
                {
                    if(dr.getName()=='Lead')//lead
                    {
                        Lead alead=[SELECT id,ConvertedOpportunityId,ConvertedContactId,ConvertedAccountId,Name From Lead WHERE id=:objectId LIMIT 1 FOR UPDATE]; 
    
                        if((alead.ConvertedOpportunityId==null)&&
                                (alead.ConvertedContactId==null)&&
                                (alead.ConvertedAccountId==null))
                        {
                            //non-converted lead
                            return new HandleConvertedLeadInfo(objectId,'','Lead '+alead.Name,objectId,alead);
                        }
                
                        if((selectWhichConverted&1)==1)
                        {
                            if(alead.ConvertedOpportunityId!=null)
                            {
                                Opportunity[] op=[SELECT name From Opportunity WHERE id=:alead.ConvertedOpportunityId];
                                if(op.size()>0)
                                {
                                    relatedName='Opportunity '+op[0].Name;
                                }
                                return new HandleConvertedLeadInfo('',alead.ConvertedOpportunityId,relatedName,alead.ConvertedOpportunityId,alead);
                            }
                        }
                        if((selectWhichConverted&2)==2)
                        {
                            if(alead.ConvertedContactId!=null)
                            {
                                Contact[] op=[SELECT name From Contact WHERE id=:alead.ConvertedContactId];
                                if(op.size()>0)
                                {
                                    relatedName='Contact '+op[0].Name;
                                }
                                return new HandleConvertedLeadInfo(alead.ConvertedContactId,'',relatedName,alead.ConvertedContactId,alead); 
                            }
                        }
                        if((selectWhichConverted&4)==4)
                        {
                            if(alead.ConvertedAccountId!=null)
                            {
                                Account[] op=[SELECT name From Account WHERE id=:alead.ConvertedAccountId];
                                if(op.size()>0)
                                {
                                    relatedName='Account '+op[0].Name;
                                }
                                return new HandleConvertedLeadInfo('',alead.ConvertedAccountId,relatedName,alead.ConvertedAccountId,alead); 
                            }
                        }
                    }else{
                        //other whoid object
                        if(relatedId=='')
                        {
                            return new HandleConvertedLeadInfo(objectId,'');        
                        }        
                        return new HandleConvertedLeadInfo(objectId,'',relatedName,relatedId,null);
                    }   
                }
            }
        }
        //whatId object
        if(relatedId=='')
        {
            return new HandleConvertedLeadInfo('',whatId);  
        }
        return new HandleConvertedLeadInfo('',whatId,relatedName,relatedId,null);
    }
    static void actuallySaveTaskInfo(Task newTask,Map<String, String> retval,String whos,String whatId,Integer selectWhichConverted,String relatedName,String relatedId)
    {
        Integer attempts = MAX_ATTEMPTS;
        
        while(attempts > 0)
        {
            try
            {
                attempts--;
                
                HandleConvertedLeadInfo whoWhat=handleConvertedLead(whos,whatId,selectWhichConverted,relatedName,relatedId);
                
                retval.put('relatedName',whoWhat.RelatedName);
                retval.put('relatedId',whoWhat.RelatedId);
                            
                if (whoWhat.WhoId != '')
                {
                    newTask.whoId = whoWhat.WhoId;
                    retval.put('whoId',whoWhat.WhoId);
                }
                else
                {
                    //n.b. WHOID AND WHATID ARE MUTUALLY EXCLUSIVE
                    if (whoWhat.WhatId != '')
                    {
                        newTask.whatId = whoWhat.WhatId;
                        retval.put('whatId' ,whoWhat.whatId);
                    }
                }
                   
                upsert newTask; 
                attempts = 0;
            } catch(System.Exception dmlEx)
            {
                if(!dmlEx.getMessage().contains('Record Currently Unavailable'))
                {
                    attempts = 0;
                    throw dmlEx;
                }
                else if(attempts == 0)
                {
                    throw dmlEx;
                }
            }
        }
    }
    webService static String saveTaskInfo(String whos,String whatId,String relatedName,String relatedId,String saveParams,Integer selectWhat)
    {
        Map<String, String> retval=new Map<String, String>();

        try
        {
            Map<String, String> m = (Map<String, String>)JSON.deserialize(saveParams,Map<String,String>.class);

            Date activityDate=Date.newInstance(
                Integer.valueOf(m.get('ActivitydateYear')),
                Integer.valueOf(m.get('ActivitydateMonth')),
                Integer.valueOf(m.get('ActivitydateDay')));
            
            Task newTask=new Task(Subject=m.get('Subject'), Status=m.get('Status'), CallType=m.get('CallType'),
                Activitydate=activityDate, CallObject=m.get('CallObject'), Type='Call',
                Description=m.get('Description'), CallDurationInSeconds=integer.valueof(m.get('CallDurationInSeconds')));   
            
            if(m.containsKey('Id'))
            {
                newTask.Id=m.get('Id');
            }
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Task.fields.getMap();
                    
            if(m.containsKey('CTI_ANI__c')&&fieldMap.containsKey('CTI_ANI__c'))
            {
                newTask.put('CTI_ANI__c',m.get('CTI_ANI__c'));
            }
            if(m.containsKey('CTI_DNIS__c')&&fieldMap.containsKey('CTI_DNIS__c'))
            {
                newTask.put('CTI_DNIS__c',m.get('CTI_DNIS__c'));
            } 
            if(m.containsKey('ANI_Match__c')&&fieldMap.containsKey('ANI_Match__c'))
            {
                newTask.put('ANI_Match__c',boolean.valueof(m.get('ANI_Match__c')));
            }
            if(m.containsKey('GlobalRefId__c')&&fieldMap.containsKey('GlobalRefId__c'))
            {
                newTask.put('GlobalRefId__c',m.get('GlobalRefId__c'));
            }           
            
            actuallySaveTaskInfo(newTask,retval,whos,whatId,selectWhat,relatedName,relatedId);  
            
            retval.put('sfTaskId',newTask.Id);    
        }
        catch(Exception e)
        {
            retval.put('Error',e.getMessage()+':'+string.valueOf(e.getLineNumber()));
        }                  
        return JSON.serialize(retval);    
    }
}