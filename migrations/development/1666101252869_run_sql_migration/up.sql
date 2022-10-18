CREATE OR REPLACE VIEW "public"."programBeneficiaries" AS 
 SELECT
  "householdToProgram".id,
  "householdToProgram"."programId",
  "householdToProgram"."householdId",
  "householdToProgram"."createdAt",
  household."firstName",
  household.barangay,
  household."referenceNo",
  household."lastName",
  "annualInfo"."grossAnnualIncomeFarming",
  "annualInfo"."grossAnnualIncomeNonfarming",
  farm."farmSize",
  produce."commodities"
FROM
  (
    (
      (
        "householdToProgram"
        LEFT JOIN household ON (
          (
            household.id = "householdToProgram"."householdId"
          )
        )
      )
      LEFT JOIN "annualInfo" ON (
        (
          (
            "annualInfo"."householdId" = "householdToProgram"."householdId"
          )
          AND (
            ("annualInfo".year) :: double precision = date_part(
              'year' :: text,
              (
                SELECT
                  CURRENT_TIMESTAMP AS "current_timestamp"
              )
            )-1
          )
        )
      )
    )
    LEFT JOIN (
      SELECT
        farm_1."householdId",
        sum(farm_1."sizeInHaTotal") AS "farmSize"
      FROM
        farm farm_1
      GROUP BY
        farm_1."householdId"
    ) farm ON (
      (
        farm."householdId" = "householdToProgram"."householdId"
      )
    )
    LEFT JOIN (
    	SELECT COALESCE(jsonb_agg("commodity"."id"),'[]'::jsonb) AS "commodities"
    		,"commodityProduce"."householdId" AS "householdId"
    		from commodity
    		LEFT JOIN "commodityProduce" ON "commodityProduce"."commodityId" = commodity.id
    			AND ("commodityProduce".year) :: double precision = date_part(
              'year' :: text,
              (
                SELECT CURRENT_TIMESTAMP AS "current_timestamp"
              )
            )-1
            group by "commodityProduce"."householdId"
    ) AS produce ON (produce."householdId"="householdToProgram"."householdId")
  );
