/*
-----------------------------------------------------
mov type / tipo mov / transtype / transsubtipe
-----------------------------------------------------
1 / Pedido			/ B/A, B/B (frio, seco, congelado)
					  N/B, B/B (quimico)
2 / Transferencia	/ B / B  ¿?
3 / Recepciones     / N/A , N/B, B/A, B/B (frio, congelado, seco/ transferencias) 
					/ B/B, N/B  (quimico)
4 / Desperdicio		/ N / B
5 / Recuento		/ N / G
6 / Compra Local	/ N / A
7 / Consumo			/ N / K ó (TST=B Y FF5=1)

*/

/*
-- pedidos
-- frio, seco, congelado:  b/a, b/b
-- quimico: n/b, b/b

--recepciones (transtype / transsubtype) 
-- frio,congelado,seco/material empaque,transferencia
n/a,n/b,b/a,b/b
-- quimico/unif./rep
B/B,N/B

-- tipos de asientos segun transsubtype tomados de pp_UpdateMovement
transsubtype  freefield5  intId_MovementType  descripcion          intId_MovementStatus
------------  ----------  ------------------  ------------------   ------------------
	  A		     				  2            Transferencia.              4
	  B			<> 1			  2			   Transferencia.              4
	  H							  2			   Transferencia.              4 
	  J                           2            Transferencia.              4
	  G                           5            Recuento.                   4
	  T                           6            Compras locales.            5
	  B         == 1              7            Consumo.                    4
*/


sp_helptext pp_UpdateMovementDocumentByReferenceId

------------------------------------------------------------------------------------------------------------------------
-- PEDIDOS
------------------------------------------------------------------------------------------------------------------------
-- *** PAGE LOAD ***
-- W.M. ListWarehouseByGroup
-- W.M. ListProductsComplete
-- W.M. ListProductClasses
-- W.M. ListPendingOrden
pp_ListPendingPreMovementHeaderByWarehouseId
-- W.M. ListDetailPendingOrden

-- W.M. SendOrden 
sp_helptext pp_UpdatePreMovementStatus <class> <status deleted> <fecha solicitud>
sp_helptext pp_InsertPreMovements >> tabla destino : T_PreMovements
sp_helptext pp_InsertMovements >> queda en t_movements en estatus guardado (estatus 1).
sp_helptext pp_InsertPendingInventoryMovements >>  inserta en t_inventorymovementinprogress
sp_helptext pp_UpdatePreMovementStatus <class> <status requested> <fecha solicitud>
sp_helptext pp_SendMovementNotificationByReferenceId 

------------------------------------------------------------------------------------------------------------------------
-- CONSUMOS
------------------------------------------------------------------------------------------------------------------------
-- *** PAGE LOAD ***
-- W.M. ConsumptionHeader
sp_helptext pp_ListConsumptionByWarehouseIdAndRequestedDate '165', '2020-08-21', '2020-08-21'
-- update sp pedding

-- *** PROCESS ***
-- W.M. Process
--a) valida si el consumo del dia ya fue procesado.
sp_helptext PA_SP_GetINVENTORYSALESORDERPROCESSED 
--b) valida si existen articulos que no han sido creados en globe.
sp_helptext pp_ListConsumptionProductsNonCreatedByWarehouseIdAndRequestedDate
--update sp con collate DATABASE_DEFAULT --- valera gregorio
--c) valida los articulos sin receta en globe.
sp_helptext pp_ListConsumptionProductsWithoutRecipeStructureByWarehouseIdAndRequestedDate
--d) si pasa las validaciones anteriores ejecuta este s.p. contra la bd de globe.  PA_SP_InsINVENTORYSALESORDER 
--  toma los datos 
sp_helptext PA_SP_InsINVENTORYSALESORDER 
--update sp. con la base de datos nueva de 007 a 001
-- con ese s.p ya inserta unos movimientos en gbkmut pero con el faktuurnr en null y queda en estatus enviado el movimiento en arturoslink.
-- posteriormente se actualizan con el job. 
--- pp_InsertConsumptionsIntoGlobe  -> este llama a PA_SP_InsINVENTORYPRODUCTIONORDER 

