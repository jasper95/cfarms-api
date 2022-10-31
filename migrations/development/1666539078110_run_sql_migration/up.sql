CREATE OR REPLACE VIEW "public"."householdPrograms" AS 
 SELECT household.id,
    household.barangay,
    household."firstName",
    household."lastName",
    household."referenceNo",
    household."createdAt",
    COALESCE(jsonb_agg("householdToProgram"."programId") FILTER (WHERE "householdToProgram"."programId" IS NOT NULL), '[]'::jsonb) AS "programIds",
    "annualInfo"."grossAnnualIncomeFarming",
    "annualInfo"."grossAnnualIncomeNonfarming",
    "farm_1"."farmSize",
    COALESCE(jsonb_agg("commodity"."name"),'[]'::jsonb) AS "commodities",
    COALESCE(jsonb_agg("commodity"."id"),'[]'::jsonb) AS "commodityIds"
   FROM household
   	 LEFT JOIN 
   	 (select sum(farm."sizeInHaTotal")  as "farmSize", farm."householdId" from farm group by farm."householdId") as farm_1
   	 ON farm_1."householdId" = household.id
     LEFT JOIN "annualInfo" ON "annualInfo"."householdId" = household.id
     	AND
	 ("annualInfo".year) :: double precision = date_part(
              'year' :: text,
       (
         SELECT CURRENT_TIMESTAMP AS "current_timestamp"
       )
     )-1      
     LEFT JOIN "householdToProgram" ON household.id = "householdToProgram"."householdId"
     LEFT JOIN "commodityProduce" ON "commodityProduce"."householdId" = household.id
     	and ("commodityProduce".year) :: double precision = date_part(
              'year' :: text,
       (
         SELECT CURRENT_TIMESTAMP AS "current_timestamp"
       )
     )-1
     LEFT JOIN commodity ON commodity.id = "commodityProduce"."commodityId"     
  GROUP BY household.id, "annualInfo".id, "farm_1"."farmSize";
