/*
* Response Integration Bean for TransunionProcessRequest41 Service
* @author Prashant Jain
* @created 2020-05-20
*--------------------------------------
* @Updated By - Pitso Sekhu
* @Updated Date- 2021-03-18
* @Update Notes - Changes to EnquirerContactPhoneNo & EnquirerContactName from Hard coded value to Custom Label
*--------------------------------------
*/

public class TransunionProcessRequest41_Resp_IB_v1 extends Base_IB {

    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    public class StandardBatchCharsSB37 {
    }

    public class AffordabilityAF01 {
    }

    public class AggregateNX09 {
    }

    public class IVSBV01 {
    }

    public class TRLTQ01 {
    }

    public class AffordStandardBatchCharsXB01 {
    }

    public class ConsumerInfoNO05 {
    }

    public class ProcessRequestTrans41Result {
        @AuraEnabled public String ErrorMessage;
        @AuraEnabled public String ResponseStatus;
        @AuraEnabled public String ProcessingStartDate;
        @AuraEnabled public String ProcessingTimeSecs;
        @AuraEnabled public String UniqueRefGuid;
        @AuraEnabled public AddressNA07_Z AddressNA07;
        @AuraEnabled public AddressVerificationNR01 AddressVerificationNR01;
        @AuraEnabled public AddressVerificationNR02 AddressVerificationNR02;
        @AuraEnabled public AffordabilityAF01 AffordabilityAF01;
        @AuraEnabled public AffordStandardBatchCharsXB01 AffordStandardBatchCharsXB01;
        @AuraEnabled public AggregateAG01 AggregateAG01;
        @AuraEnabled public AggregateAG02 AggregateAG02;
        @AuraEnabled public AggregateNX05 AggregateNX05;
        @AuraEnabled public AggregateNX09 AggregateNX09;
        @AuraEnabled public AggregateNX33 AggregateNX33;
        @AuraEnabled public AlertDetailC4 AlertDetailC4;
        @AuraEnabled public BCCBC01 BCCBC01;
        @AuraEnabled public AggregateAG02 BCCBC03;
        @AuraEnabled public AggregateAG02 BCCBC04;
        @AuraEnabled public AggregateAG02 BCCB701;
        @AuraEnabled public AggregateAG02 BCCC1;
        @AuraEnabled public AggregateAG02 BCCC2;
        @AuraEnabled public CCASummaryMX01 CCASummaryMX01;
        @AuraEnabled public CCASummaryMX01 CCASummaryMX50;
        @AuraEnabled public ConsEnqTransInfo0102 ConsEnqTransInfo0102;
        @AuraEnabled public ConsumerCountersNC04 ConsumerCountersNC04;
        @AuraEnabled public ConsumerCountersNC50 ConsumerCountersNC50;
        @AuraEnabled public ConsumerInfoNO04 ConsumerInfoNO04;
        @AuraEnabled public ConsumerInfoNO05 ConsumerInfoNO05;
        @AuraEnabled public AggregateAG02 ConsumerTelephoneHistoryNW01;
        @AuraEnabled public CreditVisionVV01 CreditVisionVV01;
        @AuraEnabled public CreditVisionScoreCO01 CreditVisionScoreCO01;
        @AuraEnabled public CreditVisionVV01 CreditVisionVX01;
        @AuraEnabled public DebtCounsellingDC01 DebtCounsellingDC01;
        @AuraEnabled public DisputeIndicatorDI01 DisputeIndicatorDI01;
        @AuraEnabled public EchoData0001 EchoData0001;
        @AuraEnabled public EmpiricaEM04 EmpiricaEM04;
        @AuraEnabled public EmpiricaEM05 EmpiricaEM05;
        @AuraEnabled public EmpiricaEM07 EmpiricaEM07;
        @AuraEnabled public FSMS201 FSMS201;
        @AuraEnabled public FraudScoreFS01 FraudScoreFS01;
        @AuraEnabled public FraudScoreFS01 FraudScoreFS01Part2;
        @AuraEnabled public HawkNH05 HawkNH05;
        @AuraEnabled public IdvNI01 IdvNI01;
        @AuraEnabled public IdvNI02 IdvNI02;
        @AuraEnabled public IdvNI03 IdvNI03;
        @AuraEnabled public IncomeEstimatorT101 IncomeEstimatorT101;
        @AuraEnabled public IncomeEstimatorT101 IncomeEstimatorT102;
        @AuraEnabled public CreditVisionScoreCO01 IncomeEstimatorI401;
        @AuraEnabled public IVSBV01 IVSBV01;
        @AuraEnabled public CreditVisionScoreCO01 LapseL401;
        @AuraEnabled public LinkagesLK LinkagesLK;
        @AuraEnabled public NLRConfirmationMR01 NLRConfirmationMR01;
        @AuraEnabled public NLRConfirmationMR01 NLRConfirmationMZ01;
        @AuraEnabled public CCASummaryMX01 NLRSummaryMY01;
        @AuraEnabled public CCASummaryMX01 NLRSummaryMY50;
        @AuraEnabled public EmployerInformation EmployerInformation;
        @AuraEnabled public ScoreCardAC01 ScoreCardAC01;
        @AuraEnabled public ScoreCardBX01 ScoreCardBX01;
        @AuraEnabled public ScoreCardBX03 ScoreCardBX03;
        @AuraEnabled public AggregateAG02 StandardBatchCharsB101;
        @AuraEnabled public AggregateAG02 StandardBatchCharsFA01;
        @AuraEnabled public AggregateAG02 StandardBatchCharsFA02;
        @AuraEnabled public AggregateAG02 StandardBatchCharsFA03;
        @AuraEnabled public StandardBatchCharsSB04 StandardBatchCharsSB04;
        @AuraEnabled public StandardBatchCharsSB07 StandardBatchCharsSB07;
        @AuraEnabled public StandardBatchCharsSB13 StandardBatchCharsSB13;
        @AuraEnabled public StandardBatchCharsSB18 StandardBatchCharsSB18;
        @AuraEnabled public StandardBatchCharsSB19 StandardBatchCharsSB19;
        @AuraEnabled public StandardBatchCharsSB25 StandardBatchCharsSB25;
        @AuraEnabled public StandardBatchCharsSB27 StandardBatchCharsSB27;
        @AuraEnabled public StandardBatchCharsSB30 StandardBatchCharsSB30;
        @AuraEnabled public StandardBatchCharsSB33 StandardBatchCharsSB33;
        @AuraEnabled public StandardBatchCharsSB37 StandardBatchCharsSB37;
        @AuraEnabled public StandardBatchCharsSB40 StandardBatchCharsSB40;
        @AuraEnabled public AggregateAG02 StandardBatchCharsSB99;
        @AuraEnabled public TraceAlertTL TraceAlertTL;
        @AuraEnabled public TRLTQ01 TRLTQ01;
        @AuraEnabled public TRLTN01 TRLTN01;
        @AuraEnabled public CreditVisionScoreCO01 TRLTO01;
        @AuraEnabled public TicketSuccessConfirmationFR TicketSuccessConfirmationFR;
        @AuraEnabled public UniqueITCRef UniqueITCRef;
        @AuraEnabled public ClaimantHeaderCH ClaimantHeaderCH;
        @AuraEnabled public ClaimantHeaderHC ClaimantHeaderHC;
        @AuraEnabled public StrikeDateOutput StrikeDateOutput;
        @AuraEnabled public LapseOutputV3 LapseOutputV3;
        @AuraEnabled public AKANamesNK04_Z AKANamesNK04;//W-0004850
        @AuraEnabled public EmploymentNM04_Z EmploymentNM04;//W-0004850
        @AuraEnabled public NoticesNN08_Z NoticesNN08;//W-0004850
        @AuraEnabled public JudgementsNJ07_Z JudgementsNJ07;//W-0004850
        @AuraEnabled public DefaultsD701Part1_Z DefaultsD701Part1;//W-0004850
        @AuraEnabled public EnquiriesNE50_Z EnquiriesNE50;//W-0004850
    }