------------------------------------------------------------------------------------------------------------------------
--BANCARIO
------------------------------------------------------------------------------------------------------------------------
-- *** PAGE LOAD *** ---
-- W.M. /BanKingModules/Deposit.aspx/GridDepositHeader
-- usa conexion a [globe]
sp_helptext PA_SP_ListBankingDepositsHeaderByWarehouseIdAndRequestedDate '139', '2020-09-01', '2020-09-06'
--update sp. con conexion al globe nuevo de 007 viejo a 001 nuevo. collate DATABASE_DEFAULT
-- W.M. /BanKingModules/Deposit.aspx/GetDepositDetail
-- usa conexion a [globe]
--ojo pendiente con esto--
sp_helptext PA_SP_ListBankingDepositsDetailByWarehouseIdAndRequestedDate
-- W.M. /BanKingModules/Deposit.aspx/GetDeliveryCompanies
sp_helptext pp_ListBankingDeliveryCompanies
--update diting the number 26 jose valera--------------------------
-- W.M. /BanKingModules/Deposit.aspx/GetDeliveryBankingDepositTypes
sp_helptext pp_ListBankingDepositTypesForDelivery
-- W.M. /BanKingModules/Deposit.aspx/GetDepositTypes
sp_helptext pp_ListBankingDepositTypesWM
-- W.M. /BanKingModules/Deposit.aspx/GetRRPPDepartments
sp_helptext pp_ListBankingRRPPDepartment
-- W.M. /BanKingModules/Deposit.aspx/GetRRPPValidIssuersByOptionalActiveField
sp_helptext pp_GetRRPPValidIssuersByOptionalActiveField
--sp update 
-- W.M. /BanKingModules/Deposit.aspx/GetManualSalesFromDepositIsEnabled
--> devuelve el valor del web.config -> appSetting::ValidateManualSalesInBankingModule
-->--> si es true-> W.M. /BanKingModules/Deposit.aspx/GetDaysWithManualSales
sp_helptext pp_GetDaysWithManualSalesByWarehouseAndDateRange

-- *** AL SELECCIONAR LA FECHA DEL DEPOSITO: ONDATESELECTED1 *** 
-- W.M. /BanKingModules/Deposit.aspx/DepositExists -- valida que el deposito no exista!. 
-- usa conexion a globe!.
sp_helptext PA_SP_GetbankingDepositByWarehouseIdAndDate
--sp update collate DATABASE_DEFAULT
-- W.M. /BanKingModules/Deposit.aspx/GetExchageRate
-- usa conexion a globe!.
sp_helptext PA_SP_GET_EXCHANGERATEBYDATE
-- W.M. /BanKingModules/Deposit.aspx/GridSales
sp_helptext pp_ListBankingPaymentsByWarehouseIdAndRequestedDate
-- W.M. /BanKingModules/Deposit.aspx/ManualSales
sp_helptext pp_GetManualSalesByWarehouseIdAndSalesDate
-- W.M. /BanKingModules/Deposit.aspx/GetManualSales
sp_helptext pp_ListManualSalesDetailByCostcenterIdAndRequestedDate

-- *** CARGAR GNDSALES ***
-- W.M. /BanKingModules/Deposit.aspx/GridSales
sp_helptext pp_ListBankingPaymentsByWarehouseIdAndRequestedDate '139', '2020-09-18', '2020-09-18'
--update sp_pedding where strwarehouse

-- *** GUARDAR ***
-- W.M. /BanKingModules/Deposit.aspx/SaveDeposit
-- a) valida si existe el deposito
PA_SP_GetbankingDepositByWarehouseIdAndDate
-- b) eliminar carga anterior... 
pp_DeleteBankingDepositsByWarehouseIdAndRequestedDate
-- c) inserción del deposito
pp_InsertBankingDeposits

-- *** PROCESS ***
-- W.M. /BanKingModules/Deposit.aspx/ProcessDeposit

-- a) este valida que este cargado previamente el consumo (gnditem) del dia.
-- usa conexion a [globe]
sp_helptext PA_SP_GetINVENTORYSALESORDER
-- b) inserta el bancario 
sp_helptext PA_SP_InsertBankingDepositsInGlobe

-- *** CARGAR VENTAS MANUALES ***
-- W.M. /BanKingModules/Deposit.aspx/ListClient
sp_helptext pp_ListManualSalesClients

-- *** EDITAR VENTAS MANUALES ***
-- W.M. /BanKingModules/Deposit.aspx/GetManualSales
pp_ListManualSalesDetailByCostcenterIdAndRequestedDate

-- *** PROCESAR VENTAS MANUALES ***
-- W.M. /BanKingModules/Deposit.aspx/InsertSalesManuals
pp_InsertManualSales 


