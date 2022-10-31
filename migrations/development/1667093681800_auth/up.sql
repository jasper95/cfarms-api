CREATE TABLE public.account (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type text NOT NULL,
    provider text NOT NULL,
    "providerAccountId" text NOT NULL,
    refresh_token text,
    access_token text,
    expires_at bigint,
    token_type text,
    scope text,
    id_token text,
    session_state text,
    oauth_token_secret text,
    oauth_token text,
    "userId" uuid NOT NULL,
    refresh_token_expires_in bigint
);

CREATE TABLE public.session(
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "sessionToken" text NOT NULL,
    "userId" uuid NOT NULL,
    expires timestamptz
);

CREATE TABLE public.user(
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  name text,
  "firstName" text NOT NULL DEFAULT '',
  "lastName" text NOT NULL DEFAULT '',
  "active" bool NOT NULL DEFAULT true,
  "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
  "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
  "role" "public"."userRoleEnum" NOT NULL DEFAULT 'encoder'::public."userRoleEnum",
  email text,
  "emailVerified" timestamptz,
  image text
);

CREATE TABLE public."verificationToken" (
    token text NOT NULL,
    identifier text NOT NULL,
    expires timestamptz
);

ALTER TABLE ONLY public.account
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.session
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.user
    ADD CONSTRAINT users_email_key UNIQUE (email);

ALTER TABLE ONLY public.user
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public."verificationToken"
    ADD CONSTRAINT verification_tokens_pkey PRIMARY KEY (token);

ALTER TABLE ONLY public.account
    ADD CONSTRAINT "accounts_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.user(id) ON UPDATE RESTRICT ON DELETE CASCADE;

ALTER TABLE ONLY public.session
    ADD CONSTRAINT "sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.user(id) ON UPDATE RESTRICT ON DELETE CASCADE;