    public class ConsumerInfoNO04 {
        @AuraEnabled public String RecordSeq;
        @AuraEnabled public String Part;
        @AuraEnabled public String PartSeq;
        @AuraEnabled public String ConsumerNo;
        @AuraEnabled public String Surname;
        @AuraEnabled public String Forename1;
        @AuraEnabled public String Title;
        @AuraEnabled public String Gender;
        @AuraEnabled public String NameInfoDate;
        @AuraEnabled public String DateOfBirth;
        @AuraEnabled public String IdentityNo1;
        @AuraEnabled public String Dependants;
        @AuraEnabled public String DeceasedDate;
        @AuraEnabled public String Forename2;//W-0004850
        @AuraEnabled public String Forename3;//W-0004850
        @AuraEnabled public String MaritalStatusDesc;//W-0004850
        @AuraEnabled public String TelephoneNumbers;//W-0004850
        @AuraEnabled public String SpouseName1;//W-0004850
    }

    public class ConsEnqTransInfo0102 {
        @AuraEnabled public String DefiniteMatchCount;
        @AuraEnabled public String PossibleMatchCount;
        @AuraEnabled public String MatchedConsumerNo;
    }

    public class UniqueITCRef {
        @AuraEnabled public String ITCReferenceNumber;//W-0004850
    }

