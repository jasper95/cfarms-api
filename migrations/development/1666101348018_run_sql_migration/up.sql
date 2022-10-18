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
    produce.commodities
   FROM household
     LEFT JOIN "annualInfo" ON "annualInfo"."householdId" = household.id AND "annualInfo".year::double precision = date_part('year'::text, ( SELECT CURRENT_TIMESTAMP AS "current_timestamp"))-1
     LEFT JOIN "householdToProgram" ON household.id = "householdToProgram"."householdId"
     LEFT JOIN farm ON farm."householdId" = household.id
     LEFT JOIN (
    	SELECT COALESCE(jsonb_agg("commodity"."id"),'[]'::jsonb) AS "commodities"
    		,"commodityProduce"."householdId" AS "hhId"
    		from commodity
    		LEFT JOIN "commodityProduce" ON "commodityProduce"."commodityId" = commodity.id
    			AND ("commodityProduce".year) :: double precision = date_part(
              'year' :: text,
              (
                SELECT CURRENT_TIMESTAMP AS "current_timestamp"
              )
            )-1
            group by "hhId"
    ) AS produce ON (produce."hhId"="householdToProgram"."householdId")
  GROUP BY household.id, "annualInfo".id, produce.commodities;
