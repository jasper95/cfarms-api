-- public.association definition

-- Drop table

-- DROP TABLE public.association;

CREATE TABLE public.association (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"name" varchar NOT NULL DEFAULT '',
	"shortName" varchar NOT NULL DEFAULT '',
	"description" varchar NOT NULL DEFAULT '',
	"active" boolean NOT NULL DEFAULT true,
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT association_pk PRIMARY KEY (id)
);

-- public."program" definition

-- Drop table

-- DROP TABLE public."program";

CREATE TABLE public."program" (
	"name" varchar NOT NULL DEFAULT '',
	"description" varchar NOT NULL DEFAULT '',
	"sponsoringAgency" varchar NOT NULL DEFAULT '',
	"dateStart" date NOT NULL,
	"dateEnd" date NULL,
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"type" varchar NOT NULL DEFAULT '',
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT program_pk PRIMARY KEY (id)
);


-- public.commodity definition

-- Drop table

-- DROP TABLE public.commodity;

CREATE TABLE public.commodity (
	"commodityType" varchar NOT NULL DEFAULT '',
	"name" varchar NOT NULL DEFAULT '',
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT crop_commodity_pk PRIMARY KEY (id)
);


-- public.household definition

-- Drop table

-- DROP TABLE public.household;

CREATE TABLE public.household (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"referenceNo" varchar NOT NULL DEFAULT '',
	"lastName" varchar NOT NULL DEFAULT '',
	"firstName" varchar NOT NULL DEFAULT '',
	"middleName" varchar NOT NULL DEFAULT '',
	"extensionName" varchar NOT NULL DEFAULT '',
	"houseLotBldgNo" varchar NOT NULL DEFAULT '',
	"streetSitioSubdv" varchar NOT NULL DEFAULT '',
	"barangay" varchar NOT NULL DEFAULT '',
	"municipality" varchar NOT NULL DEFAULT 'Candijay'::character varying,
	"province" varchar NOT NULL DEFAULT 'Bohol'::character varying,
	"region" varchar NOT NULL DEFAULT '7'::character varying,
	"contactNumber" varchar NOT NULL DEFAULT '',
	"sex" int4 NOT NULL DEFAULT 1, -- 1-male, 2-female
	"civilStatus" int4 NOT NULL DEFAULT 2, -- 1-single, 2-married, 3-Widowed, 4-Separated
	"nameOfSpouse" varchar NOT NULL DEFAULT '',
	"mothersMaidenName" varchar NOT NULL DEFAULT '',
	"religion" varchar NOT NULL DEFAULT '',
	"dateOfBirth" date NOT NULL,
	"placeOfBirth" varchar NOT NULL DEFAULT '',
	"nameOfHouseholdHead" varchar NOT NULL DEFAULT '',
	"isHouseholdHead" boolean NOT NULL,
	"relationshipToHouseholdHead" varchar NOT NULL DEFAULT '',
	"maleCount" int4 NOT NULL DEFAULT 0,
	"femaleCount" int4 NOT NULL DEFAULT 0,
	"personWithDisability" boolean NOT NULL DEFAULT false,
	"is4psBeneficiary" boolean NOT NULL DEFAULT false,
	"ipMembership" varchar NOT NULL DEFAULT '',
	"governmentIdType" varchar NOT NULL DEFAULT '',
	"governmentIdNo" varchar NOT NULL DEFAULT '',
	"emergencyContactNumber" varchar NOT NULL DEFAULT '',
	"emergencyContactName" varchar NOT NULL DEFAULT '',
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT household_pk PRIMARY KEY (id)
);


-- public.farm definition

-- Drop table

-- DROP TABLE public.farm;

