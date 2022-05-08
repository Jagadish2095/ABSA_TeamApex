/**
 * @description       : AccountEnquiry_Resp_IB_V1
 * @author            : Mradul Maheshwari
 * @last modified on  : 27-10-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-013340
 **/
public with sharing class AccountEnquiry_Resp_IB_V1 extends Base_IB {
  @AuraEnabled
  public String status;
  @AuraEnabled
  public Integer statusCode;
  @AuraEnabled
  public String message;

  @AuraEnabled
  public MLB857O MLB857O;
  @AuraEnabled
  public NBSAPDPO NBSAPDPO;

  /**
   * @description NBSAPLO
   */
  public class NBSAPLO {
    @AuraEnabled
    public Integer NBNAPLO_RETURN_CODE;
  }

  /**
   * @description NBSAPDPO
   */
  public class NBSAPDPO {
    @AuraEnabled
    public NBSAPLO NBSAPLO;
  }

  /**
   * @description MLB857O_SEC_ACCT_DETAIL
   */
  public class MLB857O_SEC_ACCT_DETAIL {
    @AuraEnabled
    public Long MLB857O_SE_ACCT_NBR;
    @AuraEnabled
    public Double MLB857O_SE_OUTST_BAL;
  }

  /**
   * @description MLB857O_PRIM_ACCT_DETAIL
   */
  public class MLB857O_PRIM_ACCT_DETAIL {
    @AuraEnabled
    public String MLB857O_PR_BOND_REG_DATE;
    @AuraEnabled
    public Integer MLB857O_PR_TERM_OF_LOAN;
    @AuraEnabled
    public Long MLB857O_PR_ACCT_NBR;
    @AuraEnabled
    public Double MLB857O_PR_FLEXI_AMT_AVAIL;
    @AuraEnabled
    public Double MLB857O_PR_EFF_ACCT_RATE;
    @AuraEnabled
    public Double MLB857O_PR_OUTST_BAL;
    @AuraEnabled
    public MLB857O_PR_INST_DETAIL MLB857O_PR_INST_DETAIL;
    @AuraEnabled
    public Double MLB857O_PR_BOND_AMT;
    @AuraEnabled
    public Integer MLB857O_PR_REMAINING_TERM;
  }

  /**
   * @description MLB857O
   */
  public class MLB857O {
    @AuraEnabled
    public MLB857O_OUTPUT_AREA MLB857O_OUTPUT_AREA;
  }

  /**
   * @description MLB857O_PROPERTY_DETAIL
   */
  public class MLB857O_PROPERTY_DETAIL {
    @AuraEnabled
    public String MLB857O_UNIT_NBR;
    @AuraEnabled
    public String MLB857O_PROPERTY_DESCR;
    @AuraEnabled
    public String MLB857O_PORTION;
    @AuraEnabled
    public String MLB857O_HOC_ANIV_DATE;
    @AuraEnabled
    public String MLB857O_ERF_NBR;
    @AuraEnabled
    public String MLB857O_CITY;
    @AuraEnabled
    public String MLB857O_COMPLEX_NAME;
    @AuraEnabled
    public String MLB857O_TOWNSHIP;
  }

  /**
   * @description MLB857O_PR_INST_DETAIL
   */
  public class MLB857O_PR_INST_DETAIL {
    @AuraEnabled
    public Double MLB857O_PR_PROV_HMP;
    @AuraEnabled
    public Double MLB857O_PR_PROV_HOC;
    @AuraEnabled
    public Double MLB857O_PR_BASIC_INST;
    @AuraEnabled
    public Double MLB857O_PR_PROV_ADMIN_FEE;
    @AuraEnabled
    public Double MLB857O_PR_TOTAL_INST;
    @AuraEnabled
    public Double MLB857O_PR_PROV_ENDOWMENT;
    @AuraEnabled
    public Integer MLB857O_PR_DUE_DAY;
  }

  /**
   * @description MLB857O_OUTPUT_AREA
   */
  public class MLB857O_OUTPUT_AREA {
    @AuraEnabled
    public MLB857O_PRIM_ACCT_DETAIL MLB857O_PRIM_ACCT_DETAIL;
    @AuraEnabled
    public List<MLB857O_PROPERTY_DETAIL> MLB857O_PROPERTY_DETAIL;
    @AuraEnabled
    public String MLB857O_ERROR_MSG;
    @AuraEnabled
    public List<MLB857O_SEC_ACCT_DETAIL> MLB857O_SEC_ACCT_DETAIL;
    @AuraEnabled
    public Integer MLB857O_ERROR_CODE;
  }
}