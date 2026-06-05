-- ════════════════════════════════════════════════════════════════
-- Migration: Enable anon-key enrollment flow (supabase_flutter 1.x)
-- Run this in Supabase Dashboard → SQL Editor → New query
-- ════════════════════════════════════════════════════════════════

-- ─── Step 1: Drop FK constraint on enrollments → users ────────
-- The app uses anonymous UUID (no login) so there is no row in
-- the users table. Dropping this FK lets us insert enrollments
-- directly without needing a matching user row first.
ALTER TABLE enrollments
  DROP CONSTRAINT IF EXISTS enrollments_user_id_fkey;

-- Also drop FK on course_progress → users (same reason)
ALTER TABLE course_progress
  DROP CONSTRAINT IF EXISTS course_progress_user_id_fkey;

-- ─── Step 2: enrollments RLS ──────────────────────────────────
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own enrollments"  ON enrollments;
DROP POLICY IF EXISTS "Users can create their own enrollments" ON enrollments;
DROP POLICY IF EXISTS "Users can update their own enrollments" ON enrollments;
DROP POLICY IF EXISTS "anon_select_enrollments" ON enrollments;
DROP POLICY IF EXISTS "anon_insert_enrollments"  ON enrollments;
DROP POLICY IF EXISTS "anon_update_enrollments"  ON enrollments;

CREATE POLICY "anon_select_enrollments" ON enrollments FOR SELECT USING (true);
CREATE POLICY "anon_insert_enrollments"  ON enrollments FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_update_enrollments"  ON enrollments FOR UPDATE USING (true);

-- ─── Step 3: course_progress RLS ──────────────────────────────
ALTER TABLE course_progress ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own progress"   ON course_progress;
DROP POLICY IF EXISTS "Users can insert their own progress" ON course_progress;
DROP POLICY IF EXISTS "Users can update their own progress" ON course_progress;
DROP POLICY IF EXISTS "anon_select_progress" ON course_progress;
DROP POLICY IF EXISTS "anon_insert_progress" ON course_progress;
DROP POLICY IF EXISTS "anon_upsert_progress" ON course_progress;

CREATE POLICY "anon_select_progress" ON course_progress FOR SELECT USING (true);
CREATE POLICY "anon_insert_progress" ON course_progress FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_upsert_progress"  ON course_progress FOR UPDATE USING (true);

-- ─── Step 4: favorite_courses RLS ─────────────────────────────
ALTER TABLE favorite_courses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can manage their own favorites" ON favorite_courses;
DROP POLICY IF EXISTS "anon_all_favorites" ON favorite_courses;

CREATE POLICY "anon_all_favorites" ON favorite_courses
  FOR ALL USING (true) WITH CHECK (true);

-- ─── Step 5: certificates (create if missing + RLS) ───────────
CREATE TABLE IF NOT EXISTS certificates (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL,
  course_id       UUID NOT NULL,
  issued_at       TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  certificate_url TEXT,
  UNIQUE(user_id, course_id)
);

CREATE INDEX IF NOT EXISTS idx_certificates_user ON certificates(user_id);

ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own certificates"  ON certificates;
DROP POLICY IF EXISTS "Users can create their own certificates" ON certificates;
DROP POLICY IF EXISTS "anon_select_certificates" ON certificates;
DROP POLICY IF EXISTS "anon_insert_certificates" ON certificates;

CREATE POLICY "anon_select_certificates" ON certificates FOR SELECT USING (true);
CREATE POLICY "anon_insert_certificates"  ON certificates FOR INSERT WITH CHECK (true);