-- *** REPORTE 00 ***
-- REPORTE PRINCIPAL
sp_helptext pp_ListSalesByWarehouseIdAndRequestedDate '103', '2020-08-18', ''
-- SUBREPORTE
sp_helptext pp_ListBankingDepositsByWarehouseIdAndRequestedDate '139', '2020-09-22'
-- DIFERENCIA EN DEPOSITO
sp_helptext pp_GetBankingDepositDiferenceByWarehouseIdAndRequestedDate '139', '2020-09-22'

------------------------------------------------------------------------------------------------------------------------
-- RECUENTOS
------------------------------------------------------------------------------------------------------------------------
-- *** PAGE LOAD *** ---
-- W.M. ListProductTransfers 
sp_helptext PA_SP_ListProductByWarehouseId
-- W.M. CountHeader 
-- W.M. CoundHeaderLocal
-- es el mismo s.p. para los 2 webmethods...
sp_helptext pp_ListMovementHeaderByWarehouseFromIdAndTypeIdAndRequestedDate
-- *** ACT DAILY ***
-- W.M. ListProductLotByDate
sp_helptext PA_SP_ListProductDetailsByWarehouseIdAndDate

-- *** PROCESS ***
-- W.M. ProcessCount 
sp_helptext pp_InsertMovements
sp_helptext pp_getInventoryMovementsForDatasetByReferenceId --createdocument()
sp_helptext pp_UpdateMovementDocumentByReferenceId
sp_helptext pp_InsertPendingInventoryMovements

-- RECEPCIONES
-- *** PAGE LOAD ***
-- W.M. ReceptionsHeader
sp_helptext pp_ListMovementHeaderByWarehouseToIdAndTypeIdAndStatus '213',3,4
-- W.M. ReceptionsDetail
sp_helptext pp_ListPendingMovementDetailByWarehouseToId '145'
-- W.M. MyReceptionsHeader
sp_helptext pp_ListMovementHeaderByWarehouseToIdAndTypeIdAndRequestedDateAndStatus '128',3,'2018-10-01','2018-10-10',5
-- W.M. ListDetailMyReceptions
sp_helptext pp_ListMovementDetailByWarehouseToIdAndTypeIdAndRequestedDate
-- *** FIN: PAGE LOAD ***

-- *** btnAceptar *** -- 
-- SI WarehouseGroupFrom == REST
-- W.M. ProcessRecpcionREST
-- SINO
-- W.M. ProcessRecpcion
-- validacion status: solo continua si el primer registro del dataset esta en status <> 5 
   pp_GetStatusInventoryMovements 10818371
-- inserción sobrantes/faltantes en caso que aplique!
    pp_UpdateMovementReceivedQuantityByReferenceIdAndProductId 
-- actualiza el estatus a 5 (recibido)
   pp_UpdateMovementStatusByReferenceId
-- si es un pedido y tiene sobrante.
	sp_helptext pp_UpdatePreMovementStatus  --(ClassProduct, MovementStatus.Deleted, DateTime.Now)
	sp_helptext pp_InsertMovements --(**ProducMovement**,MovementType.Transference, MovementStatus.Sent, DailyNumberEnum.InventoryMove)
	sp_helptext pp_InsertPendingInventoryMovements
	sp_helptext pp_SendMovementDiferencesNotificationByReferenceId
	sp_helptext pp_UpdatePreMovementStatus --(ClassProduct, InventoryMovement.MovementStatus.Requested, DateTime.Now)
-- si es un pedido y tiene faltantes 
    pp_UpdatePreMovementStatus --(ClassProduct, MovementStatus.Deleted, DateTime.Now)
    sp_helptext pp_InsertMovements --(**ProducMovementTransference**,MovementType.Transference, MovementStatus.Sent, DailyNumberEnum.InventoryMove)
	sp_helptext pp_InsertPendingInventoryMovements	
	sp_helptext pp_SendMovementDiferencesNotificationByReferenceId
	sp_helptext pp_UpdatePreMovementStatus --(ClassProduct, InventoryMovement.MovementStatus.Requested, DateTime.Now)
-- fin validacion si es pedido...
	pp_InsertMovementPollByReferenceId --> datos del formulario encuesta
	-- en caso de error actualiza el movimiento y le coloca estatus (4: enviado)
    pp_UpdateMovementStatusByReferenceId <Reference>, <Status>, <userId> -- (MovementStatus.Sent)