    public class ConsumerCountersNC04 {
        @AuraEnabled public String TraceAlerts1YrBack;//W-0004850
        @AuraEnabled public String TraceAlerts2YrsBack;//W-0004850
        @AuraEnabled public String TraceAlertsMoreThen2YrsBack;//W-0004850
    }

    public class AddressVerificationNR01 {
    }

    public class AddressVerificationNR02 {
    }

    public class ConsumerCountersNC50 {
        @AuraEnabled public String ConsumerNo;
        @AuraEnabled public String OwnEnquiries1YrBack;
        @AuraEnabled public String OwnEnquiries2YrsBack;
        @AuraEnabled public String OwnEnquiriesMoreThen2YrsBack;
        @AuraEnabled public String OtherEnquiries1YrBack;
        @AuraEnabled public String OtherEnquiries2YrsBack;
        @AuraEnabled public String OtherEnquiriesMoreThen2YrsBack;
        @AuraEnabled public String Judgements1YrBack;
        @AuraEnabled public String Judgements2YrsBack;
        @AuraEnabled public String JudgementsMoreThen2YrsBack;
        @AuraEnabled public String Notices1YrBack;
        @AuraEnabled public String Notices2YrsBack;
        @AuraEnabled public String NoticesMoreThen2YrsBack;
        @AuraEnabled public String Defaults1YrBack;
        @AuraEnabled public String Defaults2YrsBack;
        @AuraEnabled public String DefaultsMoreThen2YrsBack;
        @AuraEnabled public String PaymentProfiles1YrBack;
        @AuraEnabled public String PaymentProfiles2YrsBack;
        @AuraEnabled public String PaymentProfilesMoreThen2YrsBack;
        @AuraEnabled public String TraceAlerts1YrBack;
        @AuraEnabled public String TraceAlerts2YrsBack;
        @AuraEnabled public String TraceAlertsMoreThen2YrsBack;
    }

    public class ScoreCardAC01 {
        @AuraEnabled public String CreditScore;//W-0004850
    }

    public class StandardBatchCharsSB33 {
    }

    public class CreditVisionScoreCO01 {
    }

    public class AggregateNX05 {
    }

    public class StandardBatchCharsSB30 {
    }

    public class CreditVisionVV01 {
    }

    public class EnquiriesNE50_Z {
        @AuraEnabled public List<EnquiryNE50> EnquiryNE50;
    }

    public class EnquiryNE50 {
        @AuraEnabled public String ConsumerNo;
        @AuraEnabled public String DateOfEnquiry;
        @AuraEnabled public String Subscriber;
        @AuraEnabled public String Contact;
        @AuraEnabled public String EnquiryTypeCode;
        @AuraEnabled public String EnquiryTypeDescription;
        @AuraEnabled public String OwnAccount;
    }

    public class StandardBatchCharsSB25 {
    }

    public class AddressNA07_Z {
        @AuraEnabled public List<AddressNA07> AddressNA07;
    }

    public class AddressNA07 {
        @AuraEnabled public String Line1;
        @AuraEnabled public String Line2;
        @AuraEnabled public String Suburb;
        @AuraEnabled public String City;
    }

    //W-0004850
    public class JudgementsNJ07_Z {
        @AuraEnabled public List<JudgementsNJ07> JudgementsNJ07;
    }

    //W-0004850
    public class JudgementsNJ07 {
        @AuraEnabled public String JudgmentDate;//W-0004850
        @AuraEnabled public String Amount;//W-0004850
        @AuraEnabled public String JudgmentTypeDesc;//W-0004850
        @AuraEnabled public String NatureOfDebtDesc;//W-0004850
        @AuraEnabled public String CourtTypeDesc;//W-0004850
        @AuraEnabled public String CaseNo;//W-0004850
        @AuraEnabled public String Plaintiff;//W-0004850
    }

    //W-0004850
    public class DefaultsD701Part1_Z {
        @AuraEnabled public List<DefaultD701Part1> DefaultD701Part1;
    }

    //W-0004850
    public class DefaultD701Part1 {
        @AuraEnabled public String InformationDate;//W-0004850
        @AuraEnabled public String DefaultAmount;//W-0004850
        @AuraEnabled public String DefaultType;//W-0004850
        @AuraEnabled public String SupplierName;//W-0004850
        @AuraEnabled public String AccountNo;//W-0004850
        @AuraEnabled public String Remarks1;//W-0004850
        @AuraEnabled public String Remarks2;//W-0004850
    }

