CREATE OR REPLACE VIEW "public"."inventoryOfLivestock" AS 
 SELECT sum("commodityProduce".produce) AS sum,
    "commodityProduce".year,
    commodity.name
   FROM ("commodityProduce"
     JOIN commodity ON (((commodity.id = "commodityProduce"."commodityId") AND ((commodity."commodityType")::text = 'Livestock'::text))))
  GROUP BY "commodityProduce".year, commodity.name;