-- *** fin: btnAceptar *** 
	
-- TRANSFERENCIAS 
-- *** PROCESS ***
sp_helptext pp_UpdatePreMovementStatus -- group == planta 
sp_helptext pp_InsertPreMovements
sp_helptext pp_InsertMovements
-- -> cs.  CreateDocument(), UpdateDocument()
sp_helptext pp_UpdateMovementDocumentByReferenceId --inserta el documento pdf serializado.

sp_helptext pp_InsertPendingInventoryMovements
sp_helptext pp_SendMovementNotificationByReferenceId 

-- DESPERDICIOS 
-- *** PAGE LOAD ***
-- WM: BanKingModules/InventoryWeb.aspx/ListStockProducts
sp_helptext PA_SP_ListStockAndSalesProducts
-- WM: BanKingModules/InventoryWeb.aspx/ListProductLotByDate
sp_helptext PA_SP_ListProductDetailsByWarehouseIdAndDate
-- WM: BanKingModules/InventoryWeb.aspx/ListRecipeProducts (GLOBE)
sp_helptext PA_SP_ListProductsRecipe
-- WM: BanKingModules/InventoryWeb.aspx/WastestHeader -> { 'BeginDate1': DateBegin, 'EndDate1': DateEnd }
sp_helptext pp_ListMovementHeaderByWarehouseFromIdAndTypeIdAndRequestedDate
-- WM: BanKingModules/InventoryWeb.aspx/WastestDetail -> { 'BeginDate1': DateBegin, 'EndDate1': DateEnd }
sp_helptext pp_ListMovementDetailByWarehouseFromIdAndTypeIdAndRequestedDateAndStatus
-- WM: BanKingModules/InventoryWeb.aspx/WastestGruopDetail
sp_helptext pp_ListMovementDetailGroupByWarehouseFromIdAndTypeIdAndRequestedDateAndStatus
-- *** PROCESS *** 
-- WM: BanKingModules/InventoryWeb.aspx/ProcessWastes
--a) valida si ya esta creado un desperdicio.
sp_helptext pp_GetInventoryWastes strwarehouse, intIdMovementType(4), strDescription, datRequestedDate
--b) InventoryMovement.cs::InsertMovements 
--b.1) 
sp_helptext PA_SP_GetBasicData --(globe)
--b.2)
sp_helptext pp_InsertMovements
--c)
sp_helptext pp_InsertPendingInventoryMovements
 -- en caso de error en paso b ó c llama pp_UpdateMovementStatusByReferenceId para colocar la ref. en estatus 2
--c.1)
sp_helptext pp_UpdateMovementStatusByReferenceId intId_Reference, intIdMovementStatus(2), intIdUser

-- *** JOBS *** 
-- =======================================
-- JOB: InsertBankingDepositsIntoGlobe
-- step: 1
sp_helptext pp_InsertConsumptionsIntoGlobe
-- step: 2
sp_helptext pp_InsertBankingDepositsIntoGlobe


--JOB: UpdateInventoryMovements 
--FRECUENCIA: c/10min entre 7am-7pm
-- step: 1 
sp_helptext pp_UpdateMovement

-- JOB: InsertInventoryMovementsIntoGlobe (desperdicios, )
-- step: 1 
sp_helptext pp_InsertInventoryMovementsIntoGlobe
	--> PA_SP_InsINVENTORYMOVEMENT
	/*
	    >>  si el resultado es satisfactorio (el s.p. retorna 0) se elimina la referencia de intId_MovementStatus
	    >>  se cambia el estatus en t_movements 5 para los tipos de doc distinto de 1 (pedidos) 
		>>>  si es pedido se cambia a estatus 3
	*/
-- step: 2 
sp_helptext pp_InsertTotalHeladoIntoGlobe


--JOB: Sicroniza cambios globe-gbkmut a inventorycontrol-t_gbkmut 
-- frecuencia:  c/10min entre 7am-6pm
-- step: 1 / Execute sp_Sincroniza_IdsCambiosGlobe001-InventoryControl
[sp_Sincroniza_IdsCambiosGlobe001-InventoryControl]
-- step: 2 / cambios de cestatitickets
[PA_sp_Sincroniza_CambiosCIOT-InventoryCtrl]

--JOB: [GLOBE] inserta desde globe a inventoryctl t_gbkmut
-- frecuencia: c/15min entre 6am-10pm
-- step: 1 / 
[PA_sp_SincronizaIDNuevosGLOBE001_VE-SPSQLInventoryControl]