CREATE TABLE public.farm (
	"ownerName" varchar NOT NULL DEFAULT '',
	"ownershipDocument" varchar NOT NULL DEFAULT '',
	"ownershipType" varchar NOT NULL DEFAULT '',
	"name" varchar NOT NULL DEFAULT '',
	"location" jsonb NULL,
	"sizeInHaTotal" numeric NOT NULL,
	"isAgrarianReformBeneficiary" boolean NOT NULL,
	"withinAncestralDomain" boolean NOT NULL,
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"householdId" uuid NOT NULL,
	"barangay" varchar NOT NULL DEFAULT '',
	"municipality" varchar NOT NULL DEFAULT 'Candijay',
	"farmType" varchar NOT NULL DEFAULT '',
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT farm_pk PRIMARY KEY (id),
	CONSTRAINT farm_fk_1 FOREIGN KEY ("householdId") REFERENCES public.household(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- public."programAvailment" definition

-- Drop table

-- DROP TABLE public."programAvailment";

CREATE TABLE public."householdToProgram" (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"programId" uuid NOT NULL,
	"householdId" uuid NOT NULL,
	"remarks" varchar NOT NULL DEFAULT '',
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT programavailment_fk_1 FOREIGN KEY ("householdId") REFERENCES public.household(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT programavailment_fk_2 FOREIGN KEY ("programId") REFERENCES public."program"(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE public."associationToProgram" (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"programId" uuid NOT NULL,
	"associationId" uuid NOT NULL,
	"remarks" varchar NOT NULL DEFAULT '',
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT programavailment_fk FOREIGN KEY ("associationId") REFERENCES public.association(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT programavailment_fk_2 FOREIGN KEY ("programId") REFERENCES public."program"(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- public."annualInfo" definition

-- Drop table

-- DROP TABLE public."annualInfo";

CREATE TABLE public."annualInfo" (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"year" int4 NOT NULL,
	"householdId" uuid NOT NULL,
	"highestFormalEducation" varchar NOT NULL DEFAULT '',
	"personWithDisability" boolean NOT NULL DEFAULT false,
	"is4PsBeneficiary" boolean NOT NULL DEFAULT false,
	"mainLivelihood" jsonb NOT NULL DEFAULT jsonb_build_array(),
	"farmworkerActivityType" jsonb NOT NULL DEFAULT jsonb_build_array(),
	"fisherActivityType" jsonb NOT NULL DEFAULT jsonb_build_array(),
	"grossAnnualIncomeFarming" numeric NOT NULL DEFAULT 0,
	"grossAnnualIncomeNonfarming" numeric NOT NULL DEFAULT 0,
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT annualinfo_pk PRIMARY KEY (id),
	CONSTRAINT annualinfo_fk FOREIGN KEY ("householdId") REFERENCES public.household(id),
	CONSTRAINT annualinfo_unique UNIQUE ("householdId", "year")
);


-- public."commodityProduceInventory" definition

-- Drop table

-- DROP TABLE public."commodityProduceInventory";

CREATE TABLE public."commodityProduce" (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"commodityId" uuid NOT NULL,
	"farmId" uuid NOT NULL,
	"produce" float8 NULL,
	"organicPractitioner" boolean NOT NULL,
	"householdId" uuid NOT NULL,
	"year" int4 NOT NULL,
	"areaUsed" float8 NOT NULL,
  "produceInUnit" float8 NULL,
  "unit" text NOT NULL DEFAULT 'MT',
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT commodityproduce_pk PRIMARY KEY (id),
	CONSTRAINT commodityproduce_fk FOREIGN KEY ("commodityId") REFERENCES public.commodity(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT commodityproduce_fk2 FOREIGN KEY ("householdId") REFERENCES public.household(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT commodityproduce_fk3 FOREIGN KEY ("farmId") REFERENCES public.farm(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT commodityproduce_unique UNIQUE ("farmId", "commodityId", "year")
);


CREATE TYPE "public"."userRoleEnum" AS ENUM ('administrator', 'manager', 'encoder');

-- -- Table Definition
CREATE TABLE "public"."user" (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"firstName" text NOT NULL DEFAULT '',
	"lastName" text NOT NULL DEFAULT '',
	"username" text NOT NULL,
	"active" bool NOT NULL DEFAULT true,
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	"role" "public"."userRoleEnum" NOT NULL,
	CONSTRAINT user_pk PRIMARY KEY (id)
);


CREATE
OR REPLACE VIEW "public"."associationBeneficiaries" AS
SELECT
  "associationToProgram".id,
  "associationToProgram"."programId",
  "associationToProgram"."associationId",
  "associationToProgram"."createdAt",
  association.name,
  association.active
FROM
  (
    "associationToProgram"
    LEFT JOIN association ON (
      (
        "associationToProgram"."associationId" = association.id
      )
    )
  );


CREATE OR REPLACE VIEW "public"."associationPrograms" AS
SELECT
  association.id,
  association.name,
  association.active,
  COALESCE(
    jsonb_agg("associationToProgram"."programId") FILTER (
      WHERE
        ("associationToProgram"."programId" IS NOT NULL)
    ),
    '[]' :: jsonb
  ) AS "programIds",
  association."createdAt"
FROM
  (
    association
    LEFT JOIN "associationToProgram" ON (
      (
        association.id = "associationToProgram"."associationId"
      )
    )
  )
GROUP BY
  association.id;


CREATE
OR REPLACE VIEW "public"."averageAnnualIncome" AS
SELECT
  avg(
    (
      COALESCE(
        "annualInfo"."grossAnnualIncomeFarming",
        (0) :: numeric
      ) + COALESCE(
        "annualInfo"."grossAnnualIncomeNonfarming",
        (0) :: numeric
      )
    )/1000
  ) AS averageinfo,
  avg("annualInfo"."grossAnnualIncomeFarming")/1000 AS "annualIncomeFarming",
  avg("annualInfo"."grossAnnualIncomeNonfarming")/1000 AS "annualIncomeNonfarming",
  "annualInfo".year
FROM
  "annualInfo"
GROUP BY
  "annualInfo".year;

CREATE
OR REPLACE VIEW "public"."inventoryOfLivestock" AS
SELECT
  sum("commodityProduce".produce) AS sum,
  "commodityProduce".year,
  commodity.name,
  commodity.id AS "commodityId"
FROM
  (
    "commodityProduce"
    JOIN commodity ON (
      (
        (commodity.id = "commodityProduce"."commodityId")
        AND (
          (commodity."commodityType") :: text = 'Livestock' :: text
        )
      )
    )
  )
GROUP BY
  "commodityProduce".year, commodity.name, commodity.id;

CREATE
OR REPLACE VIEW "public"."produce" AS
 SELECT DISTINCT "commodityProduce".id,
    "commodityProduce"."commodityId",
    "commodityProduce".produce,
    "commodityProduce"."organicPractitioner",
    "commodityProduce"."householdId",
    "commodityProduce".year,
    "commodityProduce"."areaUsed",
    "commodityProduce"."farmId",
    "commodityProduce".unit,
    "commodityProduce"."produceInUnit",
    commodity.name AS "commodityName",
    farm.name AS "farmName",
    "commodityProduce"."createdAt",
    commodity."commodityType",
    CONCAT(household."firstName",' ', household."lastName") as "householdName"
   FROM (("commodityProduce"
     JOIN commodity ON (("commodityProduce"."commodityId" = commodity.id)))
     LEFT JOIN farm ON (("commodityProduce"."farmId" = farm.id)))
     LEFT JOIN household ON household.id = "commodityProduce"."householdId";



CREATE
OR REPLACE VIEW "public"."programBeneficiaries" AS
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
  "annualInfo"."mainLivelihood",
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



CREATE OR REPLACE VIEW "public"."registeredHouseholdPerYear" AS
  SELECT
	count(
		household.id) AS count,
	"annualInfo".year
FROM (
	household
	JOIN "annualInfo" ON ((household.id = "annualInfo"."householdId")))
GROUP BY
	"annualInfo".year;

  

CREATE OR REPLACE VIEW "public"."householdPrograms" AS 
 SELECT household.id,
    household.barangay,
    household."firstName",
    household."lastName",
    household."referenceNo",
    household."createdAt",
    COALESCE(jsonb_agg("householdToProgram"."programId") FILTER (WHERE ("householdToProgram"."programId" IS NOT NULL)), '[]'::jsonb) AS "programIds",
    "annualInfo"."grossAnnualIncomeFarming",
    "annualInfo"."grossAnnualIncomeNonfarming",
    "annualInfo"."mainLivelihood",
    farm_1."farmSize",
    COALESCE(jsonb_agg(commodity.name), '[]'::jsonb) AS commodities,
    COALESCE(jsonb_agg(commodity.id), '[]'::jsonb) AS "commodityIds"
   FROM (((((household
     LEFT JOIN ( SELECT sum(farm."sizeInHaTotal") AS "farmSize",
            farm."householdId"
           FROM farm
          GROUP BY farm."householdId") farm_1 ON ((farm_1."householdId" = household.id)))
     LEFT JOIN "annualInfo" ON ((("annualInfo"."householdId" = household.id) AND (("annualInfo".year)::double precision = (date_part('year'::text, ( SELECT CURRENT_TIMESTAMP AS "current_timestamp")) - (1)::double precision)))))
     LEFT JOIN "householdToProgram" ON ((household.id = "householdToProgram"."householdId")))
     LEFT JOIN "commodityProduce" ON ((("commodityProduce"."householdId" = household.id) AND (("commodityProduce".year)::double precision = (date_part('year'::text, ( SELECT CURRENT_TIMESTAMP AS "current_timestamp")) - (1)::double precision)))))
     LEFT JOIN commodity ON ((commodity.id = "commodityProduce"."commodityId")))
  GROUP BY household.id, "annualInfo".id, farm_1."farmSize";



CREATE OR REPLACE VIEW "public"."cropProduce" AS 
SELECT sum("commodityProduce".produce) AS produce,
    "commodityProduce".year,
    commodity.name,
    sum("commodityProduce"."areaUsed") as "areaUsed",
    sum("commodityProduce".produce)/sum("commodityProduce"."areaUsed")::float as yield,
    commodity.id AS "commodityId"
   FROM ("commodityProduce"
     JOIN commodity ON (((commodity.id = "commodityProduce"."commodityId") AND ((commodity."commodityType")::text = 'Crop'::text))))
  GROUP BY "commodityProduce".year, commodity.name, commodity.id;

CREATE OR REPLACE VIEW "public"."fisheriesProduce" AS 
 SELECT sum("commodityProduce".produce) AS produce,
    "commodityProduce".year,
    commodity.name,
    commodity.id AS "commodityId"
   FROM ("commodityProduce"
     JOIN commodity ON (((commodity.id = "commodityProduce"."commodityId") AND ((commodity."commodityType")::text = 'Fisheries'::text))))
  GROUP BY "commodityProduce".year, commodity.name, commodity.id;