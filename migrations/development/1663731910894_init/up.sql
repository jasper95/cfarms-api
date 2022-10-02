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


-- public.farm definition

-- Drop table

-- DROP TABLE public.farm;

CREATE TABLE public.farm (
	"ownerName" varchar NOT NULL DEFAULT '',
	"ownershipDocument" varchar NOT NULL DEFAULT '',
	"ownershipType" varchar NOT NULL DEFAULT '',
	"location" jsonb NULL,
	"sizeInHaTotal" numeric NOT NULL,
	"isAgrarianReformBeneficiary" boolean NOT NULL,
	"withinAncestralDomain" boolean NOT NULL,
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"barangay" varchar NOT NULL DEFAULT '',
	"municipality" varchar NOT NULL DEFAULT 'Candijay',
	"farmType" varchar NOT NULL DEFAULT '',
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT farm_pk PRIMARY KEY (id)
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
	"commodity" varchar NOT NULL DEFAULT '',
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"farmId" uuid NULL,
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT crop_commodity_pk PRIMARY KEY (id),
	CONSTRAINT commodity_fk FOREIGN KEY ("farmId") REFERENCES public.farm(id) ON DELETE NO ACTION ON UPDATE NO ACTION
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


-- public."programAvailment" definition

-- Drop table

-- DROP TABLE public."programAvailment";

CREATE TABLE public."householdToProgram" (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"programId" uuid NOT NULL,
	"householdId" uuid NULL,
	"dateAvailed" date NULL,
	"remarks" varchar NOT NULL DEFAULT '',
	CONSTRAINT programavailment_fk_1 FOREIGN KEY ("householdId") REFERENCES public.household(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT programavailment_fk_2 FOREIGN KEY ("programId") REFERENCES public."program"(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE public."associationToProgram" (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"programId" uuid NOT NULL,
	"associationId" uuid NULL,
	"dateAvailed" date NULL,
	"remarks" varchar NOT NULL DEFAULT '',
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
	CONSTRAINT annualinfo_fk FOREIGN KEY ("householdId") REFERENCES public.household(id)
);


-- public."commodityProduceInventory" definition

-- Drop table

-- DROP TABLE public."commodityProduceInventory";

CREATE TABLE public."commodityProduceInventory" (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"commodityId" uuid NOT NULL,
	"produce" float8 NULL,
	"organicPractitioner" boolean NOT NULL,
	"householdId" uuid NOT NULL,
	"year" int4 NOT NULL,
	"areaUsed" float8 NOT NULL,
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT commodityproduceinventory_pk PRIMARY KEY (id),
	CONSTRAINT commodityproduceinventory_fk FOREIGN KEY ("commodityId") REFERENCES public.commodity(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT commodityproduceinventory_fk2 FOREIGN KEY ("householdId") REFERENCES public.household(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