------------------
-- COMPRAS LOCALES 
------------------------------------------------------------------------------------------------------------------------
-- btn_send
-- W.M. InventoryWebMethods.aspx/ProcessPurchase

------------------------------------------------------------------------------------------------------------------------
-- VENTAS PRINTER 
------------------------------------------------------------------------------------------------------------------------
-- *** PAGE LOAD ***
sp_helptext pp_ListPrinterSalesHeaderByCostcenterIdAndRequestedDate '153','2019-05-01','2019-05-14'

-- *** CARGAR ARCHIVO ***
pp_InsertZReports

-- *** ON DATE SELECTED ***
-- W.M. ExistFileGNDSALE
-- W.M. ManualSales  (SI PASA LA VALIDACION DE EXISTGNDSALE) / el s.p. carga los datos desde t_bankingfiles (gndsales) las ventas de employee == 999
pp_GetManualSalesByWarehouseIdAndSalesDate '161', '2020-08-11'
-- W.M. GetManualSales  //Verifica si ya fueron llenados los datos fiscales de las facturas manuales.
pp_ListManualSalesDetailByCostcenterIdAndRequestedDate


-- VENTAS PRINTER (digito truncados)
-- *** ON CHANGE DATE *** ---
-- W.M. GetSalesWithMissingDigit
sp_helptext pp_GetSalesWithMissingDigits '145', '2020-10-10'

------------------------------------------------------------------------------------------------------------------------
-- ArturosVPDesktopApp
------------------------------------------------------------------------------------------------------------------------
-- *** REPORTE LIBRO DE VENTAS ***
-- VERSION MONTOS MEMORIA FISCAL
sp_helptext SP_ListFiscalSalesBookFromPrinterSales
-- VERSION MONTOS CONTABILIDAD (ORIGINAL)
sp_helptext SP_ListFiscalJournalSalesSumary

-- S.P'S LIBRO VENTAS (NOAPP)
pp_GetSalesBookDifferencesByWarehouseAndDate '103', '2020-08-03','2020-08-09', 0


------------------------------------------------------------------------------------------------------------------------
-- PriceUpdatesModule
------------------------------------------------------------------------------------------------------------------------
-- *** PAGE LOAD ***
-- w.m. PriceUpdateRest
sp_helptext pp_PriceUpdateByWarehouseId

------------------------------------------------------------------------------------------------------------------------
-- BENEFICIO ALIMENTACION
------------------------------------------------------------------------------------------------------------------------
-- pagina foodticketsbenefit.aspx
-- *** PAGE LOAD ***
-- W.M. ListHeaderGrid (datetheader)
pp_ListFoodTicketsBenefitHeaderByRequestedDate 
sp_helptext pp_ListFoodTicketsBenefitHeaderByRequestedDate @datBeginDate='2020-11-01 00:00:00',@datEndDate='2020-11-30 00:00:00',@intPaymentType=1
--> TABLAS: T_FoodBenefitDocuments, T_PartTimeFoodTicketsBenefits, T_PartTimePayrollTypes
-- W.M. LisTypePayrrol
sp_helptext pp_ListPayrolltypes

-- *** SAVE #imgButton.Click() ***
-- W.M. GenerateFileCestaticket 
sp_helptext pp_InsertFoodTicketsBenefit
-- retorna: PaymentID (guid)
-- llama a CreateDocument() >> FoodBenefitReceipt.rpt <-> pp_GenerateFoodTicketsBenefitReport
sp_helptext pp_GenerateFoodTicketsBenefitReport
-- tambien llama al metodo CreateReportResumen()
sp_helptext pp_GenerateFoodTicketsBenefitSumaryReport

-- Opcion : configurar
--W.M. LisFoodTickectTypeValue
sp_helptext pp_ListFoodBenefitTypeValues
--W.M. SendTypeValue
sp_helptext pp_InsertFoodBenefitTypeValues

-- tablas: T_FoodBenefitDocuments, 
-- *** NOTIFICAR ***
-- W.M. SendNotification
sp_helptext pp_SendKindergardenNotification

------------------------------------------------------------------------------------------------------------------------
-- BENEFICIO ALIMENTACION (DIFERENCIAS)
------------------------------------------------------------------------------------------------------------------------
-- *** PAGE LOAD ***
-- W.M. ListHeaderGrid (datetheader)
sp_helptext pp_ListFoodTicketsBenefitHeaderByRequestedDate 
-- W.M. ListPayrolEmployeesPendingPayment
pp_ListEmplyees

