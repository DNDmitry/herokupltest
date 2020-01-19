global with sharing class HousingManagerController
{
    List<DisplayRates> lRegions;
    List<DisplayUsers> lUsers;
    public  Boolean bRatesChanging {get; set;}
    public  Boolean bFilterUsing {get; set;}
    public  Boolean bFilterUsed {get; set;}
    public Boolean bIsFirstPage {get; set;}
    public Boolean bIsLastPage {get; set;}
    public Boolean bMetersReadingVisible {get; set;}
    public String szElectricity {get; set;}
    public String szWater {get; set;}
    public String szGas {get; set;}
    public String szFilterEmail {get; set;}
    public String szFilterCity {get; set;}
    public String szFilterStreet {get; set;}
    public String szFilterAppartment {get; set;}
    public String szRedactElectricity {get; set;}
    public String szRedactWater {get; set;}
    public String szRedactGas {get; set;}
    public Housing_user__c cManager {get; set;}
    private Housing_rates__c cRates;
    private String szManagerId;
    public Integer nBookmark;
    private final Integer nDisplayedUsersCount = 50;
    private final String szPageUser = '/apex/Housing_user';
    private final String szLoginPage = '/apex/Housing_login';
    private final String szErrorTypeMeterReadings = 'Meter reading value must be decimal number.';
    private final String szErrorUsersNoFound = 'Users with these parameters not found.';
    private final String szErrorTypeRates = 'Rate value must be decimal number.';
    private Housing_invoice__c cRedactInvoice;


   global HousingManagerController()
    {
        szManagerId = ApexPages.currentPage().getParameters().get('UserId');

    }
    public PageReference init()
    {
        if(String.isBlank(szManagerId))
        {
            return redirectToHousingLoginPage();
        }
        cManager = getHousingManager(szManagerId);
        bRatesChanging = false;
        bFilterUsing = false;
        bFilterUsed = false;
        nBookmark = 0;
        bIsFirstPage = true;
        bIsLastPage = false;
        bMetersReadingVisible = false;
        return null;
    }

    public PageReference redirectToHousingLoginPage()
    {
        PageReference prReference = new PageReference(szLoginPage);
        prReference.setRedirect(true);
        return prReference;
    }

    public void goToPrevPage()
    {
        if(nBookmark >= nDisplayedUsersCount)
        {
            bIsLastPage = false;
            nBookmark = nBookmark - nDisplayedUsersCount;
        }
        else
        {
            bIsFirstPage = true;
        }
    }

    public void goToNextPage()
    {
        if(nBookmark < [SELECT COUNT() FROM Housing_user__c WHERE Region__c = :cManager.Region__c] - nDisplayedUsersCount)
        {
            bIsFirstPage = false;
            nBookmark = nBookmark + nDisplayedUsersCount;
        }
        else
        {
            bIsLastPage = true;
        }
    }

    public PageReference putNewRates()
    {
        bRatesChanging = false;
        try
        {
            cRates.Electricity_rate__c = Decimal.valueOf(szElectricity);
            cRates.Water_rate__c = Decimal.valueOf(szWater);
            cRates.Gas_rate__c = Decimal.valueOf(szGas);
            update cRates;
        }
        catch(TypeException e)
        {
            system.debug(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, szErrorTypeRates));
            return null;
        }
        return null;
    }

    public PageReference redactStart()
    {
        String szCurrentUserId = System.currentPageReference().getParameters().get('Id');
        try
        {
            cRedactInvoice = [select Id, Electricity_meter_reading__c, Water_meter_reading__c, Gas_meter_reading__c,
                                 Electricity_bill__c, Water_bill__c, Gas_bill__c, Housing_user__c, Bill_amount__c
                                 from Housing_invoice__c
                                 where Housing_user__c = :szCurrentUserId
                                 order by CreatedDate desc
                                 limit 1];
        }
        catch(QueryException e)
        {
            cRedactInvoice = new Housing_invoice__c(Housing_user__c = szCurrentUserId);
        }
        
        system.debug(cRedactInvoice);
        szRedactElectricity = String.valueOf(cRedactInvoice.Electricity_meter_reading__c);
        szRedactWater = String.valueOf(cRedactInvoice.Water_meter_reading__c);
        szRedactGas = String.valueOf(cRedactInvoice.Gas_meter_reading__c);
        bMetersReadingVisible = true;
        return null;
    }

    public PageReference redactFinish()
    {
        bMetersReadingVisible = false;
        try
        {
            HousingInvoiceCalculation.redactDebtAmount(cRates,
                    cRedactInvoice,
                    Decimal.valueOf(szRedactElectricity),
                    Decimal.valueOf(szRedactWater),
                    Decimal.valueOf(szRedactGas));
        }
        catch(TypeException e)
        {
            system.debug(e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, szErrorTypeMeterReadings));
        }
        return null;
    }

    public PageReference initRatesChanging()
    {
        bRatesChanging = true;
        if(lRegions.size() > 0)
        {
            szElectricity = String.valueOf(lRegions[0].dDisplayElectricity);
            szWater = String.valueOf(lRegions[0].dDisplayWater);
            szGas = String.valueOf(lRegions[0].dDisplayGas);
        }
        return null;// stay on the same page
    }

    public List<DisplayRates> getRates()
    {
        cRates = [select Id, Electricity_rate__c, Gas_rate__c, Water_rate__c
                                   from Housing_rates__c
                                   where Region__c = :cManager.Region__c
                                   limit 1];
        lRegions = new List<DisplayRates>();
        DisplayRates rate = new DisplayRates();
        rate.setElectricityRate(cRates.Electricity_rate__c);
        rate.setWaterRate(cRates.Water_rate__c);
        rate.setGasRate(cRates.Gas_rate__c);
        lRegions.add(rate);
        return lRegions;
    }

    public List<DisplayUsers> getUsers()
    {

        lUsers = new List<DisplayUsers>();        
        for(Housing_user__c cUser : [SELECT Id, First_Name__c, Last_name__c, Email__c, Region__c, City__c, Street__c,
                                            Appartment__c, Debet_Account__c
                                     FROM Housing_user__c
                                     WHERE Region__c = :cManager.Region__c
                                     LIMIT :nDisplayedUsersCount
                                     OFFSET :nBookmark])
        {            
            lUsers.add(new DisplayUsers(cUser));
        }
        return lUsers;
    }

    public List<DisplayUsers> getFilteredUsers()
    {
        lUsers = new List<DisplayUsers>();
        system.debug(cManager);
        String szSubQuery = 'WHERE Region__c = \'' + cManager.Region__c + '\' AND ';
        if(szFilterEmail != '')
        {
            szSubQuery = szSubQuery + 'Email__c = :szFilterEmail';
        }
        else
        {
            szSubQuery = szSubQuery + 'Email__c != \'\'';
        }
        if(szFilterCity != '')
        {
            szSubQuery = szSubQuery + ' AND City__c = :szFilterCity';
        }
        if(szFilterStreet != '')
        {
            szSubQuery = szSubQuery + ' AND Street__c = :szFilterStreet';
        }
        if(szFilterAppartment != '')
        {
            szSubQuery = szSubQuery + ' AND Appartment__c = :szFilterAppartment';
        }

        String szQuery = 'SELECT Id, First_Name__c, Last_name__c, Email__c, City__c, Street__c, Appartment__c, Debet_Account__c, Region__c FROM Housing_user__c ' + szSubQuery + ' LIMIT :nDisplayedUsersCount OFFSET :nBookmark';
        List<Housing_user__c> lFilteredUsers =  Database.query(szQuery);
        if(lFilteredUsers.size() > 0)
        {
            for(Housing_user__c cUser : lFilteredUsers)
            {
                lUsers.add(new DisplayUsers(cUser));
            }
            return lUsers;
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, szErrorUsersNoFound));
        return lUsers;
    }

    private Housing_user__c getHousingManager(String szManagerId)
    {
        Housing_user__c [] lManagers = [select Id, Email__c, Region__c, isManager__c
                from Housing_user__c 
                where Id = :szManagerId
                limit 1];
        return lManagers[0];
    }

    public PageReference filterUsers()
    {
        bFilterUsing = false;
        bFilterUsed = true;
        return null;
    }

    public PageReference initiateFilter()
    {
        bFilterUsing = true;
        return null;
    }

    public PageReference resetFilter()
    {
        bFilterUsed = false;
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

    public class DisplayUsers
    {
        private String szFirstName;
        private String szLastName;
        private String szCity;
        private String szEmail;
        private String szStreet;
        private String szAppartment;
        private String szId;
        private Decimal dDebetAcc;
        public DisplayUsers(Housing_user__c cUser)
        {
            szId = cUser.Id;
            szFirstName = cUser.First_Name__c;
            szLastName = cUser.Last_name__c;
            szCity = cUser.City__c;
            szStreet = cUser.Street__c;
            szAppartment = cUser.Appartment__c;
            dDebetAcc = cUser.Debet_Account__c;
            szEmail = cUser.Email__c;            
        }
        // Properties for use in the Visualforce view
        public String szDisplayId
        {
            get { return szId; }
        }
        public Decimal szDisplayDebetAcc
        {
            get { return dDebetAcc; }
        }
        public String szDisplayAppartment
        {
            get { return szAppartment; }
        }
        public String szDisplayStreet
        {
            get { return szStreet; }
        }
        public String szDisplayEmail
        {
            get { return szEmail; }
        }
        public String szDisplayCity
        {
            get { return szCity; }
        }        
        public String szDisplayFirstName
        {
            get { return szFirstName; }
        }
        public String szDisplayLastName
        {
            get { return szLastName; }
        }
    }

    public PageReference redirectToUser()
    {
        PageReference prReference = new PageReference(szPageUser);
        prReference.getParameters().put('UserId', cManager.Id);
        prReference.setRedirect(true);
        return prReference;
    }
}