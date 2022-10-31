CREATE OR REPLACE VIEW "public"."produce" AS 
 SELECT DISTINCT "commodityProduce".id,
    "commodityProduce"."commodityId",
    "commodityProduce".produce,
    "commodityProduce"."organicPractitioner",
    "commodityProduce"."householdId",
    "commodityProduce".year,
    "commodityProduce"."areaUsed",
    "commodityProduce"."farmId",
    commodity.name AS "commodityName",
    farm.name AS "farmName",
    "commodityProduce"."createdAt",
    commodity."commodityType",
    concat(household."firstName", ' ', household."lastName") AS "householdName"
   FROM ((("commodityProduce"
     JOIN commodity ON (("commodityProduce"."commodityId" = commodity.id)))
     LEFT JOIN farm ON (("commodityProduce"."farmId" = farm.id)))
     LEFT JOIN household ON ((household.id = "commodityProduce"."householdId")));
