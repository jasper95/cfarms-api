CREATE OR REPLACE VIEW "public"."householdPrograms" AS 
  SELECT household.id,
    household.barangay,
    household."firstName",
    household."lastName",
    household."referenceNo",
    household."createdAt",
    COALESCE(jsonb_agg("householdToProgram"."programId") FILTER (WHERE "householdToProgram"."programId" IS NOT NULL), '[]'::jsonb) AS "programIds",
    sum(farm."sizeInHaTotal") AS "farmSize",
    "annualInfo"."grossAnnualIncomeFarming",
    "annualInfo"."grossAnnualIncomeNonfarming",
    COALESCE(jsonb_agg("commodity"."name"),'[]'::jsonb) AS "commodities",
    COALESCE(jsonb_agg("commodity"."id"),'[]'::jsonb) AS "commodityIds"
   FROM household
     LEFT JOIN "annualInfo" ON "annualInfo"."householdId" = household.id      
     LEFT JOIN "householdToProgram" ON household.id = "householdToProgram"."householdId"
     LEFT JOIN farm ON farm."householdId" = household.id
     LEFT JOIN "commodityProduce" ON "commodityProduce"."farmId" = farm.id
     LEFT JOIN commodity ON commodity.id = "commodityProduce"."commodityId"
     WHERE
     ("commodityProduce".year) :: double precision = date_part(
              'year' :: text,
       (
         SELECT CURRENT_TIMESTAMP AS "current_timestamp"
       )
     )-1
	AND
	 ("annualInfo".year) :: double precision = date_part(
              'year' :: text,
       (
         SELECT CURRENT_TIMESTAMP AS "current_timestamp"
       )
     )-1
  GROUP BY household.id, "annualInfo".id;
