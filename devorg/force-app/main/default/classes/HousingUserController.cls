global with sharing class HousingUserController
{
    private final String szErrMaskStart = 'The error is occured:';
    private final String szErrAffectedFields = 'Affected fields';
    private final String szLoginPage = '/apex/Housing_login';
    private final String szPageManager = '/apex/Housing_manager';
    private final String szErrorPositiveBalance = 'Your account must have a positive balance';
    private final String szErrorInvalidPayment = 'Impossible payment. Check the amount.';
    private final String szErrorTypePayment = 'Payment value must be decimal number.';
    private final String szErrorTypeMeterReadings = 'Meter reading value must be decimal number.';
    private final String szErrorInvalidStreet = 'Street field must contain a street name and building number.';
    private final String szErrorNoRates = 'Rates not found for this region.';
    private final String szErrorCannotPutReadings = 'Unpossible calculate invoice without rates.';
    private final String szErrorNoSupporter = 'Current manager is not found';
    private List<DisplayRates> lRegions;
    private List<DisplayPaymentHistory> lPaymentHistory;
    private String szUserId;
    public Housing_user__c cUser {get; set;}
    public String szElectricity {get; set;}
    public String szWater {get; set;}
    public String szGas {get; set;}
    public String szPayment {get; set;}
    public Boolean bMetersReadingVisible {get; set;}
    public Boolean bChangeAddressVisible {get; set;}
    public Boolean bNewMessageVisible {get; set;}
    public Decimal dUserBalance {get; set;}
    public String szRegion {get;set;}
    public String szCity {get;set;}
    public String szStreet {get; set;}
    public String szAppartment {get; set;}
    public String szMessageBody {get; set;}

    public HousingUserController()
    {
        szUserId = ApexPages.currentPage().getParameters().get('UserId');
    }
    public PageReference init()
    {
        if(String.isBlank(szUserId))
        {
            return redirectToHousingLoginPage();
        }
        cUser = getHousingUser(szUserId);
        bMetersReadingVisible = false;
        bChangeAddressVisible = false;
        dUserBalance = cUser.Debet_Account__c;
        szRegion = cUser.Region__c;
        szCity = cUser.City__c;
        szStreet = cUser.Street__c;
        szAppartment = cUser.Appartment__c;
        return null;
    }
    public PageReference redirectToHousingLoginPage()
    {
        PageReference prReference = new PageReference(szLoginPage);
        prReference.setRedirect(true);
        return prReference;
    }

    public void sendEmailToManager()
    {
        bNewMessageVisible = true;
    }

    public void sendMessage()
    {
        bNewMessageVisible = false;
        Housing_user__c[] lManager = [select Email__c, Region__c from Housing_user__c where Region__c = :cUser.Region__c and isManager__c = true limit 1];
        if(lManager.size() > 0)
        {
            HousingMessager.sendMessage(szMessageBody, 'From '+cUser.First_Name__c+' '+cUser.Last_name__c+' '+cUser.Email__c, cUser.Email__c, lManager[0].Email__c);
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, szErrorNoSupporter));
        }
    }

    public List<DisplayRates> getRates()
    {
        system.debug(cUser);
        Housing_rates__c cRates = new Housing_rates__c();
        lRegions = new List<DisplayRates>();
        try
        {
            cRates = [select Id, Electricity_rate__c, Gas_rate__c, Water_rate__c
                      from Housing_rates__c
                      where Region__c = :cUser.Region__c limit 1];
        }
        catch(QueryException e)
        {
            system.debug(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, szErrorNoRates));
            return lRegions;
        }
        DisplayRates rate = new DisplayRates();
        rate.setElectricityRate(cRates.Electricity_rate__c);
        rate.setWaterRate(cRates.Water_rate__c);
        rate.setGasRate(cRates.Gas_rate__c);
        lRegions.add(rate);
        return lRegions;
    }

    public Housing_user__c getHousingUser(String szUserId)
    {
        Housing_user__c[] lUsers = [select Id, Email__c, Debet_Account__c, Region__c, City__c, Street__c, Appartment__c,
                                           First_Name__c, Last_name__c, isManager__c
                                    from Housing_user__c
                                    where Id = :szUserId
                                    limit 1];
        return lUsers[0];
    }

    public PageReference putMeterReadingValues()
    {
        Housing_invoice__c cNewInvoice = new Housing_invoice__c();
        try
        {
            cNewInvoice.Housing_user__c = cUser.Id;
            cNewInvoice.Electricity_meter_reading__c = Decimal.valueOf(szElectricity);
            cNewInvoice.Water_meter_reading__c = Decimal.valueOf(szWater);
            cNewInvoice.Gas_meter_reading__c = Decimal.valueOf(szGas);
        }
        catch(TypeException e)
        {
            system.debug(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, szErrorTypeMeterReadings));
            return null;
        }
        bMetersReadingVisible = false;
        if(lRegions.size() > 0)
        {
            dUserBalance = HousingInvoiceCalculation.calculateDebtAmount(cUser,
                    cNewInvoice.Electricity_meter_reading__c,
                    cNewInvoice.Water_meter_reading__c,
                    cNewInvoice.Gas_meter_reading__c,
                    lRegions[0].dDisplayElectricity,
                    lRegions[0].dDisplayWater,
                    lRegions[0].dDisplayGas);
            cNewInvoice.Electricity_bill__c = HousingInvoiceCalculation.calculateElectricityAmount(cNewInvoice.Electricity_meter_reading__c,
                    lRegions[0].dDisplayElectricity);
            cNewInvoice.Water_bill__c = HousingInvoiceCalculation.calculateWaterAmount(cNewInvoice.Water_meter_reading__c,
                    lRegions[0].dDisplayWater);
            cNewInvoice.Gas_bill__c = HousingInvoiceCalculation.calculateGasAmount(cNewInvoice.Gas_meter_reading__c,
                    lRegions[0].dDisplayGas);
            cNewInvoice.Bill_amount__c = cNewInvoice.Electricity_bill__c + cNewInvoice.Water_bill__c + cNewInvoice.Gas_bill__c;
            Database.SaveResult dbResult = Database.insert(cNewInvoice, false);
            if(!dbResult.isSuccess())
            {
                for(Database.Error dbError : dbResult.getErrors())
                {
                    System.debug(szErrMaskStart);
                    System.debug(dbError.getStatusCode() + ': ' + dbError.getMessage());
                    System.debug(szErrAffectedFields + dbError.getFields());
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,dbError.getMessage()));
                }
                return null;
            }
            String szBody = 'Hello, ' + cUser.First_Name__c + '! <br> ';
            szBody += 'Please note that your debt is:';
            szBody += '<br>';
            szBody += 'Electricity: ' + cNewInvoice.Electricity_bill__c + '<br>';
            szBody += 'Water: ' + cNewInvoice.Water_bill__c + '<br>';
            szBody += 'Gas: ' + cNewInvoice.Gas_bill__c + '<br>';
            szBody += '-------------------------------------<br>';
            szBody += 'To pay: ' + cNewInvoice.Bill_amount__c + '<br>';
            szBody += '<br>';
            szBody += 'Please pay it as soon as possible! <br>';
            szBody += 'With kind regards.';
            Housing_user__c cManager = [select Id, Email__c from Housing_user__c where Region__c = :cUser.Region__c AND isManager__c = true limit 1];
            HousingMessager.sendMessage(szBody, 'Invoice', cManager.Email__c, cUser.Email__c);
            return null; // stay on the same page
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,szErrorCannotPutReadings));
        return null;
    }

    public void initMeterReadingValues()
    {
        szElectricity = '0';
        szWater = '0';
        szGas = '0';
        bMetersReadingVisible = true;
        //return null;// stay on the same page
    }

    public PageReference makePayment()
    {
        Housing_payment__c cNewPayment = new Housing_payment__c();
        cNewPayment.Housing_user__c = cUser.Id;
        try
        {
            cNewPayment.Amount__c = Decimal.valueOf(szPayment);
            cUser.Debet_Account__c = HousingInvoiceCalculation.changeUserDebtAfterPayment(cUser.Debet_Account__c, cNewPayment.Amount__c);

            update cUser;
        }
        catch(DmlException e)
        {
            system.debug(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, szErrorInvalidPayment));
            return null;
        }
        catch(TypeException e)
        {
            system.debug(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, szErrorTypePayment));
            return null;
        }
        catch(HousingPaymentException e)
        {
            system.debug(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.szMessage));
            return null;
        }
        dUserBalance = cUser.Debet_Account__c;

        Database.SaveResult dbResult = Database.insert(cNewPayment, false);
        if(!dbResult.isSuccess())
        {
            for(Database.Error dbError : dbResult.getErrors())
            {
                System.debug(szErrMaskStart);
                System.debug(dbError.getStatusCode() + ': ' + dbError.getMessage());
                System.debug(szErrAffectedFields + dbError.getFields());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,dbError.getMessage()));
            }
            return null;
        }
        szPayment = '';
        return null;// stay on the same page
    }

    public List<DisplayPaymentHistory> getPaymentHistory()
    {
        lPaymentHistory = new List<DisplayPaymentHistory>();
        for(Housing_payment__c item : [select Housing_user__c, Amount__c, Time__c
                                       from Housing_payment__c
                                       where Housing_user__c = :cUser.Id
                                       order by Time__c desc])
        {
            lPaymentHistory.add(new DisplayPaymentHistory(item));
        }
        return lPaymentHistory;
    }

    public PageReference changeAddressStart()
    {
        if(cUser.Debet_Account__c >= 0)
        {
            bChangeAddressVisible = true;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, szErrorPositiveBalance));
        }
        return null;
    }

    public PageReference changeAddressFinish()
    {
        try
        {
            if(String.isBlank(szStreet))
            {
                throw new HousingEmptyFieldException();
            }
            cUser.Street__c = szStreet.trim();
            cUser.Appartment__c = szAppartment.trim();
            update cUser;
            szRegion = cUser.Region__c;
            szCity = cUser.City__c;
        }
        catch(DmlException e)
        {
            system.debug(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, szErrorInvalidStreet));
            return null;
        }
        catch(HousingEmptyFieldException e)
        {
            system.debug(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.szMessage));
            return null;
        }
        bChangeAddressVisible = false;
        return null;
    }

    public class DisplayRates
    {
        private Decimal dElecticity;
        private Decimal dWater;
        private Decimal dGas;
        public DisplayRates()
        {
            dElecticity = 0.0;
            dWater = 0.0;
            dGas = 0.0;
        }
        public void setElectricityRate(Decimal dElecticityRate)
        {
            dElecticity = dElecticityRate;
        }
        public void setWaterRate(Decimal dWaterRate)
        {
            dWater = dWaterRate;
        }
        public void setGasRate(Decimal dGasRate)
        {
            dGas = dGasRate;
        }
        // Properties for use in the Visualforce view
        public Decimal dDisplayElectricity
        {
            get { return dElecticity; }
        }
        public Decimal dDisplayWater
        {
            get { return dWater; }
        }
        public Decimal dDisplayGas
        {
            get { return dGas; }
        }
    }
    public class DisplayPaymentHistory
    {
        private Housing_payment__c cPayment;
        public DisplayPaymentHistory(Housing_payment__c cPayment)
        {
            this.cPayment = cPayment;
        }
        // Properties for use in the Visualforce view
        public Decimal dDisplayAmount
        {
            get { return cPayment.Amount__c; }
        }
        public Datetime dtDisplayDateTime
        {
            get { return cPayment.Time__c; }
        }
    }

    public PageReference redirectToManager()
    {
        PageReference prReference = new PageReference(szPageManager);
        prReference.getParameters().put('UserId', cUser.Id);
        prReference.setRedirect(true);
        return prReference;
    }

}