CREATE OR REPLACE VIEW "public"."registeredHouseholdPerYear" AS 
  SELECT COUNT("householdId"), "year"
	FROM "annualInfo" 
	GROUP BY "year";