    //W-0004850
    public class NoticesNN08_Z {
        @AuraEnabled public List<NoticesNN08> NoticesNN08;
    }

    //W-0004850
    public class NoticesNN08 {
        @AuraEnabled public String NoticeDate;//W-0004850
        @AuraEnabled public String NoticeType;//W-0004850
        //@AuraEnabled public String DeptCounselling;//W-0004850
        @AuraEnabled public String CaptureDate;//W-0004850
        @AuraEnabled public String CourtTypeCode;//W-0004850
        @AuraEnabled public String CourtTypeDesc;//W-0004850
    }

    public class ScoreCardBX03 {
    }

    public class ScoreCardBX01 {
    }

    public class StandardBatchCharsSB27 {
    }

    public class TraceAlertTL {
    }

    public class AggregateAG02 {
    }

    public class AggregateAG01 {
        @AuraEnabled public String ConsumerNo;
        @AuraEnabled public Aggregates Aggregates;
    }

    public class Aggregates {
        @AuraEnabled public List<Aggregate> Aggregate;
    }

    public class StrikeDateOutput {
    }

    public class AggregateNX33 {
        //Adding the Mentioned field only as per DataType Given and Mapping From WSDL
        @AuraEnabled Public string TotalJudgments;
        @AuraEnabled Public string TotalNoticesEver;
        @AuraEnabled Public string EnquiriesEver;
        @AuraEnabled Public string TotalAdverseEver;
        @AuraEnabled Public string HighestJudgementValue;//W-0004850
    }

    public class EmployerInformation {
        @AuraEnabled public EmploymentClientDetails EmploymentClientDetails;
    }

    public class LapseOutputV3 {
    }

    public class StandardBatchCharsSB13 {
    }

    @AuraEnabled public Envelope Envelope;

    public class StandardBatchCharsSB19 {
    }

    public class StandardBatchCharsSB18 {
    }

    public class HawkNH05 {
    }

    public class TRLTN01 {
    }

    public class IncomeEstimatorT101 {
    }

    public class EmploymentClientDetails {
    }

    public class CCASummaryMX01 {
    }

    public class Envelope {
        @AuraEnabled public Body Body;
    }

    public class EchoData0001 {
        @AuraEnabled public String SubscriberCode;
        @AuraEnabled public String ClientReference;
        @AuraEnabled public String BatchNumber;
    }

    public class LinkagesLK {
    }

    public class EmpiricaEM04 {
        @AuraEnabled public String ConsumerNo;
        @AuraEnabled public String EmpiricaScore;
        @AuraEnabled public String ExpansionScore;
        @AuraEnabled public String ExpansionScoreDescription;
    }

    public class EmpiricaEM05 {
    }

    public class EmpiricaEM07 {
    }

    public class FSMS201 {
    }

    public class BCCBC01 {
    }

    public class ClaimantHeaderCH {
    }

    public class Body {
        @AuraEnabled public ProcessRequestTrans41Response ProcessRequestTrans41Response;
    }

    public class StandardBatchCharsSB04 {
    }

    public class NLRConfirmationMR01 {
    }

    public class StandardBatchCharsSB07 {
    }

    public class FraudScoreFS01 {
    }

    public class ProcessRequestTrans41Response {
        @AuraEnabled public ProcessRequestTrans41Result ProcessRequestTrans41Result;
    }

    public class DisputeIndicatorDI01 {
    }

    public class ClaimantHeaderHC {
    }

    public class IdvNI02 {
    }

    public class IdvNI03 {
    }

    public class DebtCounsellingDC01 {
        @AuraEnabled public String DebtCounsellingDescription;
    }

    public class StandardBatchCharsSB40 {
    }

    public class AlertDetailC4 {
    }

    public class IdvNI01 {
        @AuraEnabled public String IDVerifiedCode;
        @AuraEnabled public String IDVerifiedDesc;
    }

    public class Aggregate {
        @AuraEnabled public String Name;
        @AuraEnabled public String Value;
    }

    public class TicketSuccessConfirmationFR {
    }

    //W-0004850
    public class AKANamesNK04_Z {
        @AuraEnabled public List<AKANamesNK04> AKANamesNK04;//W-0004850
    }

    //W-0004850
    public class AKANamesNK04 {
        @AuraEnabled public String AKAName;//W-0004850
    }

    //W-0004850
    public class EmploymentNM04_Z {
        @AuraEnabled public List<EmploymentNM04> EmploymentNM04;//W-0004850
    }
    //W-0004850
    public class EmploymentNM04 {
        @AuraEnabled public String EmployerName;//W-0004850
    }
}