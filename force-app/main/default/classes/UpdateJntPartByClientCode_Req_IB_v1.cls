public class UpdateJntPartByClientCode_Req_IB_v1 extends Base_IB{
    
    public String channel;
    public String application;
    public String trace;
    public String clientCode;
    public String teller;
    public String branch;
    public String nbrOfRecords;
    public cls_jntEntry[] jntEntry;
    
    public String errorMessage;
    
    public class cls_jntEntry{
        
        public String actionCode;
        public String idDocType;
        public String idDocNbr;
        public String initials;
        public String titleCode;
        public String surname;
        public String addressLine1;
        public String addressLine2;
        public String suburbRsa;
        public String town;
        public String postalCode;
        public String firstNames;
        public String homeTelephoneCode;
        public String homeTelephoneNbr;
        public String workTelephoneCode;
        public String workTelephoneNbr;
        public String cellphoneNbr;
        public String practiceNumber;
        public String birthDate;
        public String sourceOfIncome;
        public String dateClientFicaIden;
        public String dateClientFicaVeri;
        public String employeeIdentified;
        public String employeeVerified;
        public String taxNumber;
        public String clientNationality;
        public String countryOfOrigin;
        public String tempPermitNumber;
        public String permitExpiryDate;
        public String controllerOverideNbr;
        public String groupScheme;
        public String groupSchemeEmployee;
        public String dateIssued;
        public String dateExempted;
        public String employeeExempted;
        public String exemptionStatus;
        public String exemptionIndicator;
        public String countryOfRes;
        public String countryOfBirth;
        public String occupationStatus;
        public String occupationCode;
        public String saTaxRegis;
        public String rsonSaTaxNotGiven;
        public String foreignTaxRegis;
        public cls_foreignTaxData[] foreignTaxData;
        
    }
    
    public class cls_foreignTaxData{
        
        public String foreignTaxCtry;
        public String foreignTaxNo;
        public String rsonFtaxNotGiven;
    }
    
    public static UpdateJntPartByClientCode_req_IB_v1 createDummy(){
        
        UpdateJntPartByClientCode_req_IB_v1 bean = new UpdateJntPartByClientCode_req_IB_v1();
        List<UpdateJntPartByClientCode_req_IB_v1.cls_jntEntry> jntEntryList = new List<UpdateJntPartByClientCode_req_IB_v1.cls_jntEntry>();
        
        UpdateJntPartByClientCode_req_IB_v1.cls_jntEntry jntEntryBean1 = new UpdateJntPartByClientCode_req_IB_v1.cls_jntEntry();
        jntEntryBean1.actionCode = 'M';
        jntEntryBean1.idDocType = '03';
        jntEntryBean1.idDocNbr = 'GRPJ007';
        jntEntryBean1.initials = 'A';
        jntEntryBean1.titleCode = '1';
        jntEntryBean1.surname = 'GROUPS';
        jntEntryBean1.addressLine1 = 'PO BOX 999';
        jntEntryBean1.addressLine2 = '';
        jntEntryBean1.suburbRsa = '';
        jntEntryBean1.town = 'UMZINTO';
        jntEntryBean1.postalCode = '4200';
        jntEntryBean1.firstNames = 'ANDY';
        jntEntryBean1.homeTelephoneCode = '011';
        jntEntryBean1.homeTelephoneNbr = '7095678';
        jntEntryBean1.workTelephoneCode = '0';
        jntEntryBean1.workTelephoneNbr = '';
        jntEntryBean1.cellphoneNbr = '0827685991';
        jntEntryBean1.practiceNumber = '';
        jntEntryBean1.birthDate = '19670919';
        jntEntryBean1.sourceOfIncome = '0';
        jntEntryBean1.dateClientFicaIden = '20082016';
        jntEntryBean1.dateClientFicaVeri = '01052016';
        jntEntryBean1.employeeIdentified = '6096424';
        jntEntryBean1.employeeVerified = '6096424';
        jntEntryBean1.taxNumber = '2019288467';
        jntEntryBean1.clientNationality = 'SOU01';
        jntEntryBean1.countryOfOrigin = 'SO003';
        jntEntryBean1.tempPermitNumber = '';
        jntEntryBean1.permitExpiryDate = '0';
        jntEntryBean1.controllerOverideNbr = '111';
        jntEntryBean1.groupScheme = '0';
        jntEntryBean1.groupSchemeEmployee = '0';
        jntEntryBean1.dateIssued = '19990412';
        jntEntryBean1.dateExempted = '0';
        jntEntryBean1.employeeExempted = '';
        jntEntryBean1.exemptionStatus = '';
        jntEntryBean1.exemptionIndicator = '';
        jntEntryBean1.countryOfRes = 'SO003';
        jntEntryBean1.countryOfBirth = 'SO003';
        jntEntryBean1.occupationStatus = '02';
        jntEntryBean1.occupationCode = '03';
        jntEntryBean1.saTaxRegis = 'Y';
        jntEntryBean1.rsonSaTaxNotGiven = '';
        jntEntryBean1.foreignTaxRegis = 'Y';
        List<UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData> foreignTaxDataList1 = new List<UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData>();
        UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData foreignTaxDataBean1 = new UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData();
        foreignTaxDataBean1.foreignTaxCtry = 'AF001';
        foreignTaxDataBean1.foreignTaxNo = 'ABCDE12345';
        foreignTaxDataBean1.rsonFtaxNotGiven = '';
        foreignTaxDataList1.add(foreignTaxDataBean1);
        UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData foreignTaxDataBean2 = new UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData();
        foreignTaxDataBean2.foreignTaxCtry = 'AF001';
        foreignTaxDataBean2.foreignTaxNo = 'ABCDE12345';
        foreignTaxDataBean2.rsonFtaxNotGiven = '';
        foreignTaxDataList1.add(foreignTaxDataBean2);
        jntEntryBean1.foreignTaxData = foreignTaxDataList1;
        
        UpdateJntPartByClientCode_req_IB_v1.cls_jntEntry jntEntryBean2 = new UpdateJntPartByClientCode_req_IB_v1.cls_jntEntry();
        jntEntryBean2.actionCode = 'M';
        jntEntryBean2.idDocType = '03';
        jntEntryBean2.idDocNbr = 'BEL45608';
        jntEntryBean2.initials = 'B';
        jntEntryBean2.titleCode = '1';
        jntEntryBean2.surname = 'GROUPS';
        jntEntryBean2.addressLine1 = 'PO BOX 999';
        jntEntryBean2.addressLine2 = '';
        jntEntryBean2.suburbRsa = '';
        jntEntryBean2.town = 'UMZINTO';
        jntEntryBean2.postalCode = '4200';
        jntEntryBean2.firstNames = 'BELLA';
        jntEntryBean2.homeTelephoneCode = '011';
        jntEntryBean2.homeTelephoneNbr = '7095678';
        jntEntryBean2.workTelephoneCode = '039';
        jntEntryBean2.workTelephoneNbr = '3405867';
        jntEntryBean2.cellphoneNbr = '0848598457';
        jntEntryBean2.practiceNumber = '';
        jntEntryBean2.birthDate = '19731012';
        jntEntryBean2.sourceOfIncome = '22';
        jntEntryBean2.dateClientFicaIden = '01072016';
        jntEntryBean2.dateClientFicaVeri = '01072016';
        jntEntryBean2.employeeIdentified = '6096424';
        jntEntryBean2.employeeVerified = '6096424';
        jntEntryBean2.taxNumber = '0';
        jntEntryBean2.clientNationality = 'SOU01';
        jntEntryBean2.countryOfOrigin = 'CZ001';
        jntEntryBean2.tempPermitNumber = '';
        jntEntryBean2.permitExpiryDate = '0';
        jntEntryBean2.controllerOverideNbr = '111';
        jntEntryBean2.groupScheme = '0';
        jntEntryBean2.groupSchemeEmployee = '0';
        jntEntryBean2.dateIssued = '20001212';
        jntEntryBean2.dateExempted = '0';
        jntEntryBean2.employeeExempted = '';
        jntEntryBean2.exemptionStatus = '';
        jntEntryBean2.exemptionIndicator = '';
        jntEntryBean2.countryOfRes = 'CZ001';
        jntEntryBean2.countryOfBirth = 'SO003';
        jntEntryBean2.occupationStatus = '03';
        jntEntryBean2.occupationCode = '04';
        jntEntryBean2.saTaxRegis = '';
        jntEntryBean2.rsonSaTaxNotGiven = '';
        jntEntryBean2.foreignTaxRegis = '';
        List<UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData> foreignTaxDataList2 = new List<UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData>();
        UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData foreignTaxDataBean3 = new UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData();
        foreignTaxDataBean3.foreignTaxCtry = 'AF001';
        foreignTaxDataBean3.foreignTaxNo = 'ABCDE12345';
        foreignTaxDataBean3.rsonFtaxNotGiven = '';
        foreignTaxDataList2.add(foreignTaxDataBean3);
        UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData foreignTaxDataBean4 = new UpdateJntPartByClientCode_req_IB_v1.cls_foreignTaxData();
        foreignTaxDataBean4.foreignTaxCtry = 'AF001';
        foreignTaxDataBean4.foreignTaxNo = 'ABCDE12345';
        foreignTaxDataBean4.rsonFtaxNotGiven = '';
        foreignTaxDataList2.add(foreignTaxDataBean4);
        jntEntryBean2.foreignTaxData = foreignTaxDataList2;
        
        jntEntryList.add(jntEntryBean1);
        jntEntryList.add(jntEntryBean2);
        
        
        bean.channel = 'SALESFORCE';
        bean.application = 'WILLS';
        bean.trace = 'N';
        bean.clientCode = 'GROUPA+001';
        bean.teller = '6096424';
        bean.branch = '8198';
        bean.nbrOfRecords = '2';
        bean.jntEntry = jntEntryList;
        
        return bean;
    }
    
}