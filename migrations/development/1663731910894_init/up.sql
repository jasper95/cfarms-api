-- public.association definition

-- Drop table

-- DROP TABLE public.association;

CREATE TABLE public.association (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"name" varchar NOT NULL,
	"shortName" varchar NULL,
	"description" varchar NULL,
	"active" boolean NOT NULL DEFAULT true,
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT association_pk PRIMARY KEY (id)
);


-- public.farm definition

-- Drop table

-- DROP TABLE public.farm;

CREATE TABLE public.farm (
	"ownerName" varchar NOT NULL,
	"ownershipDocument" varchar NOT NULL,
	"ownershipType" varchar NOT NULL,
	"location" jsonb NULL,
	"sizeInHaTotal" numeric NOT NULL,
	"isAgrarianReformBeneficiary" boolean NOT NULL,
	"withinAncestralDomain" boolean NOT NULL,
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"barangay" varchar NULL,
	"municipality" varchar NULL DEFAULT 'Candijay',
	"farmType" varchar NULL,
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT farm_pk PRIMARY KEY (id)
);


-- public."program" definition

-- Drop table

-- DROP TABLE public."program";

CREATE TABLE public."program" (
	"name" varchar NOT NULL,
	"description" varchar NOT NULL,
	"sponsoringAgency" varchar NULL,
	"dateStart" date NOT NULL,
	"dateEnd" date NULL,
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"type" varchar NULL,
	"createdAt" TIMESTAMP NOT NULL DEFAULT now(),
	"updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
	CONSTRAINT program_pk PRIMARY KEY (id)
);


-- public.commodity definition

-- Drop table

-- DROP TABLE public.commodity;

CREATE TABLE public.commodity (
	"commodityType" varchar NOT NULL,
	"commodity" varchar NOT NULL,
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
	"referenceNo" varchar NOT NULL,
	"lastName" varchar NOT NULL,
	"firstName" varchar NOT NULL,
	"middleName" varchar NULL,
	"extensionName" varchar NULL,
	"houseLotBldgNo" varchar NULL,
	"streetSitioSubdv" varchar NULL,
	"barangay" varchar NULL,
	"municipality" varchar NULL DEFAULT 'Candijay'::character varying,
	"province" varchar NULL DEFAULT 'Bohol'::character varying,
	"region" varchar NULL DEFAULT '7'::character varying,
	"contactNumber" bpchar(11) NOT NULL,
	"sex" int4 NOT NULL DEFAULT 1, -- 1-male, 2-female
	"civilStatus" int4 NOT NULL DEFAULT 2, -- 1-single, 2-married, 3-Widowed, 4-Separated
	"nameOfSpouse" varchar NULL,
	"mothersMaidenName" varchar NULL,
	"religion" varchar NULL,
	"dateOfBirth" date NOT NULL,
	"placeOfBirth" varchar NOT NULL,
	"nameOfHouseholdHead" varchar NOT NULL,
	"isHouseholdHead" boolean NOT NULL,
	"relationshipToHouseholdHead" varchar NULL,
	"maleCount" int4 NOT NULL DEFAULT 0,
	"femaleCount" int4 NOT NULL DEFAULT 0,
	"highestFormalEducation" varchar NOT NULL,
	"personWithDisability" boolean NOT NULL DEFAULT false,
	"is4psBeneficiary" boolean NOT NULL DEFAULT false,
	"ipMembership" varchar NULL,
	"governmentIdType" varchar NULL,
	"governmentIdNo" varchar NULL,
	"emergencyContactNumber" bpchar(11) NULL,
	"emergencyContactName" varchar NULL,
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
	"remarks" varchar NULL,
	CONSTRAINT programavailment_fk_1 FOREIGN KEY ("householdId") REFERENCES public.household(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT programavailment_fk_2 FOREIGN KEY ("programId") REFERENCES public."program"(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE public."associationToProgram" (
	"id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"programId" uuid NOT NULL,
	"associationId" uuid NULL,
	"dateAvailed" date NULL,
	"remarks" varchar NULL,
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
	"highestFormalEducation" varchar NOT NULL,
	"personWithDisability" boolean NOT NULL DEFAULT false,
	"is4PsBeneficiary" boolean NOT NULL DEFAULT false,
	"associationMembership" varchar NULL,
	"mainLivelihood" text[] NULL,
	"farmworkerActivityType" text[] NULL,
	"fisherActivityType" text[] NULL,
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
