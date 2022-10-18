CREATE OR REPLACE VIEW "public"."averageAnnualIncome" AS 
 SELECT avg((COALESCE("annualInfo"."grossAnnualIncomeFarming", (0)::numeric) + COALESCE("annualInfo"."grossAnnualIncomeNonfarming", (0)::numeric)))/1000 AS averageinfo,
    avg("annualInfo"."grossAnnualIncomeFarming")/1000 AS "annualIncomeFarming",
    avg("annualInfo"."grossAnnualIncomeNonfarming")/1000 AS "annualIncomeNonfarming",
    "annualInfo".year
   FROM "annualInfo"
  GROUP BY "annualInfo".year;