-- W.M. LisTypePayrrol
pp_ListPayrolltypes

-- W.M. PendingPaymnetFoodTickets
-- *** PROCESAR ***
-- W.M. GenerateFileCestaticketPendig
pp_DeleteFoodTicketsBenefitPendingPayment
pp_InsertFoodTicketsBenefitDifference
--createdocument()
pp_GenerateFoodTicketsBenefitReport
--createreportresumen()
pp_GenerateFoodTicketsBenefitSumaryReport
pp_generatefoodticketsbenefit


-- W.M. SendNotification
-- W.M. ListDetailGridEditPendingPayment
-- W.M. Delete 




-- ================================================================================================================================
-- WITHHOLDING  VE-TEAMF\APPS
-- diccionario de campos withholding -> globe
-- bkstr: transactioninvoice
-- docdate: fecha distribucion
-- datum: fecha creacion factura
-- freefield1: rif compañia
-- freefield4: strIdInvoice (fondo cambio)
-- freefield3: nrocontrol (fondo cambio)
-- val_bdr: fltBaseAmount_Invoice (si reknr <> '11522')
-- val_bdr: fltTaxAmount_Invoice (si reknr == '11522')
-- ================================================================================================================================
-- *** Reporte libro de compras ***
sp_helptext GetInvoiceBookPurchase

-- =================================================================================================================================
-- RestaurantUtilities
-- =================================================================================================================================
-- ** Reporte Precios:
sp_helptext pp_listprice


-- =================================================================================================================================
-- Reporting Services
-- =================================================================================================================================
-- ** HelpDesk / Consumos y Bancarios
pa_diferencias_restaurant

-- =================================================================================================================================
-- OFF TOPIC
-- =================================================================================================================================

-- proceso t_salesfile hacia gbkmut
-- a) salesfile.cs->insertSalesFile
      -- 1) borra de t_salesfileshistorical llamando al sp.   pp_DeleteSalesFilesByWarehouseIdAndSalesDate idWarehouse, fecha, userd
			sp_helptext pp_DeleteSalesFilesByWarehouseIdAndSalesDate
			-- 2) inserta via bulkcopy desde gnditem.dbf hacia "t_salesfiles"
			-- 3) llama a sp. pp_UpdateSalesFilesByWarehouseIdAndSalesDate idWarehouse, fecha, userd
			sp_helptext pp_UpdateSalesFilesByWarehouseIdAndSalesDate
			--> el s.p. calcula la columna intiddepartmen_salesfiles y asigna datcreateddate_salesfiles e intid_user
			-- 4) genera el documento productmix llamando el s.p. pp_GenerateSalesFilesDocumentByWarehouseIdAndSalesdate idWarehouse, fecha
			sp_helptext pp_GenerateSalesFilesDocumentByWarehouseIdAndSalesdate

/* -- NOTAS t_salesfiles -- *
==============================
orddat = fecha venta
magcode = warehouse

nro. orden -> orkrg.ordernr

sp_helptext PA_SP_ListProductRecipeByProductIdAndQuantity

/*
==============================
 -- NOTAS GBKMUT -- 
==============================
-- type: 0 ==> pedidos quimicos
-- type: 150 ==> pedidos cestas, frio, seco, congelado, transferencias (TIPO: N|B)
-- type: 151 ==> pedidos cestas, frio, seco, congelado, transferencias (TIPO: N|A)

-- campos distintos: intstatunit (0: desperdicio, null: pedidos), 
--statisticalfactor: (1 desperdicio, null:pedidos), type: (null: desperdicio, 150 pedidos)
--intrastatenabled: (0 desperdicio, null: pedidos)
-- *** CAMPOS ABREVIADOS DE USO COMUN *** ---
--distinct faktuurnr ft, oms25, datum, transtype tt, transsubtype tst, warehouse wh, kstplcode whpl, kstdrcode whdr, Type tipo, freefield1 ff1, freefield2 ff2, freefield3 ff3, freefield4 ff4, freefield5 ff5

*/





SELECT  @intDataLength= ISNULL(COUNT(*),0)  
FROM gbkmut with (NoLock) 
WHERE dagbknr='500' 
AND kstdrcode=@strId_WareHouse 
AND datum=@datSalesDate 
AND transtype<>'V' 
AND docnumber='Venta 199 20210217')