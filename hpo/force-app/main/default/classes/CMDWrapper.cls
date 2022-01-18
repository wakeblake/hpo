public class CMDWrapper {
    @AuraEnabled
    public String fullName {get; set;}

    @AuraEnabled
    public String label {get; set;}

    @AuraEnabled
    public Boolean isActive {get; set;}

    @AuraEnabled
    public Integer numberRecords {get; set;}

    @AuraEnabled
    public Decimal dollarValue {get; set;}

    @AuraEnabled
    public Decimal donationAmount {get; set;}
}
