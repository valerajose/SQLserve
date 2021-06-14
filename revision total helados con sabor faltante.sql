EXEC pp_InsertTotalHelado '10947003' 

select * from T_Movements where intId_Reference = '10947003'

delete T_Movements  where intId_Movement = 54007677


select * from T_Movements where  intId_Reference = '10946713'

-- paso 1) borrar el renglon total_helado de t_movements 
delete T_Movements where  intId_Movement = 53998930
-- paso 2) borrar los renglones de total helado de amutas y gbkmut PROCEDER CON CAUTELA... SOLO LOS renglones de traspaso de sabores...
-- ojo aca el regel no siempre sera el mismo... hay que fijarse bien cual es la parte del asiento que tienen el movimiento del codigo del helado hacia total-helado.
delete gbkmut where faktuurnr = '10946713' and regel >= 7
delete amutas where faktuurnr = '10946713' and regel >= 7
-- paso 3) insertar en t_movement el renglon del sabor faltante del helado...
select * from T_Movements where  intId_Reference = '10946713'
-- paso 4) notificar al gerente que le de recepción al sabor faltante
-- paso 5) cuando el gerente avise revisar si se creo el asiento total helado y si la cantidad del mismo corresponde a la suma de todos los sabores.


update T_Movements set intId_MovementStatus = 2 where intId_Reference = 10946713   

USE [InventoryControl]
GO

INSERT INTO [dbo].[T_Movements]
           ([intId_Reference]
           ,[strId_Products]
           ,[strIdWareHouseFrom_WareHouse]
           ,[strIdLocationFrom_Locations]
           ,[strIdWareHouseTo_WareHouse]
           ,[strIdLocationTo_Locations]
           ,[intId_MovementType]
           ,[intId_MovementStatus]
           ,[intId_User]
           ,[fltRequestedQuantity_Movement]
           ,[fltDeliveredQuantity_Movement]
           ,[fltReceivedQuantity_Movement]
           ,[datCreatedDate_Movement]
           ,[datRequestedDate_Movement]
           ,[datDeliveredDate_Movement]
           ,[datReceivedDate_Movement]
           ,[strHeaderDescription_Movement]
           ,[strDescription_Movement]
           ,[strAccountFrom_Products]
           ,[strAccountTo_Products]
           ,[strId_Batchs]
           ,[intIdModifier_User]
           ,[datModifiedDate_Movement]
           ,[intFiscalYear_FiscalData]
           ,[strFiscalPeriod_FiscalData]
           ,[strEntryNumber_References]
           ,[strAmutasVolgnr5_References]
           ,[strAmutakVolgnr5_References]
           ,[intOrderNumber_References]
           ,[intDbkVerwnr_References]
           ,[intVerwerknrl_References]
           ,[intDiaryNumber_References]
           ,[fltOriginalStockQuantity_Products]
           ,[imgFile_Movement]
           ,[strId_Suppliers]
           ,[strInvoice_Movement]
           ,[strInvoiceControl_Movement]
           ,[fltInvoiceBaseAmount_Movement]
           ,[datProductionDate_Movement]
           ,[datExpirationDate_Movement]
           ,[intId_PurchaseType]
           ,[strId_TaxTypes]
           ,[fltFisicalQuantity_Movement]
           ,[strIdFather_Products]
           ,[fltRequestedQuantityFather_Movement]
           ,[intIDFile])
     select
           intId_Reference
           ,'16521'
           ,[strIdWareHouseFrom_WareHouse]
           ,[strIdLocationFrom_Locations]
           ,[strIdWareHouseTo_WareHouse]
           ,[strIdLocationTo_Locations]
           ,[intId_MovementType]
           ,4
           ,[intId_User]
           ,19.600
           ,19.600
           ,19.600
           ,[datCreatedDate_Movement]
           ,[datRequestedDate_Movement]
           ,[datDeliveredDate_Movement]
           ,[datReceivedDate_Movement]
           ,[strHeaderDescription_Movement]
           ,[strDescription_Movement]
           ,[strAccountFrom_Products]
           ,[strAccountTo_Products]
           ,'F042101V'
           ,[intIdModifier_User]
           ,[datModifiedDate_Movement]
           ,[intFiscalYear_FiscalData]
           ,[strFiscalPeriod_FiscalData]
           ,[strEntryNumber_References]
           ,[strAmutasVolgnr5_References]
           ,[strAmutakVolgnr5_References]
           ,[intOrderNumber_References]
           ,[intDbkVerwnr_References]
           ,[intVerwerknrl_References]
           ,[intDiaryNumber_References]
           ,[fltOriginalStockQuantity_Products]
           ,[imgFile_Movement]
           ,[strId_Suppliers]
           ,[strInvoice_Movement]
           ,[strInvoiceControl_Movement]
           ,38187587.09
           ,[datProductionDate_Movement]
           ,[datExpirationDate_Movement]
           ,[intId_PurchaseType]
           ,[strId_TaxTypes]
           ,[fltFisicalQuantity_Movement]
           ,[strIdFather_Products]
           ,[fltRequestedQuantityFather_Movement]
           ,[intIDFile]
		   from T_Movements where intId_Movement = 53998913
GO

