/**
 * @description       : Controller class for WCC
 * @author            : Ravi B, Srinivas G,Vara
 * @group             : 
 * @last modified on  : 09-01-2021
 * @last modified by  : Tawanda M.
**/
public class CalculatorsSectionController {
   
    /** This class is used to display the Working calculors input into the dable.
    * 
    * @return List<String> It returns the List of Calculator values. 
    */
    public static final List<String> SALESTOOLS = new List<String>{
        'Working Capital Calculator', 
        'Debt Capacity Calculator -General', 
        'Debt Capacity Calculator -MBBL'
    };
    
    public static final Map<String, String> LABELSTODISPLAY = new Map<String, String>{
        'year' => 'Header:Financial Statement Period Ending',
        'turnover' => 'Turnover',
        'costOfSales' => 'Cost of Sales',
        'cash' => 'Cash',
        'inventories' => 'Inventories',
        'receivables' => 'Receivables',
        'payables' => 'Payables'
    };
        
    /**
    * @description Structure
    * @author Ravi B, Srinivas G,Vara | 07-20-2021 
    **/
    public class TableDataWrapper {
        @AuraEnabled public Opportunity opportunityRecord;
        @AuraEnabled public ChannelCalculatorDTOJSON channelCalculatorDTO;
        @AuraEnabled public String tableTitle;
        @AuraEnabled public Map<String, List<String>> rowData;
        
        /**
        * @description Construct
        * @author Ravi B, Srinivas G,Vara | 09-01-2021 
        * @param tableTitle 
        **/
        public void initializeVariables(String tableTitle) {
            this.tableTitle = tableTitle;
            this.rowData = new Map<String, List<String>>();
        }
    }   
    
    /**
    * @description Structure
    * @author Ravi B, Srinivas G,Vara | 07-20-2021 
    **/
    public class ChannelCalculatorDTOJSON {
        @AuraEnabled public List<CalculatorWCCJSON> workingCapital;
    }   

    /**
    * @description Structure
    * @author Ravi B, Srinivas G,Vara | 07-20-2021 
    **/
    public class CalculatorWCCJSON {
        @AuraEnabled public Integer year;
        @AuraEnabled public String dated;
        @AuraEnabled public Decimal turnOver;
        @AuraEnabled public Decimal costOfSales;
        @AuraEnabled public Decimal cash;
        @AuraEnabled public Decimal inventories;
        @AuraEnabled public Decimal receivables;
        @AuraEnabled public Decimal payables;
        @AuraEnabled public Boolean useInCalc;
    }
    
   
    /**
    * @description This class is used to display the Working calculors input into the table
    * @author Ravi B, Srinivas G,Vara | 09-01-2021 
    * @param opportunityId 
    * @return TableDataWrapper 
    **/
    @AuraEnabled
    public static TableDataWrapper fetchTableData(String opportunityId) {
        final TableDataWrapper tableData;
        try{
            tableData = retrieveJSONDataForWCC(opportunityId);
        } catch(Exception ex) {
            AuraHandledException e = new AuraHandledException('');
            e.setMessage('Exception encounterred - '+ex.getMessage());
            throw e;
        }
        return tableData;
    }
    
    /**
    * @description This class is used to display the Working calculors input into the table
    * @author Ravi B, Srinivas G,Vara | 09-01-2021 
    * @param opportunityId 
    * @param newJsonData 
    * @return TableDataWrapper 
    **/
    @AuraEnabled
    public static TableDataWrapper saveTableData(String opportunityId, String newJsonData) {
        TableDataWrapper tableData;
        try {
            tableData = fetchTableData(opportunityId);
            tableData.channelCalculatorDTO.workingCapital = String.isBlank(newJsonData) ? new List<CalculatorWCCJSON>() : (List<CalculatorWCCJSON>) JSON.deserialize(newJsonData, List<CalculatorWCCJSON>.class);
            String storedJSONData = JSON.serializePretty(tableData.channelCalculatorDTO);
            storedJSONData = storedJSONData.replaceAll('"dated"','"date"');
            Opportunity oppRec = new Opportunity();
            oppRec.id = opportunityId;
            oppRec.Calculator_Request_Message__c = '{"data" : { "channelCalculatorDTO" : '+ storedJSONData + ' } }';
            update oppRec;
            tableData = fetchTableData(opportunityId);
        } catch(Exception ex) {
            AuraHandledException e = new AuraHandledException('');
            e.setMessage('Exception encounterred - '+ex.getMessage());
            throw e;
        }
        return tableData;
    }
    private static TableDataWrapper retrieveJSONDataForWCC(String opportunityId) {
        final TableDataWrapper tableData = retrieveDataFromOpportunity(opportunityId);
        
        tableData.initializeVariables('Working capital calculators input');
        tableData.rowData.put(LABELSTODISPLAY.get('year'), new List<String>());
        tableData.rowData.put(LABELSTODISPLAY.get('turnover'), new List<String>());
        tableData.rowData.put(LABELSTODISPLAY.get('costOfSales'), new List<String>());
        tableData.rowData.put(LABELSTODISPLAY.get('cash'), new List<String>());
        tableData.rowData.put(LABELSTODISPLAY.get('inventories'), new List<String>());
        tableData.rowData.put(LABELSTODISPLAY.get('receivables'), new List<String>());
        tableData.rowData.put(LABELSTODISPLAY.get('payables'), new List<String>());
        for(CalculatorWCCJSON fiRecord : tableData.channelCalculatorDTO.workingCapital) {
            tableData.rowData.get(LABELSTODISPLAY.get('year')).add(String.valueOf(fiRecord.year));
            tableData.rowData.get(LABELSTODISPLAY.get('turnover')).add(String.valueOf(fiRecord.turnover));
            tableData.rowData.get(LABELSTODISPLAY.get('costOfSales')).add(String.valueOf(fiRecord.costOfSales));
            tableData.rowData.get(LABELSTODISPLAY.get('cash')).add(String.valueOf(fiRecord.cash));
            tableData.rowData.get(LABELSTODISPLAY.get('inventories')).add(String.valueOf(fiRecord.inventories));
            tableData.rowData.get(LABELSTODISPLAY.get('receivables')).add(String.valueOf(fiRecord.receivables));
            tableData.rowData.get(LABELSTODISPLAY.get('payables')).add(String.valueOf(fiRecord.payables));
        }
        return tableData;
    }
    
    private static TableDataWrapper retrieveDataFromOpportunity(String opportunityId) {
        Opportunity opportunityRecord = [SELECT id, 
                                            Calculator_Request_Message__c, 
                                            Calculator_Response_Message__c,
                                            Reason_for_Not_Taken_Up__c,
                                            StageName,
                                            CheckMandatoryDocuments__c
                                            FROM Opportunity 
                                            WHERE id=: opportunityId];
        String storedJSONData = opportunityRecord.Calculator_Request_Message__c;
                                    
        if(String.isBlank(storedJSONData)) {
            storedJSONData = '{"data" : { "channelCalculatorDTO" : {"workingCapital" : []} } }'; 
        }
        storedJSONData = storedJSONData.replaceAll('"date"','"dated"');
        storedJSONData = storedJSONData.replace('{"data" :',''); 
        storedJSONData = storedJSONData.removeEnd('}');
        TableDataWrapper tdw = (TableDataWrapper) JSON.deserialize(storedJSONData, TableDataWrapper.class);
        tdw.opportunityRecord = opportunityRecord;
        return tdw;
    }
}