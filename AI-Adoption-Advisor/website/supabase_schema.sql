-- ============================================================
-- AI CONSULTING FIRM — SUPABASE DATABASE SCHEMA
-- ============================================================
-- Run this in your Supabase SQL Editor to set up your tables.
-- Row Level Security (RLS) is enabled on all tables.
-- ============================================================


-- -----------------------------------------------
-- 1. CONTACTS (leads & prospects from contact form)
-- -----------------------------------------------
CREATE TABLE contacts (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now(),

  -- Identity
  full_name       TEXT NOT NULL,
  email           TEXT NOT NULL UNIQUE,
  company_name    TEXT,
  job_title       TEXT,

  -- Qualification fields (from your contact form)
  company_size    TEXT CHECK (company_size IN ('1-10', '11-50', '51-200', '201-500', '500+')),
  industry        TEXT,  -- e.g. 'Healthcare', 'Finance', 'Retail', 'Manufacturing', etc.
  ai_challenge    TEXT,  -- Free text: "What is your biggest challenge with AI?"
  referral_source TEXT,  -- "How did you hear about us?"

  -- CRM lifecycle
  status          TEXT DEFAULT 'new' CHECK (status IN ('new', 'contacted', 'qualified', 'proposal', 'client', 'lost')),
  notes           TEXT,  -- Internal notes field (never shown to prospect)
  assigned_to     TEXT   -- Your name or team member if you scale
);

-- Adding mandatory field for data retention agreement in the contacts table
ALTER TABLE contacts
ADD COLUMN data_retention_agreement BOOLEAN NOT NULL DEFAULT false; -- Indicates if the user agreed to data retention policy

-- Adding field for newsletter subscription consent in the contacts table
ALTER TABLE contacts
ADD COLUMN newsletter_consent BOOLEAN NOT NULL DEFAULT false; -- Indicates if the user agreed to receive occasional insights

-- Auto-update updated_at on row change
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER contacts_updated_at
  BEFORE UPDATE ON contacts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- RLS: only authenticated users (you) can read/write
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Owner access only" ON contacts
  FOR ALL USING (auth.role() = 'authenticated');


-- -----------------------------------------------
-- 2. ASSESSMENT_RESULTS (from your AI assessment tool)
-- -----------------------------------------------
CREATE TABLE assessment_results (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at      TIMESTAMPTZ DEFAULT now(),

  -- Link to contact (optional — not all assessors will submit contact info)
  contact_id      UUID REFERENCES contacts(id) ON DELETE SET NULL,
  email           TEXT,  -- captured even if no contact record yet

  -- Assessment inputs
  business_domain TEXT,  -- e.g. 'Healthcare', 'Retail'
  company_size    TEXT,
  ai_maturity     TEXT CHECK (ai_maturity IN ('none', 'exploring', 'piloting', 'scaling', 'advanced')),
  use_case_focus  TEXT,  -- e.g. 'automation', 'analytics', 'customer service'
  raw_answers     JSONB, -- Full form payload — future-proofs the schema

  -- Assessment outputs
  maturity_score  INT CHECK (maturity_score BETWEEN 0 AND 100),
  ai_recommendation TEXT,  -- The generated recommendation text
  recommended_services TEXT[], -- Array of your service offerings flagged as relevant

  -- Source tracking
  session_id      TEXT   -- Anonymous session if no login
);

-- Adding fields to store company information and detailed scoring in the assessment_results table
ALTER TABLE assessment_results
ADD COLUMN company_name TEXT, -- Name of the company completing the assessment
ADD COLUMN detailed_scores JSONB; -- JSON object to store detailed scoring breakdown

ALTER TABLE assessment_results ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Owner access only" ON assessment_results
  FOR ALL USING (auth.role() = 'authenticated');

-- Allow anonymous inserts (so prospects can submit without an account)
CREATE POLICY "Public insert" ON assessment_results
  FOR INSERT WITH CHECK (true);


-- -----------------------------------------------
-- 3. NEWSLETTER_SUBSCRIBERS
-- -----------------------------------------------
CREATE TABLE newsletter_subscribers (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at    TIMESTAMPTZ DEFAULT now(),
  email         TEXT NOT NULL UNIQUE,
  full_name     TEXT,
  subscribed    BOOLEAN DEFAULT true,
  source        TEXT  -- e.g. 'contact_form', 'blog_signup', 'assessment'
);

ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Owner access only" ON newsletter_subscribers
  FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Public insert" ON newsletter_subscribers
  FOR INSERT WITH CHECK (true);


-- -----------------------------------------------
-- 4. SERVICE_INQUIRIES (maps contacts to services)
-- -----------------------------------------------
CREATE TABLE service_inquiries (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at    TIMESTAMPTZ DEFAULT now(),
  contact_id    UUID REFERENCES contacts(id) ON DELETE CASCADE,
  service_name  TEXT NOT NULL,  -- e.g. 'AI Readiness Assessment', 'AI Strategy Workshop'
  message       TEXT,
  budget_range  TEXT,
  timeline      TEXT
);

ALTER TABLE service_inquiries ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Owner access only" ON service_inquiries
  FOR ALL USING (auth.role() = 'authenticated');


-- -----------------------------------------------
-- USEFUL VIEWS
-- -----------------------------------------------

-- Quick pipeline view: contacts with their latest status
CREATE VIEW pipeline AS
  SELECT
    c.full_name,
    c.email,
    c.company_name,
    c.industry,
    c.company_size,
    c.status,
    c.created_at AS lead_date,
    ar.maturity_score,
    ar.ai_recommendation
  FROM contacts c
  LEFT JOIN assessment_results ar ON ar.contact_id = c.id
  ORDER BY c.created_at DESC;

-- ============================================================
-- END OF SCHEMA
-- ============================================================