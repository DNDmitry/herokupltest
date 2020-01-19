public with sharing class HousingInvoiceCalculation
{
    public static Decimal calculateDebtAmount(Housing_user__c cUser,
                                              Decimal dElectricityMeterReading,
                                              Decimal dWaterMeterReading,
                                              Decimal dGasMeterReading,
                                              Decimal dElectricityRate,
                                              Decimal dWaterRate,
                                              Decimal dGasRate)
    {
        Decimal dDebtAmount = dElectricityMeterReading * dElectricityRate +
                              dWaterMeterReading * dWaterRate +
                              dGasMeterReading * dGasRate;
        cUser.Debet_Account__c = cUser.Debet_Account__c - dDebtAmount;
        update cUser;
        return cUser.Debet_Account__c;
    }

    public static Decimal calculateElectricityAmount(Decimal dElectricityMeterReading,
                                                     Decimal dElectricityRate)
    {
        return dElectricityMeterReading * dElectricityRate;
    }
    public static Decimal calculateWaterAmount(Decimal dWaterMeterReading, Decimal dWaterRate)
    {
        return dWaterMeterReading * dWaterRate;
    }
    public static Decimal calculateGasAmount(Decimal dGasMeterReading, Decimal dGasRate)
    {
        return dGasMeterReading * dGasRate;
    }
    public static Decimal changeUserDebtAfterPayment(Decimal dUserAcc, Decimal dPayment)
    {
        if(dPayment <= 0)
        {
            throw new HousingPaymentException();
        }
        return dUserAcc + dPayment;
    }
    public static void redactDebtAmount(Housing_rates__c cRates,
                                        Housing_invoice__c cInvoice,
                                        Decimal dElectricityMeterReading,
                                        Decimal dWaterMeterReading,
                                        Decimal dGasMeterReading)
    {
        Housing_user__c cUser = [select Id, Debet_Account__c from Housing_user__c where Id = :cInvoice.Housing_user__c limit 1];
        cUser.Debet_Account__c = cUser.Debet_Account__c + cInvoice.Bill_amount__c;
        update cUser;
        cInvoice.Bill_amount__c = calculateElectricityAmount(dElectricityMeterReading, cRates.Electricity_rate__c) +
                                  calculateWaterAmount(dWaterMeterReading, cRates.Water_rate__c) +
                                  calculateGasAmount(dGasMeterReading, cRates.Gas_rate__c);
        cInvoice.Electricity_bill__c = dElectricityMeterReading;
        cInvoice.Water_bill__c = dWaterMeterReading;
        cInvoice.Gas_bill__c = dGasMeterReading;
        cInvoice.Electricity_meter_reading__c = dElectricityMeterReading;
        cInvoice.Water_meter_reading__c = dWaterMeterReading;
        cInvoice.Gas_meter_reading__c = dGasMeterReading;
        update cInvoice;
        cUser.Debet_Account__c = cUser.Debet_Account__c - cInvoice.Bill_amount__c;
        update cUser;
    }

}